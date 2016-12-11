function outputImg = motionBlur(inputImg)
%��ͼƬתΪdouble��ʽ
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%�����α����
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
%�����˶�ģ��ͼ��
outputImg = imfilter(inputImg, PSF, 'circular');
