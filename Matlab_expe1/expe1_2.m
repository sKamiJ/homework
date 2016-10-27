%读取图2
img = imread('./图2.png');
%将其转为灰度图像
img = rgb2gray(img);
%显示原始图像
subplot(2,2,1), imshow(img), title('原始图像');
%显示原始图像的直方图
subplot(2,2,3), imhist(img), title('原始图像的直方图');
%获取图像高度与宽度
[height,width] = size(img);
%统计每个灰度的像素数
m = zeros(1,256);
for i = 1 : height
    for j = 1 : width
        m(img(i,j) + 1) = m(img(i,j) + 1) + 1;
    end
end
%统计每个灰度的频数
for i = 1 : 256
    m(i) = m(i) / (height * width * 1.0);
end
%计算累计分布
for i = 2 : 256;
    m(i) = m(i-1) + m(i);
end
%四舍五入
m = uint8(255 .* m + 0.5);
%进行直方图均衡化
for i = 1 : height
    for j = 1 : width
        img(i,j) = m(img(i,j) + 1);
    end
end
%显示直方图均衡化后图像
subplot(2,2,2), imshow(img), title('直方图均衡化后图像');
%显示直方图均衡化后图像的直方图
subplot(2,2,4), imhist(img), title('直方图均衡化后图像的直方图');