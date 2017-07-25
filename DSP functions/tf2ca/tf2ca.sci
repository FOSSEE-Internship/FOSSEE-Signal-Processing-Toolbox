function [d1,d2,be] = tf2ca(b,a)
// Transfer function to coupled allpass
//
//Calling Sequences
//
//[d1,d2] = tf2ca(b,a) where b is a real, symmetric vector of numerator coefficients and a is a real vector of denominator coefficients, corresponding to a stable digital filter, returns real vectors d1 and d2 containing the denominator coefficients of the allpass filters H1(z) and H2(z)
//
//[d1,d2] = tf2ca(b,a) where b is a real, antisymmetric vector of numerator coefficients and a is a real vector of denominator coefficients, corresponding to a stable digital filter, returns real vectors d1 and d2 containing the denominator coefficients of the allpass filters H1(z) and H2(z) such that
//
//H(z)=B(z)A(z)=(1/2)[H1(z)−H2(z)]
//
//[d1,d2,be] = tf2ca(b,a) returns complex vectors d1 and d2 containing the denominator coefficients of the allpass filters H1(z) and H2(z), and a complex scalar beta, satisfying |beta| = 1, such that
//
//H(z)=B(z)A(z)=(1/2)[β'*H1(z)+β*H2(z)]
//
//Input Parameters: 
//                      b: Vector of numerator coefficients of the digital filters
//                      a: Vector of denominator coefficients of the digital filters
//
//Output Parameters:
//                      d1: Denominator coefficient of the all pass filter H1(z)
//                      d2: Denominator coefficient of the all pass filter H2(z)
//                      be: Complex Scalar
//
//Example: 
//                      [b,a]=cheby1(9,.5,.4);
//                      [d1,d2]=tf2ca(b,a);
//                      num = 0.5*conv(fliplr(d1),d2)+0.5*conv(fliplr(d2),d1);
//                      den = conv(d1,d2);
//
//Author: Shrenik Nambiar
//
//References: S. K. Mitra, Digital Signal Processing, A Computer Based Approach, McGraw-Hill, N.Y., 1998 
// Input Validation Statements
//
    if argn(2)~=2 then
        error("Only 2 input arguments allowed");
    end
    
    if argn(1)<1 | argn(1)>3 then
        error("The number of output arguments should be 1-3");
    end
    
    if ~(or(size(b)==1) & or(size(a)==1)) then
        error("vectors must not be of size 1");
    end
    
    if length(b)~=length(a) then
        error("Both the vectors must be of equal length");
    end
//Converting the vectors into row vectors
    b=b(:).' ;
    a=a(:).' ;
    
    if ~(isreal(b) & isreal(a)) then
        error("Vectors must be real");
    end
    
    t= %eps^(2/3);      //tolerance

//To make sure the numerator is either symmetric or anti-symmetric
    if max(abs(b- b($:-1:1))) <= t then
        symm=1;
    elseif max(abs(b+b($:-1:1))) <= t then
        symm=2;
    else
        symm= 0;
    end
    
    if symm==0 then
        error("Numerator coeffcients must be either be symmetric or antisymmetric");
    end
    
    try
        [c,a]= iirpowcomp(b,a);
    catch
        continue;
    end
    c=c' ;
    [m,n]= numsort(b,c);      //for sorting the numerators
    
    [d1,d2,be]= allpassd(m,n,a); //computing the denominator coefficients
    
endfunction


function [m,n]= numsort(b,c)

//If b is anti-symmetric then make b the second argument
    if max(abs(b+b($:-1:1)))< %eps^(2/3) then
        m=c;
        n=b;
    else
        m=b;
        n=c;
    end
    
endfunction

function [d1,d2,be]= allpassd(m,n,a)

//if n is real and anti-symmetric, maake n imaginary
    if isreal(n) & (max(abs(n+n($:-1:1))) < %eps^(2/3)) then
        n=n*%i;
    end
    
    z= roots(m - n*%i);
    
    d1=1;
    d2=1;
// Separate the zeros inside the unit circle and the ones outside to form the allpass functions

    for l=1:length(z)
        if abs(z(l))<1
            d2= conv(d2,[1 -z(l)]);
        else
            d1= conv(d1,[1 -1/conj(z(l))]);
        end
        
    end

// To remove the roundoff imaginary parts
    if max(abs(imag(d1))) < %eps^(2/3) then
        d1= real(d1);
    end
    if max(abs(imag(d2))) < %eps^(2/3) then
        d2= real(d2);
    end
    
    be= sum(d2)*(sum(m)+%i*sum(n))./sum(a)./sum(conj(d2));
    
endfunction

