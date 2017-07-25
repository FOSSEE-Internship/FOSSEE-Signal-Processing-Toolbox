// Test # 4 : When numerator is neither symmetric or anti-symmetric
exec('./tf2cl.sci',-1);
//[d1,d2,b]=tf2cl([0.4 0.5 0.31],[6 32.4 -3])
//!--error 10000 
//Numerator coeffcients must be either be symmetric or antisymmetric
//at line      71 of function tf2ca called by :  
//at line      46 of function tf2cl called by :  
//[d1,d2,b]=tf2cl([0.4 0.5 0.31],[6 32.4 -3])
