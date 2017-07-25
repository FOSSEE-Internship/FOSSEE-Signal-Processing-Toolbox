// Test #8 : For valid input case #1
exec('./allpasslp2xn.sci',-1);
[n,d]=allpasslp2xn([0.2 0.5 0.7],[0.4,0.7,0.9],'pass');
disp(d);
disp(n);
//
//Scilab Output
//d= 1.                   0.4208078     -0.9021130  -0.2212317  
//n=  0.2212317    0.9021130     -0.4208078  -1.  
//
//Matlab Output
//n= 0.2212     0.9021  -0.4208     -1.0000 
//d= 1.0000     0.4208  -0.9021     -0.2212

