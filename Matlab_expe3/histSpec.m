function outputImg = histSpec(inputImg)
%Ŀ��ֱ��ͼ
h = 0 : 255;
h = h / 255;
%��ȡͼƬά��
dd = size(inputImg,3);
%ֱ��ͼ�涨��
for i = 1:dd
    outputImg(:,:,i) = histeq(inputImg(:,:,i),h);
end