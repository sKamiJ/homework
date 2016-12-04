function outputImg = robertsOperator(inputImg)
%将RGB图像转为灰度图像
if(size(inputImg,3) ~= 1)
    inputImg = rgb2gray(inputImg);
end
%Roberts算子分割
outputImg = im2uint8(edge(inputImg,'roberts'));