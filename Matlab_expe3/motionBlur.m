function outputImg = motionBlur(inputImg)
%��ͼƬתΪdouble��ʽ
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%����˶�ģ��
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
outputImg = imfilter(inputImg, PSF, 'conv', 'circular');