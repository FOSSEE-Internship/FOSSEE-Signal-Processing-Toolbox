// Test # 3 : Incorrect number of output Arguments
exec('./allpasslp2xn.sci',-1);
[n,d,e]=allpasslp2xn([0.1,0.2],[0.4,.76]);
//!--error 59
//Wrong number of output arguments
