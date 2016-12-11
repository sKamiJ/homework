function outputImg = motionBlur(inputImg)
%将图片转为double格式
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%设置形变参数
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
%生成运动模糊图像
outputImg = imfilter(inputImg, PSF, 'circular');
