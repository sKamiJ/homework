function outputImg = watershedSegmentation(inputImg)
%将图片转为uint8格式
if ~isa(inputImg, 'uint8')
	inputImg = im2uint8(inputImg);
end
%将RGB图像转为灰度图像
if(size(inputImg,3) ~= 1)
    grayImg = rgb2gray(inputImg);
else
    grayImg = inputImg;
end
%使数据变成双精度
grayImg = double(grayImg);
%创建Sobel算子
h = fspecial('sobel');
g = sqrt(imfilter(grayImg,h,'replicate').^2 + imfilter(grayImg,h','replicate').^2);
%开运算，清除小点
g2 = imclose(imopen(g,ones(3,3)),ones(3,3));
%过滤掉一些特别小的局部最小
im = imextendedmin(g2,10);
%进行距离变换并做水坝变换
lim = watershed(bwdist(im));
%根据边缘转化为二值图
em = lim == 0;
%强制最小，仅在想要的位置有局部最小
g3 = imimposemin(g2,im|em);  
%进行watershed
g4 = watershed(g3);
%将分割图像显示至原图上
outputImg = inputImg;
%获取三维
[mm,nn,dd] = size(inputImg);
for i = 1 : mm
    for j = 1 : nn
        for k = 1 : dd
            if(g4(i,j) == 0)
                outputImg(i,j,k) = 255;
            end
        end
    end
end