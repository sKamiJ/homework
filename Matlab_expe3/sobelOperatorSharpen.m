function outputImg = sobelOperatorSharpen(inputImg)
%����Sobel����
h = fspecial('sobel');
%��ȡͼƬά��
dd = size(inputImg,3);
%Sobel������
for i = 1:dd
    outputImg(:,:,i) = filter2(h,inputImg(:,:,i));
end