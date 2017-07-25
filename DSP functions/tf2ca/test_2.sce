// Test # 1 : Excess Input Arguments
exec('./tf2ca.sci',-1);
[d1,d2,b]=tf2ca([0.1 0.5 0.1],[1 2 3],3);
//!--error 58 
//Wrong number of input arguments. 
