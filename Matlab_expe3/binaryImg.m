function outputImg = binaryImg(inputImg)
%将其转为二值化图像
outputImg = im2uint8(im2bw(inputImg));