function outputImg = flipVertical(inputImg)
%��ȡͼƬά��
dd = size(inputImg,3);
%���·�ת
for i = 1:dd
    outputImg(:,:,i) = flipud(inputImg(:,:,i));
end