function outputImg = motionBlur(inputImg)
%将图片转为double格式
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%添加运动模糊
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
outputImg = imfilter(inputImg, PSF, 'conv', 'circular');