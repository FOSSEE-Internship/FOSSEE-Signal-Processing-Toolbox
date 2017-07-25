// Zero,pole, gain frequency transformation

b = [0.1969,0.4449,0.4449,0.1969];          //[b,a]=ellip(3,0.1,30,0.409) (taken from matlab)
a = [1.0000,-0.1737,0.5160,-0.0588];
z = roots(b);
p = roots(a);
k = b(1);
[z1,p1,k1] = zpklp2mb(z, p, k, 0.5, [2 4 6 8]/10, 'pass');
[xm,fr]=frmag(b,a,256);
[xm1,fr1]=frmag(real(k1)*real(poly(z1,'s')), real(poly(p1,'s')),256);
scf(0);
plot(fr*2,20*log(abs(xm))/log(10),'b',fr1*2,20*log(abs(xm1))/log(10),'r');
xlabel('Normaliized Frequency');
ylabel('Magnituse(dB)');
title('Low pass to multi band pass');
[z2,p2,k2] = zpklp2hp(z, p, k, 0.5, 0.8);
[xm2,fr2]=frmag(real(k2)*real(poly(z2,'s')), real(poly(p2,'s')),256);
scf(1);
plot(fr*2,20*log(abs(xm))/log(10),'b',fr2*2,20*log(abs(xm2))/log(10),'r');
xlabel('Normaliized Frequency');
ylabel('Magnituse(dB)');
title('Low pass to high pass');
//
[z3,p3,k3] = zpklp2bp(z, p, k, 0.5, [0.45,0.75]);
[xm3,fr3]=frmag(real(k3)*real(poly(z3,'s')), real(poly(p3,'s')),256);
scf(2);
plot(fr*2,20*log(abs(xm))/log(10),'b',fr3*2,20*log(abs(xm3))/log(10),'r');
xlabel('Normaliized Frequency');
ylabel('Magnituse(dB)');
title('Low pass to band pass');
//
[z4,p4,k4] = zpklp2bs(z, p, k, 0.5, [0.4,0.7]);
[xm4,fr4]=frmag(real(k4)*real(poly(z4,'s')), real(poly(p4,'s')),256);
scf(3);
plot(fr*2,20*log(abs(xm))/log(10),'b',fr4*2,20*log(abs(xm4))/log(10),'r');
xlabel('Normaliized Frequency');
ylabel('Magnituse(dB)');
title('Low pass to band stop');
