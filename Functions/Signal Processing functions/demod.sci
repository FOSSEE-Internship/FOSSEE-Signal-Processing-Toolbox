function [x1,varargout]= demod (y,fc,fs,method,varargin)
//Demodulation for communication systems
//Calling Sequences
//
//x = demod(y,fc,fs,'method')
//x = demod(y,fc,fs,'method',opt)
//x = demod(y,fc,fs,'pwm',centered)
//
//Input parameters: 
//              y: Real carrier signal
//              fc: Carrier frequency
//              fs: Sampling frequency
//              method: There are 9 methods for demodulating a modulated signal and a few of them//also accepts an extra parameter , opt

//              amdsb-sc or am:
//                    Amplitude demodulation (am), double sideband (sdb), suppressed carrier(sc) : Multiplies y by a sinusoid of frequency fc and applies a fifth-order Butterworth lowpass filter using filtfilt.
//
//              amdsb-tc:
//	           Amplitude demodulation, double sideband, transmitted carrier (tc). Multiplies y by a sinusoid of frequency fc and applies a fifth-order Butterworth lowpass filter using filtfilt.
//                   If opt is specified, demod subtracts scalar opt from x. The default value for opt is 0.

//              amssb:
//	           Amplitude demodulation, single sideband. Multiplies y by a sinusoid of frequency fc and applies a fifth-order Butterworth lowpass filter using filtfilt.
//
//              fm:
//                   Frequency demodulation. Demodulates the FM waveform by modulating the Hilbert transform of y by a complex exponential of frequency -fc Hz and obtains the instantaneous frequency of the result.
//
//              pm:
//                  Phase demodulation. Demodulates the PM waveform by modulating the Hilbert transform of y by a complex exponential of frequency -fc Hz and obtains the instantaneous phase of the result.
//
//              ppm:
//	          Pulse-position demodulation. Finds the pulse positions of a pulse-position modulated signal y. For correct demodulation, the pulses cannot overlap. x is length length(t)*fc/fs.
//
//              pwm:
//                  Pulse-width demodulation. Finds the pulse widths of a pulse-width modulated signal y. demod returns x a vector whose elements specify the width of each pulse in fractions of a period. The pulses in y should start at the beginning of each carrier period, that is, they should be left justified.
//
//              qam:
//                  Quadrature amplitude demodulation.
//
//                  [x1,x2] = demod(y,fc,fs,'qam') multiplies y by a cosine and a sine of frequency fc and applies a fifth-order Butterworth lowpass filter using filtfilt.
//
//              The default method is am.
//
//Output parameters:
//                  x1: Demodulated signal. In all cases except ppm and pwm,x is the same size as y
//
//
//Author: Shrenik Nambiar
//
//References:  B.P. Lathi, Modern digital and analog communication systems, Oxford University Press, 1998.
//                   Rappaport, Theodore S. Wireless Communications: Principles and Practice. Upper Saddle River, NJ: Prentice Hall, 1996
//
//Input validation statements

    [out,in] = argn(0);

    if(in ~=3 | in ~=4 | in~= 5) then
        error(" Number of Input parameters should either be 4 or 5");
    end
    
    if(out ~= 1 | out~= 2) then
        error("Number of output parameters should either be 1 or 2");
    end
    
//Checking whether the user entered arguments are of numeric type

    if(isnumeric(fc) & isnumeric(fs) & isnumeric(y)) then
        fc= float(fc);
        fs= float(fs);
        y= float(y);
    else
        error(" All three parameters should be of numeric type");
    end
    
//To check if it satisfies Nyquist Theorem
    if(~(fs > 2*fc)) then
        error("Not obeying the Nyquist theorem");
    end
    
    
    method= '';
    
    if(in == 3) then
        method= 'am';
    end
    
    [row,col] = size(y);
    if row==0 | col==0 then
        x1=[];
    end

