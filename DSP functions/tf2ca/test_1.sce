// Test # 1 : No Input Arguments
exec('./tf2ca.sci',-1);
[d1,d2,b]=tf2ca();
//!--error 10000 
//Only 2 input arguments allowed
//at line      37 of function tf2ca called by :  
//[d1,d2,b]=tf2ca();
