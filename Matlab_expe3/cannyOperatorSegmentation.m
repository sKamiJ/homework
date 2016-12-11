function outputImg = cannyOperatorSegmentation(inputImg)
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
%Canny算子分割
g = im2uint8(edge(grayImg,'canny'));
%将分割图像显示至原图上
outputImg = inputImg;
%获取三维
[mm,nn,dd] = size(inputImg);
for i = 1 : mm
    for j = 1 : nn
        for k = 1 : dd
            if(g(i,j) == 255)
                outputImg(i,j,k) = 255;
            end
        end
    end
end