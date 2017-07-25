// Test #4 : For less number of output arguments
exec('./iirpowcomp.sci',-1);
b=iirpowcomp([3.3 0.43],[1.21 0.12];
disp(b);
//
//Scilab Output
//b=- 4.2513585  
//    4.2513585  
//
//Matlab Output
//b= -4.2514    4.2514
