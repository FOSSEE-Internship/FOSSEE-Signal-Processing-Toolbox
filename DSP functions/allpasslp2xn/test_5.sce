// Test #5 : Input Argument #1 or #2 range test
exec('./allpasslp2xn.sci',-1);
[n,d]=allpasslp2xn([1.1,0.9],[0.3,0.8]);
//!--error 10000
//Wo must be in normalised
//at line      19 of function allpasslp2xn called by :  
//[n,d]=allpasslp2xn([1.1,0.9],[0.3,0.8]);
