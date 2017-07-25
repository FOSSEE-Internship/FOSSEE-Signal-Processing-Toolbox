// Test # 4 : When numerator is neither symmetric or anti-symmetric
exec('./tf2ca.sci',-1);
[d1,d2,b]=tf2ca([0.1 0.5 -0.1],[1 2 3]);
//!--error 10000 
//Numerator coeffcients must be either be symmetric or antisymmetric
//at line      71 of function tf2ca called by :  
//[d1,d2,b]=tf2ca([0.1 0.5 -0.1],[1 2 3])
