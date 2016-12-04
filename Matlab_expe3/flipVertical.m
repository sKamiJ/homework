function outputImg = flipVertical(inputImg)
%获取图片维度
dd = size(inputImg,3);
%上下翻转
for i = 1:dd
    outputImg(:,:,i) = flipud(inputImg(:,:,i));
end