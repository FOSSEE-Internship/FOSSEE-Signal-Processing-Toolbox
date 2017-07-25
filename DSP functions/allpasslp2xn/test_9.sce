// Test #9 : For valid input case #2
exec('./allpasslp2xn.sci',-1);
[n,d]=allpasslp2xn([0.12 0.65 0.7],[0.4,0.9 0.97],'stop');
disp(d);
disp(n);
//
//Scilab Output
//d=1.                  2.5769939    2.1642515    0.5838982  
//n=0.5838982    2.1642515    2.5769939    1.  
//
//Matlab Output
//n= 0.5839     2.1643      2.5770      1.0000 
//d= 1.0000     2.5770      2.1643      0.5839
