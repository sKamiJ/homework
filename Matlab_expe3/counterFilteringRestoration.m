function outputImg = counterFilteringRestoration(inputImg)
%��ͼƬתΪdouble��ʽ
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%��ȡͼƬ��С
[hei,wid,dd] = size(inputImg);
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
Pf = psf2otf(PSF,[hei,wid]);
%���˲���ԭ
for i = 1:dd
    If = fft2(inputImg(:,:,i));
    outputImg(:,:,i) = ifft2(If./Pf);
end