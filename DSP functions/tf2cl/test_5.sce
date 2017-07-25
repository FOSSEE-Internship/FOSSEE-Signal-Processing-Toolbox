// Test #5 : Vaid Input case
exec('./tf2cl.sci',-1);
[k1,k2,b]=tf2cl([0.5 -0.9 0.5],[1 2 3]);
disp(b);
disp(k2);
disp(k1);
//
//Scilab Output
//b=-0.6154156 + 0.7883950i  
//k2=0.3328796 + 0.4710837i  
//k1=0.3328796 - 0.4710837i  
//
//Matlab Output
//k1=0.3329 - 0.4711i
//k2= 0.3329 + 0.4711i
//b= -0.6154 + 0.7884i
