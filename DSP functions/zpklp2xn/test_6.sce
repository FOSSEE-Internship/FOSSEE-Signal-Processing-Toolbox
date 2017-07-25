// Test # 6 : Range test for Input Argument #4 or Input Argument #5
exec('./zpklp2xn.sci',-1);
[z,p,k,n,d]=zpklp2xn(0.2,1,4,[2 0.9],[4,0.7]);
//!--error 10000
//Wo must be in normalised and ascending form
//at line      56 of function zpklp2xn called by :  
//[z,p,k,n,d]=zpklp2xn(0.2,1,4,[5 0.9],[0.4,0.7]);
