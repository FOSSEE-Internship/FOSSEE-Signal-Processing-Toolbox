// Test #4 : Input Argument #1 or #2 is of complex type
exec('./allpasslp2xn.sci',-1);
[n,d]=allpasslp2xn([0.33 0.4],[%i,0.5]);
//!--error 10000
//Wt must be vector and real
//at line      29 of function allpasslp2xn called by :  
//[n,d]=allpasslp2xn([0.33 0.4],[%i,0.5]);
