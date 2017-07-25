// Test # 1 : No Input Arguments
exec('./tf2cl.sci',-1);
[k1,k2,b]=tf2cl();
//!--error 10000 
//Only 2 input arguments allowed
//at line      38 of function tf2cl called by :  
//[d1,d2,b]=tf2cl();
