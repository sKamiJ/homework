function outputImg = rotate90(inputImg)
%��ȡͼƬά��
dd = size(inputImg,3);
%˳ʱ����ת90��
for i = 1:dd
    outputImg(:,:,i) = rot90(inputImg(:,:,i));
end