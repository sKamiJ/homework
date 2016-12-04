function outputImg = grayLevelImg(inputImg)
%将RGB图像转为灰度图像
if(size(inputImg,3) ~= 1)
    inputImg = rgb2gray(inputImg);
end
%赋给输出图像
outputImg = inputImg;