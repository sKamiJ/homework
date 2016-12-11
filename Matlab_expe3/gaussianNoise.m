function outputImg = gaussianNoise(inputImg)
%将图片转为double格式
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%生成高斯噪声
noise = imnoise(zeros(size(inputImg)),'gaussian',0,0.001);
%在原图上添加高斯噪声
outputImg = inputImg + noise;