function outputImg = cannyOperatorSegmentation(inputImg)
%��ͼƬתΪuint8��ʽ
if ~isa(inputImg, 'uint8')
	inputImg = im2uint8(inputImg);
end
%��RGBͼ��תΪ�Ҷ�ͼ��
if(size(inputImg,3) ~= 1)
    grayImg = rgb2gray(inputImg);
else
    grayImg = inputImg;
end
%Canny���ӷָ�
g = im2uint8(edge(grayImg,'canny'));
%���ָ�ͼ����ʾ��ԭͼ��
outputImg = inputImg;
%��ȡ��ά
[mm,nn,dd] = size(inputImg);
for i = 1 : mm
    for j = 1 : nn
        for k = 1 : dd
            if(g(i,j) == 255)
                outputImg(i,j,k) = 255;
            end
        end
    end
end