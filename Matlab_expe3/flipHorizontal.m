function outputImg = flipHorizontal(inputImg)
%获取图片维度
dd = size(inputImg,3);
%左右翻转
for i = 1:dd
    outputImg(:,:,i) = fliplr(inputImg(:,:,i));
end