// Test # 3 : Excess Output Arguments
exec('./tf2cl.sci',-1);
[k1,k2,b]=tf2cl([0.5 -0.9 0.5],[1 2 3]);
//!--error 59 
//Wrong number of output arguments. 
