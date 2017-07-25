// Test #8 : When output arguments are less than 5
exec('./zpklp2xn.sci',-1);
[z,p,k]=zpklp2xn(8,2,0.5,[0.1 0.5],[0.5,0.75]);
disp(k);
disp(p);
disp(z);
//
//Scilab Output
//k =2.1009558  
//p  = 0.1427731 + 0.6153536i  
//       0.1427731 - 0.6153536i  
//z= 0.2093027  
//     -0.0054340
//
//Matlab Output
//z = 0.2093 -0.0054
//p = 0.1428 + 0.6154i 
//       0.1428 - 0.6154i
//k = 2.1010
