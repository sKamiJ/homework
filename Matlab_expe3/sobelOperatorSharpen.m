function outputImg = sobelOperatorSharpen(inputImg)
%创建Sobel算子
h = fspecial('sobel');
%获取图片维度
dd = size(inputImg,3);
%Sobel算子锐化
for i = 1:dd
    outputImg(:,:,i) = filter2(h,inputImg(:,:,i));
end