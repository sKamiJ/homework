function outputImg = wienerFilteringRestoration(inputImg)
%将图片转为double格式
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%维纳滤波复原
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
outputImg = deconvwnr(inputImg, PSF, 0);