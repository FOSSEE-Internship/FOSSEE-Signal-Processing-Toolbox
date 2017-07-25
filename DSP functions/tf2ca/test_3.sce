// Test # 3 : Excess output Arguments
exec('./tf2ca.sci',-1);
[d1,d2,b,c]=tf2ca([0.1 0.5 0.1],[1 2 3]);
//!--error 59 
//Wrong number of output arguments.
