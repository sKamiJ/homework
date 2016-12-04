function outputImg = wienerFilteringRestoration(inputImg)
%��ͼƬתΪdouble��ʽ
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%ά���˲���ԭ
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
outputImg = deconvwnr(inputImg, PSF, 0);