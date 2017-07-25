function [varargout]= sfdr(varargin)
    
    if(argn(1)<0 | argn(1)>3) then
        error("Output arguments should lie between 0 and 3");
    end
    
    if(argn(2)<1 | argn(2)>4) then
        error("Input arguments should lie between 1 and 4");
    end
    
    if (~isvector(x) & (type(x) ~=8 | type(x) ~= 1)) then
        error("x should be a vector of type doule or integer");
    end
    
    if (~isscalar(fs) & fs<0) then
        error("fs must be positive scalar");
    end
    
    if (~isscalar(msd) & msd<0) then
        error("msd must be positive scalar");
    end
    
    if(~isvector(sxx) & (type(sxx) ~=8 | type(sxx) ~= 1) & sxx<0) then
        error("power estimate vector must be non-negative vector of type double or integer");
    end
    
    if(~isvector(f) & (type(f) ~=8 | type(f) ~= 1)) then
        error(" f must be a vector of type double or integer");
    end
    
    if argn(1)==0 then
        flag=1;
    else 
        flag=0;
    end
    if(argn(2)<2) then
        x=varargin(1);
        fs=1;
        msd=0;
        [r, spurpow, spurfreq]= timesfdr(x,fs,msd);
    elseif(argn(2)==2) then
        x=varargin(1);
        fs=varargin(2);
        msd=0;
        [r, spurpow, spurfreq]= timesfdr(x,fs,msd);
    elseif(argn(2)==3 & type(varargin(3)~=10)) then
        x=varargin(1);
        fs=varargin(2);
        msd=varargin(3);
        [r, spurpow, spurfreq]= timesfdr(x,fs,msd);
    elseif(argn(2) == 3 & strcmpi(varargin(3),'power')) then
        sxx= varargin(1);
        f= varargin(2);
        msd=0;
        [r, spurpow, spurfreq]= powersfdr(sxx,f,msd);
    elseif(argn(2)== 4 & strcmpi(varargin(4),'power')) then
        sxx= varargin(1) ;
        f= varargin(2);
        msd= varargin(3);
        [r, totdistpow]= powersfdr(sxx,f,msd);
    else
        error("The valid flag is power");
    end
    
endfunction

function [r,totdistpow] = timesfdr(flag,x,fs,msd)
    
    if max(size(x))==length(x)  then
        x=x(:);
    end
    n= length(x);
    x=x-mean(x);
    w= window('kr',n,38);
    rbw= enbw(w,fs);
    [pxx, f] = periodogram(x,w,n,fs);
    
    signalCopy=pxx;
    pxx(1)= 2*pxx(2);
    [pfreq,rfreq,ifreq,left,right] = dcremove(pxx,f,rbw,0);
    pxx(left:right)= 0;
    dcindex = [left;right];
    
    [pfreq,rfreq,ifreq,left,right] = dcremove(pxx,f,rbw);
    pxx(left:right)= 0;
    freqindex = [left;right];
    
    pxx(abs(f-ffreq)<msd) = 0;
    
    [s,spurbin] = max(pxx);
    [pspur, fspur, ispur] = dcremove(pxx, f, rbw, f(spurbin));

    r = 10*log10(pfreq/ pspur);
    spurpow = 10*log10(pspur);
    spurfreq = fspur;
    
    if flag then
        pfreq = 10*log10(rbw*signalCopy(ifreq));
        pspur = 10*log10(rbw*signalCopy((ispur)));
        ffreq = F(ifund);
        fspur = F(ispur);
        
        plotsfdr(signalCopy,f,rbw,ffreq,pfreq,freqindex,fspur,pspur,dcindex);
    end
