clc,clear all;
I=imread('cameraman.tif');
J=dct2(I);
K=idct2(J);
figure,subplot(1,3,1),imshow(uint8(I));
subplot(1,3,2),imshow(uint8(abs(J)));
subplot(1,3,3),imshow(uint8(K));
