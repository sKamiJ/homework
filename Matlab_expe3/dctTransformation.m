function outputImg = dctTransformation(inputImg)
%��ͼƬתΪuint8��ʽ
if ~isa(inputImg, 'uint8')
	inputImg = im2uint8(inputImg);
end
%��ȡͼƬά��
dd = size(inputImg,3);
%��ɢ���ұ任
for i = 1:dd
    outputImg(:,:,i) = uint8(abs(dct2(inputImg(:,:,i))));
end