endfunction

    
function [leftbin, rightbin] = peakborder(sxx, f, fundfreq, freqbin, msd)
    leftbin = find(sxx(2:freqbin) < sxx(1:freqbin-1),1,'last');
    rightbin = freqbin + find(sxx(freqbin+1:end) > sxx(freqbin:$-1),1,'first')-1;
    if isempty(leftbin)
        leftbin = 1;
    end

    if isempty(rightbin)
        rightbin = length(sxx);
    end

    leftbinex  = find(F <= fundfreq - msd, 1, 'last');
    rightbinex = find(fundfreq + msd < f, 1, 'first');
    if ~isempty(leftbinex) & leftbinex < leftbin
        leftbin = leftbinex;
    end
    if ~isempty(rightbinex) & rightbinex > rightbin
        rightbin = rightbinex;
    end

endfunction

function[r,spurpow, spurfreq] = powersfdr (flag,sxx,f,msd)
    
    if(f(1) ~=0) then
        error("sxx must be one-sided");
    end

    sigSCopy = sxx;
    
    sxx(1) = 2*sxx(1);
    lastindex = find(sxx(1:$-1)<sxx(2:$),1,'first');
    if ~isempty(lastindex)
        sxx(1:lastindex) = 0;
    end
    dcindex = [1; lastindex];

    [freqpow, freqbin] = max(sxx);
    fundfreq = f(freqbin);

    [leftbin, rightbin] = peakborder(sxx, f, fundfreq, freqbin, msd);
    sxx(leftbin:rightbin) = 0;
    freqindex = [leftbin; rightbin];
    [spurpow, spurbin] = max(sxx);

    r = 10*log10(freqpow / spurpow);
    freqpow = 10*log10(freqpow);    
    spurpow = 10*log10(spurpow);
    spurfreq = f(spurbin);
    
    if flag then
        plotsfdr(signalCopy,f,1,fundfreq,freqpow,freqindex,spurfreq,spurpow,dcindex);
    end
endfunction

function plotsfdr(pxx, f, rbw, ffreq, pfreq, freqindex, fspur, pspur, dcindex)
    pxx= pxx*rbw;
    
    xd= f(freqindex(1):freqindex(2));
    yd= 10*log10(pxx(freqindex(1):freqindex(2)));
    plot(xd,yd,'r');
    
    xd = [f(1:freqindex(1)); %nan; f(freqindex(2):$)];
    yd = 10*log10([pxx(1:freqindex(1)); %nan; pxx(freqindex(2):$)]);
    plot(xd, yd,'g');


    xData = F(dcIdx(1):dcIdx(2));
    yData = 10*log10(pxx(dcindex(1):dcindex(2)));
    plot(xd, yd,'b');
    
endfunction
function [power, fr, indextone, indexleft, indexright]= dcremove(pxx, f, rbw, tonefreq)
    
      if(f(1)<=tonefreq & tonefreq<=f($)) then
          [s, indextone] = min(abs(f-tonefreq));
          iLeft = max(1,indextone-1);
          iRight = min(indextone+1,length(pxx));
          [s, indexmax] = max(pxx(iLeft:iRight));
          indextone = iLeft+indexmax-1;
      else
          power = %nan;
          fr = %nan;
          indextone = [];
          indexleft = [];
          indexright = [];
      end
      
    indexleft = indextone - 1;
    indexright = indextone + 1;
    while indexleft > 0 & pxx(indexleft) <= pxx(indexleft+1)
        indexleft = indexleft - 1;
    end


    while indexright <= length(pxx) & pxx(indexright-1) >= pxx(indexright)
        indexright = indexright + 1;
    end

    indexleft = indexleft+1;
    indexright = indexright-1;
    ffreq = f(indexleft:indexright);
    sfreq = pxx(indexleft:indexright); 
    fr = (ffreq.*sfreq) ./ sum(sfreq);
    
    if (indexleft<indexright) then
       power = bandpower(pxx(indexleft:indexright),f(indexleft:indexright),'psd');
    elseif 1 < indexright & indexright < length(pxx)
         power = pxx(indexright) * (f(indexright+1) - f(indexright-1))/2;
    else

         power = pxx(indexright) * mean(diff(f));
    end


    if (power < rbw*pxx(indextone)) then
         power = rbw*pxx(indextone);
         fr = f(indextone);
    end
endfunction

