// Test # 2 : Excess Input Arguments
exec('./zpklp2xn.sci',-1);
[z,p,k,n,d]=zpklp2xn(3,1,7,[0.5 0.9],[0.4 0.5],'pass',3);
// !--error 10000 
//Number of input arguments should either be 5 or 6
//at line      37 of function zpklp2xn called by :  
//[z,p,k,n,d]=zpklp2xn(3,1,7,[0.5 0.9],[0.4 0.5],'pass',3)
