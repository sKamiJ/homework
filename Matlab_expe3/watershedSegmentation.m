function outputImg = watershedSegmentation(inputImg)
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
%ʹ���ݱ��˫����
grayImg = double(grayImg);
%����Sobel����
h = fspecial('sobel');
g = sqrt(imfilter(grayImg,h,'replicate').^2 + imfilter(grayImg,h','replicate').^2);
%�����㣬���С��
g2 = imclose(imopen(g,ones(3,3)),ones(3,3));
%���˵�һЩ�ر�С�ľֲ���С
im = imextendedmin(g2,10);
%���о���任����ˮ�ӱ任
lim = watershed(bwdist(im));
%���ݱ�Եת��Ϊ��ֵͼ
em = lim == 0;
%ǿ����С��������Ҫ��λ���оֲ���С
g3 = imimposemin(g2,im|em);  
%����watershed
g4 = watershed(g3);
%���ָ�ͼ����ʾ��ԭͼ��
outputImg = inputImg;
%��ȡ��ά
[mm,nn,dd] = size(inputImg);
for i = 1 : mm
    for j = 1 : nn
        for k = 1 : dd
            if(g4(i,j) == 0)
                outputImg(i,j,k) = 255;
            end
        end
    end
end