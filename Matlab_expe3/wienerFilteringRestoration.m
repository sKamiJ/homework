function outputImg = wienerFilteringRestoration(inputImg)
%将图片转为double格式
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%设置形变参数
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
%生成高斯噪声
noise = imnoise(zeros(size(inputImg)),'gaussian',0,0.001);
%计算信噪比
NSR = sum(noise(:).^2) / sum(inputImg(:).^2);
%维纳滤波复原
outputImg = deconvwnr(inputImg, PSF, NSR);