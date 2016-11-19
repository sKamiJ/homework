clc,clear all;
I=imread('rice.png');	%读取图像
Id=im2double(I);		 	%将无符号8位图像转为双精度类型
T=dctmtx(8); 			%创建离散余弦变换矩阵
B=blkproc(Id,[8 8],' P1*x*P2 ',T,T'); 	%分块正变换

mask=[  1 1 1 0 0 0 0 0 
        1 1 0 0 0 0 0 0
        1 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0];					%二值掩模，用来压缩DCT系数

B2=blkproc(B,[8 8],' P1.*x ',mask);		%分块掩模运算
%注：此处可插入编解码部分
I2=blkproc(B2,[8 8],' P1*x*P2 ',T',T);	%分块逆变换
figure,subplot(1,2,1),imshow(I),title('原始图像');
subplot(1,2,2),imshow(I2),title('压缩图像');