// Column vector conversion
    if(row==1) then
        y=y(:);
        l=col;
    else
        l=row;
    end
    
//For each type of demoulation technique enterd by the user, one of the if elseif block will be executed
    if(strcmpi(method,'am') | strcmpi(method,'amdsb-sc')) | strcmpi(method,'amdsb-tc') | strcmpi(method,'amssb') then
        
        t= (0:1/fs:(l-1)/fs)';
        t=t(:,ones(1,size(y,2)));
        x1= y.*cos(2*%pi*fc*t);
        [b,a]= butter(5,fc*2/fs);
        
        for i=1:size(y,2)
            x1(:,i) = filtfilt(b,a,x1(:,i));
        end
        
        if strcmpi(method,'amdsb-tc') then
            if(in<5) then
                options=0;
            end
            options=float(options);
            
            x1=x1-options;
        end
        
    elseif(strcmpi(method,'fm')) then
        if(in<5) then
            options=1;
        end
        
        options=float(options);
        t= (0:1/fs:(l-1)/fs)';
        t=t(:,ones(1,size(y,2)));
        yh= hilbert(y).*exp(-%i*2*%pi*fc*t);
        x1= (1/options)*[zeros(1,size(yh,2));diff(unwrap(angle(yh)))];
     elseif(strcmpi(method,'pm')) then
        if(in<5) then
            options=1;
        end
        
        options=float(options);
        t= (0:1/fs:(l-1)/fs)';
        t=t(:,ones(1,size(y,2)));
        yh= hilbert(y).*exp(-%i*2*%pi*fc*t);
        x1= (1/options)*angle(yh);
     elseif(strcmpi(method,'pwm') & type(varargin(1))== 10) then
        y=y>0.5;                    //for thresholding purposes
        t= (0:1/fs:(l-1)/fs)';
        l= ceil(l*fc/fs);              //length of the signal
        x1= zeros(l,size(y,2));  //initializing the vector
        if(in<5) then
            options = 'left';
        end
        if(strcmpi(options,'centred')) then
            for i = 1:l,
                temp= t-(i-1)/fc;
                index= (temp >= -0.5/fc) & (temp<=0.5*fc);
                for j1= 1:size(y,2)
                    x1(i,j1) = sum(y(index,j1))*fc/fs;
                end
            end
        x1(1,:) = x1(1,:)*2;
        elseif(strcmpi(options,'left')) then
             for i=1:l,
                 temp = t-(i-1)/fc;
                 index= (temp>=0) & (temp <1/fc) ;
                 for j2= 1:size(y,2) 
                     x1(i,j2) = sum(y(index,j2))*fc/fs;
                 end
             end
        else
             error("Invalid option");
        end
        elseif(strcmpi(method,'ppm')) then
            y=y>0.5;
            t= (0:1/fs:(l-1)/fs)';
            l= ceil(l*fc/fs);           //length of the message signal
            x1= zeros(l,size(y,2));
            for i=1:l,
                 temp = t-(i-1);
                 index= find(temp>=0) & (temp <1) ;
                 for j3= 1:size(y,2)                //accessing each element columnwise
                     index2 = y(index,j3)==1; 
                     x1(i,j3) = temp(min(index,index2));
                 end
             end
        elseif(strcmpi(method,'qam')) then
             t= (0:1/fs:(len-1)/fs)';
             t=t(:,ones(1,size(y,2)));
             x1= 2*.y*cos(2*%pi*fc*t);
             x2= 2*.y*sin(2*%pi*fc*t);
             [b,a]= butter(5,fc*2/fs);
             for i=1:size(y,2)
                 x1(:,i)= filtfilt(b,a,x1(:,i));
                 x2(:,i)= filtfilt(b,a,x2(:,i));
             end
             
             if(row==1) then
                 x2=x2';            //converting to column vector
             end
        end
         
        if(row==1) then
             x1=x1';
        end

endfunction
