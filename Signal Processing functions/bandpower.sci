function power= bandpower(varargin)
// To find the bandpower of an input signal
// Calling sequences
//
//power= bandpower(x) : It returns the average power of the input matrix,x
//
//power= bandpower(x,fs,freqrange) : Returns the average power in the frequency range whose length must be 2. This function uses periodogram to determine the average power.
//
//power= bandpower(pxx,f,'psd') : In this case the average power is computed by integrating the power spectral density estimate,pxx. The input f is a vector of frequencies corresponding to pxx. 'psd' indicates its not time series data.
//
//power= bandpower(pxx,f,freqrange,'psd') : Similar to the above type except the average power is computed within the frequency range specified.
//
//Input parameters:
//                  x: Time series input of type double or scalar
//                  fs: Sampling frequency and must be positive scalar
//                  freqrange: The frequency range within which the average power is to be computed
//                  pxx: Power spectral density estimates. Must be nonnegatuve of type double or inte//ger 
//                  f: Frequency vector for psd estimates. Must be of type double or integer
//
//Output Parameters:
//
//                  power: Average band power of type double or integer.
//
//Example: Create a signal consisting of a 100 Hz sine wave in additive N(0,1) white Gaussian noise.
//              t = 0:0.001:1-0.001;
//              x = cos(2*pi*100*t)+randn(size(t));
//              p = bandpower(x)
//Author: Shrenik Nambiar
//
//Input validation statements
//
//
    if(argn(1) ~= 1) then
        error(" Only one output argument allowed");
    end
    if(argn(2)<1 | argn(2)>4 | argn(2)== 2) then
        error("The no. of input arguments should be 1,3 or 4");
    end

    flag= find(strcmpi(varargin(:),'psd'));
    varargin(flag)= [];
    
    if (flag) then
        power= bandpowerfrompsd(varargin(1),varargin(2),varargin(3));
    else
        power= bandpowerfromsignal(varargin(1),varargin(2),varargin(3));
    end
    
endfunction

function power  = bandpowerfromsignal(x,fs,freqrange)

// To convert the vector into column vector
    if isvector(x) then
        x=x(:);
    end

// THe input vector should either be a 1D vector or a 2D matrix 
    if (ndims(x)~= 1 | ndims(x)~= 2) then
        error(" x should either be a vector or 2 matrix");
    end

//Checking for argument type
    if(type(x)~= 1 | type(x)~= 8) then
        error(" Argument should be of type int or double");
    end
    
//Performing Typecasting
    x=double(x);

// When the function has only 1 input parameter
    if(argn(2)== 1) then
        x2=x.^2;
        power= sum(x2,'r');
    end
    
// fs must be positive scalar
    if length(fs)~= 1 then
        error("fs must not be a vector");
    end
    
    if(type(fs)~= 1 | type(fs)~= 8) then
        error(" Argument should be of type int or double");
    end
    fs= double(fs);
    
// Checking the freqrange parameter
    if ~isempty(freqrange) then
        if length(freqrange)~=2 then
            error("freqrange must be a vector of 2 elements");
        end
        if(type(freqrange)~= 1 | type(freqrange)~= 8) then
            error(" Argument should be of type int or double");
        end
        if freqrange(1)>=freqrange(2) then
            error("1st element should be smaller than the second element");
        end

//Performing Typecasting
        freqrange = double(freqrange(:));
    end
    
    n = size(x,1);
    
    if isreal(x) then 
        [pxx, f] = periodogram(x, hamming(n), n, fs);
    else
        [pxx, f] = periodogram(x, hamming(n), n, fs, 'centered');
    end
    power = bandpowerfrompsd(pxx, f, freqrange);
    
endfunction

function power= bandpowerfrompsd(pxx,f,freqrange)

//Making it column vector
    if isvector(pxx) then
        pxx=pxx(:);
    end
    
    if ndims(pxx)<1 | ndims(pxx)>2 then
        error("Wrong dimesnion for argument #1 (pxx); must be vector or a 2D matrix");
    end
    
    if(type(pxx)~= 1 | type(pxx)~= 8) then
        error(" Argument should be of type int or double");
    end

// All the elements of pxx must b non-negative
    for i=1:length(pxx)
        if(pxx(i)<0) then
            error("pxx must be non negative")
        end
    end

//Performing Typecasting
    pxx = double(pxx);
    
//Checking the f parameter
    if ~isvector(f) | size(pxx,1)~=length(f) then
        error(" f should be a vector of same size as pxx");
    end
    if(type(f)~= 1 | type(f)~= 8) then
        error("Argument should be of type int or double");
    end
    
    if (diff(f)<=0) then
        error("f must be strictly increasing");
    end
    f = double(f(:));

//Checking for freqrange parameter
    if ~isempty(freqrange) then
        
        if length(freqrange)~=2 then
            error("freqrange must be a vector of 2 elements");
        end
        if(type(freqrange)~= 1 | type(freqrange)~= 8) then
            error("Argument should be of type int or double");
        end
        
        if freqrange(1)>=freqrange(2) then
            error("1st element should be smaller than the second element");
        end

        if freqrange(1)<f(1) | freqrange(2)>f($) then
            error("freqrange should lie between f"); 
        end
        freqrangeflag=true;
        freqrange = double(freqrange(:));
    else
        
        freqrange= [f(1) f($)];
        freqrangeflag= false;
    
    end
    
    f = f(:);
    index1= find(f<=freqrange(1),1); 
    index2= find(f>=freqrange(2),1);
    
//As we are approximating the integral using the rectangle method, we must find the width of the rectangle

    binwidth= diff(f);

//For n is even,the nyquist point is fs/2, hence the emissing range is at the beginning of the vector
    if freqrangeflag then
        lastbinwidth=0;
        binwidth= [binwidth; lastbinwidth];
    else
        
//if the no. of points is odd, then the missing frequencies is present at both ends,but as the signal spectrum is symmetric the missing frequency can be assumedto be at the bginning of the vector
        missingbinwidth = (f($) - f(1)) / (length(f) - 1);
        centre = (f(1)==0);
        if ~centre then
            binwidths = [missingbinwidth; binwidths];
        else
            binwidths = [binwidths; missingbinwidth];
        end
    end
    power = binwidths(index1:index2)'*pxx(index1:index2,:);
    
endfunction
