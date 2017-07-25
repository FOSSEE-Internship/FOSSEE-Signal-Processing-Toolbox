// Test # 4 : Checking the type for Input Argument #3 
exec('./zpklp2xn.sci',-1);
[z,p,k,n,d]=zpklp2xn(0.1,2,[2 9],[3 0.4],[0.1,0.6]);
// !--error 10000 
//K must be a scalar
//at line      45 of function zpklp2xn called by :  
//[z,p,k,n,d]=zpklp2xn(0.1,[2 9],[3 0.4],[0.1,0.6])
