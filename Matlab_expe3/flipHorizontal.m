function outputImg = flipHorizontal(inputImg)
%��ȡͼƬά��
dd = size(inputImg,3);
%���ҷ�ת
for i = 1:dd
    outputImg(:,:,i) = fliplr(inputImg(:,:,i));
end