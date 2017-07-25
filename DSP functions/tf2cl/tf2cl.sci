function [k1,k2,c]= tf2cl(b,a)
// Transfer function to coupled allpass lattice
//
//Calling Sequences
//
// [k1,k2] = tf2cl(b,a) where b is a real, symmetric vector of numerator coefficients and a is a real vector of denominator coefficients, corresponding to a stable digital filter, will perform the coupled allpass decomposition of a stable IIR filter H(z) and convert the allpass transfer functions H1(z) and H2(z) to a coupled lattice allpass structure with coefficients given in vectors k1 and k2.
//
// H(z)=B(z)A(z)=(1/2)[H1(z)+H2(z)]
//
//[k1,k2] = tf2cl(b,a) where b is a real, antisymmetric vector of numerator coefficients and a is a real vector of denominator coefficients, corresponding to a stable digital filter, performs the coupled allpass decomposition of a stable IIR filter H(z) and convert the allpass transfer functions H1(z) and H2(z) to a coupled lattice allpass structure with coefficients given in vectors k1 and k2.
//
// H(z)=B(z)A(z)=(1/2)[H1(z)−H2(z)]
//
// [k1,k2,be] = tf2cl(b,a) performs the generalized allpass decomposition of a stable IIR filter H(z) and converts the complex allpass transfer functions H1(z) and H2(z) to corresponding lattice allpass filters
// H(z)=B(z)A(z)=(1/2)[β'*H1(z)+β*H2(z)]
//Input Parameters: 
//                      b: Vector of numerator coefficients of the digital filters
//                      a: Vector of denominator coefficients of the digital filters
//
//Output Parameters:
//                      k1 & k2: Coefficients of coupled lattice allpass structure given in vectors
//                      be: Complex Scalar
//
//Example:
//              [b,a]=cheby1(9,.5,.4);
//              [k1,k2]=tf2cl(b,a);
//              [num1,den1]=latc2tf(k1,'allpass');
//              [num2,den2]=latc2tf(k2,'allpass');
//              num = 0.5*conv(num1,den2)+0.5*conv(num2,den1);
//              den = conv(den1,den2);
//
// Author: Shrenik Nambiar
//
//References: S. K. Mitra, Digital Signal Processing, A Computer Based Approach, McGraw-Hill, N.Y., 1998 
// Input validation statements
//
    if argn(2)~=2 then
        error("Only 2 input arguments allowed");
    end
    
    if argn(1)<1 | argn(1)>3 then
        error("The number of output arguments allowed are 1-3");
    end
    

    [d1,d2,c]= tf2ca(b,a);

// To obtain the coefficients of the coupesd all pass filters
    k1= tf2latc(1,d1);
    k2= tf2latc(1,d2);
endfunction








