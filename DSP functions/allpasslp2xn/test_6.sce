// Test #6 : Invalid flag test
exec('./allpasslp2xn.sci',-1);
[n,d]=allpasslp2xn([0.4 0.6],[0.3,0.4],'j');
//!--error 10000
//Invalid option,input should be either pass or stop
//at line      60 of function allpasslp2xn called by :  
//[n,d]=allpasslp2xn([0.4 0.6],[0.3,0.4],'j');
