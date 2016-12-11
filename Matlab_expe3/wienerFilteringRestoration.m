function outputImg = wienerFilteringRestoration(inputImg)
%��ͼƬתΪdouble��ʽ
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%�����α����
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
%���ɸ�˹����
noise = imnoise(zeros(size(inputImg)),'gaussian',0,0.001);
%���������
NSR = sum(noise(:).^2) / sum(inputImg(:).^2);
%ά���˲���ԭ
outputImg = deconvwnr(inputImg, PSF, NSR);