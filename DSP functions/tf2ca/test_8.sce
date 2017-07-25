// Test #8: When numerator and denominator have differents lengths
exec('./tf2ca.sci',-1);
[d1,d2,b]=tf2ca([0.03 -0.5 -0.5 0.03],[1 2.4 -33);
//!--error 10000 
//Both the vectors must be of equal length
//at line      49 of function tf2ca called by :  
//[d1,d2,b]=tf2ca([0.03 -0.5 -0.5 0.03],[1 2.4 -33]
