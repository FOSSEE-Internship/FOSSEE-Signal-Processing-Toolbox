// Test #7 : When either numerator or denominator have complex cefficients
exec('./tf2ca.sci',-1);
[d1,d2,b]=tf2ca([0.03 -0.5 -0.5 0.03],[1 2.4 -33*%i 22]);
//!--error 10000 
//Vectors must be real
//at line      56 of function tf2ca called by :  
//[d1,d2,b]=tf2ca([0.03 -0.5 -0.5 0.03],[1 2.4 -33*%i 22]
