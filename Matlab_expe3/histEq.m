function outputImg = histEq(inputImg)
%��ȡͼƬά��
dd = size(inputImg,3);
%ֱ��ͼ���⻯
for i = 1:dd
    outputImg(:,:,i) = histeq(inputImg(:,:,i));
end