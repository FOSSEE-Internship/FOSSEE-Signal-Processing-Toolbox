// Test # 1 : No Input Arguments
exec('./zpklp2xn.sci',-1);
[z,p,k,n,d]=zpklp2xn();
// !--error 10000 
//Number of input arguments should either be 5 or 6
//at line      37 of function zpklp2xn called by :  
//[z,p,k,n,d]=zpklp2xn();
