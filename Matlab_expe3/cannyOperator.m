function outputImg = cannyOperator(inputImg)
%��RGBͼ��תΪ�Ҷ�ͼ��
if(size(inputImg,3) ~= 1)
    inputImg = rgb2gray(inputImg);
end
%Canny���ӷָ�
outputImg = im2uint8(edge(inputImg,'canny'));