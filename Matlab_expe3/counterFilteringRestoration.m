function outputImg = counterFilteringRestoration(inputImg)
%将图片转为double格式
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%获取图片大小
[hei,wid,dd] = size(inputImg);
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
Pf = psf2otf(PSF,[hei,wid]);
%逆滤波复原
for i = 1:dd
    If = fft2(inputImg(:,:,i));
    outputImg(:,:,i) = ifft2(If./Pf);
end