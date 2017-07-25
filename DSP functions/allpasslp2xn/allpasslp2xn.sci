function [AllpassNum,AllpassDen]= allpasslp2xn(Wo,Wt,varargin)
    
    if argn(2)<2 | argn(2)>3 then
        error("Number of input arguments should be either 2 or 3");
    end
    
    if argn(1)<1 | argn(1)>2 then
        error("Number of output arguments should be either 1 or 2");
    end
    
    if length(Wo)<1 | ~isreal(Wo) then
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
    
    if length(Wt)<1 | ~isreal(Wt) then
        error("Wt must be vector and real");
    end
    
    n=length(Wt);
    
    for i= 1:n
        if Wt(i) <=-1 | Wt(i) >=1 then
            error("Wt must be in normalised");
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

endfunction

