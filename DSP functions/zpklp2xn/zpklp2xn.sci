function [Z2, P2, K2, AllpassNum,AllpassDen]= zpklp2xn(Z, P ,K, Wo,Wt,varargin)
//Zero-pole-gain lowpass to M-band frequency transformation
//
//Calling Sequences
//
//[Z2,P2,K2,AllpassNum,AllpassDen] = zpklp2xn(Z,P,K,Wo,Wt) returns zeros, Z2, poles, P2, and gain factor, K2, of the target filter transformed from the real lowpass prototype by applying an Nth-order real lowpass to real multipoint frequency transformation, where N is the number of features being mapped. By default the DC feature is kept at its original location.
//
//[Z2,P2,K2,AllpassNum,AllpassDen] = zpklp2xn(Z,P,K,Wo,Wt,Pass) allows you to specify an additional parameter, Pass, which chooses between using the "DC Mobility" and the "Nyquist Mobility". In the first case the Nyquist feature stays at its original location and the DC feature is free to move. In the second case the DC feature is kept at an original frequency and the Nyquist feature is allowed to move.It also returns the numerator, AllpassNum, and the denominator, AllpassDen, of the allpass mapping filter. The prototype lowpass filter is given with zeros, Z, poles, P, and gain factor, K.
//
//Input Parameters:
//                      Z: Zeros of the prototype filter
//                      P: Poles of the prototype filter
//                      K: Gain of the prototype filter
//                      Wo: Frequency value of the prototype filter to be transformed
//                      Wt: Desired frquency of the target filter
//                      Pass: Choice ('pass'/'stop') of passband/stopband at DC, 'pass' being the default
//Output Parameters:
//                      Z2: Zeros of the target filter
//                      P2: Poles of the target filter
//                      K2:Gain factor of the target filter
//                      AllpassNum: Numerator of the mapping filter
//                      AllpassDen: Denominator of the mapping filter
//Example: Design a prototype real IIR halfband filter using a standard elliptic approach
//
//                        [b, a] = ellip(3,0.1,30,0.409);
//                        z = roots(b);
//                        p = roots(a);
//                        k = b(1);
//                        [z2,p2,k2] = zpklp2xn(z, p, k, [-0.5 0.5], [0 0.25], 'pass');
//
//Author: Shrenik Nambiar
//
//References: Cain, G.D., A. Krukowski and I. Kale, "High Order Transformations for Flexible IIR Filter Design," VII European Signal Processing Conference (EUSIPCO'94), vol. 3, pp. 1582-1585, Edinburgh, United Kingdom, September 1994.
//
//Input Validaton Statement
    if argn(2)<5 | argn(2)>6 then
        error("Number of input arguments should either be 5 or 6");
    end
    
    if argn(1)<1 | argn(1)>5 then
        error("Number of output arguments should be between 1 and 5");
    end
    
    if ~isscalar(K) then
        error("K must be a scalar");
    end
    
    if ~isvector(Wo) | ~isreal(Wo) then
        error("Wo must be vector and real");
    end
    
    m=length(Wo);
    
    for i= 1:m
        if Wo(i) <=-1 | Wo(i) >=1 then
            error("Wo must be in normalised");
        end
    end
    
    sortedWo=gsort(Wo,'r','i');
    if Wo~=sortedWo then
        error("Wo must in ascending order");
    end
    
    if ~isvector(Wt) | ~isreal(Wt) then
        error("Wt must be vector and real");
    end
    
    n=length(Wt);
    
    for i= 1:n
        if Wt(i) <=-1 | Wt(i) >=1 then
            error("Wt must be in normalised and ascending form");
        end
    end
    
    sortedWt=gsort(Wt,'r','i');
    if Wt~=sortedWt then
        error("Wt must in ascending order");
    end
    
//Flag checking
    if (length(varargin)==1) & (type(varargin(1))~=10) then
        error("Input argument #6 must be of type char");
    end
    
    if length(varargin)==0 then
        pass= -1;           //pass being the default option
    else
        Pa=varargin(1);
        select Pa
        case 'pass' then
            pass=-1;
        case 'stop' then
            pass=1;
        else
            error("Invalid option,input should be either pass or stop");
        end
    end
    
    
    zo = exp(%i*%pi*Wo);
    zn = exp(-%i*%pi*Wt);

    for k=1:m
        a(k,:) = zo(k) * (zn(k).^(m-1:-1:0)) - pass*(zn(k).^(1:m));
    end

    b = pass - zo.' .*(zn.' .^m);
    AllpassNum = real([1; a\b]);
    
    in= find(isnan(AllpassNum));
    if ~isempty(in) then
        AllpassNum= real([1 linsolve(a,b)])
    end
    
    AllpassDen = flipdim(AllpassNum(:).',2);
    AllpassNum = pass*AllpassNum(:).';

    if isstable(AllpassDen) then
        AllpassNum = flipdim(AllpassNum,2);
        AllpassDen = flipdim(AllpassDen,2);
    end
    
    z1= roots(AllpassNum);      //computing zeros 
    p1= roots(AllpassDen);      //computing poles
    k1= frmag(AllpassNum,AllpassDen,1);     //gain computation
    
    lp1= length(p1);
    z2=[];
    
// for cancelling overlapping poles and zeros
    p1index=zeros(1,lp1);
    for j=1:length(z1),
        fnd1 = find(abs(z1(j)-p1)<10^-6);
        fnd2 = find(p1index(fnd1)<%eps);
        fnd  = fnd1(fnd2);
        if isempty(fnd),
            z2 = [z2, z1(j)];
        else
            p1index(fnd(1)) = 1;
        end
    end
    
    p2= p1(p1index==0);
    p2=p2(:).';
    k2=k1;
//the case in which all poles and zeros are cancelled
    if isempty(z2) then
        z2=0;
    end
// Calculating the numerator and denominator for the mapping filter
    if length(z2) ~= m then
        AllpassNum =poly(z2,'s');
        AllpassDen = k2.*poly(p2,'s');
        s = sign(AllpassDen($));
        AllpassNum = AllpassNum./ s;
        AllpassDen = AllpassDen./AllpassDen($);

        [AllpassNum,AllpassDen] = eqtflength(flipdim((AllpassNum),2), flipdim((allpassden),2));
    
    end
    
    if or(AllpassNum~=1) | or(AllpassDen~=1) then
        Z2=[];
        P2=[];
        K2=K*prod(AllpassNum(1)-Z*AllpassDen(1))/prod(AllpassNum(1)-P*AllpassDen(1));
        
        for i=1:length(Z),
            Z2 = [Z2, roots(AllpassNum - Z(i).*AllpassDen).'];
        end
        for i=1:length(P),
            P2 = [P2, roots(AllpassNum - P(i).*AllpassDen).'];
        end
// For stabilizing the target filter (if unstable after tranformation)
        index = find(abs(P2)>1);
        K2 = K2/prod(1-P2(index));
        P2(index) = 1 ./conj(P2(index));
        K2= K2*prod(1-P2(index));
    else
        Z2=Z;
        P2=P;
        K2=K;
    end
    //Converting to Column vector
    Z2=Z2(:);
    P2=P2(:);

endfunction
