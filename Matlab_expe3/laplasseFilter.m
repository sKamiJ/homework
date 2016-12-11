function outputImg = laplasseFilter(inputImg)
%将图片转为double格式
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%拉普拉斯算子
l = [1 1 1;1 -8 1;1 1 1];
%拉普拉斯滤波
outputImg = inputImg - imfilter(inputImg, l, 'replicate');