%读取图2
img = imread('./图2.png');
%将其转为灰度图像
img = rgb2gray(img);
%显示原始图像
subplot(2,3,1), imshow(img), title('原始图像');
%显示原始图像的直方图
subplot(2,3,4), imhist(img), title('原始图像的直方图');
%显示目标直方图
h = 0 : 255;
h = h / 255;
subplot(2,3,3), plot(h), title('目标直方图');
%进行直方图规定化
img = histeq(img, h);
%显示直方图规定化后图像
subplot(2,3,2), imshow(img), title('直方图规定化后图像');
%显示直方图规定化后图像的直方图
subplot(2,3,5), imhist(img), title('直方图规定化后图像的直方图');