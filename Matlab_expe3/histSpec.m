function outputImg = histSpec(inputImg)
%目标直方图
h = 0 : 255;
h = h / 255;
%获取图片维度
dd = size(inputImg,3);
%直方图规定化
for i = 1:dd
    outputImg(:,:,i) = histeq(inputImg(:,:,i),h);
end