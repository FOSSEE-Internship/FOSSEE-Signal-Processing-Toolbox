// Test # 3 : Incorrect number of output Arguments
exec('./zpklp2xn.sci',-1);
[z,p,k,n,d,e]=zpklp2xn(0.3,2,8,[0.8,0.9],[0.2 0.5]);
//!--error 59
//Wrong number of output arguments
