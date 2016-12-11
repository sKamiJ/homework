function outputImg = dctTransformation(inputImg)
%将图片转为uint8格式
if ~isa(inputImg, 'uint8')
	inputImg = im2uint8(inputImg);
end
%获取图片维度
dd = size(inputImg,3);
%离散余弦变换
for i = 1:dd
    outputImg(:,:,i) = uint8(abs(dct2(inputImg(:,:,i))));
end