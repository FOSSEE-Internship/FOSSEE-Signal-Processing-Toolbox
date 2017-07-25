// Test #2 : Excess Input Arguments
exec('./tf2cl.sci',-1);
[k1,k2,b]=tf2cl([0.5 -0.9 0.5],[1 2 3],7);
//!--error 58 
//Wrong number of input arguments. 
