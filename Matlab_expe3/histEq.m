function outputImg = histEq(inputImg)
%获取图片维度
dd = size(inputImg,3);
%直方图均衡化
for i = 1:dd
    outputImg(:,:,i) = histeq(inputImg(:,:,i));
end