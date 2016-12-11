function outputImg = rotate90(inputImg)
%获取图片维度
dd = size(inputImg,3);
%顺时针旋转90度
for i = 1:dd
    outputImg(:,:,i) = rot90(inputImg(:,:,i));
end