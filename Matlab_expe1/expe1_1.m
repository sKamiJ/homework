%��ȡͼ1��ͼ2
img1 = imread('./ͼ1.jpg');
img2 = imread('./ͼ2.png');
%��ʾͼ1��ͼ2
subplot(1,2,1), imshow(img1), title('ͼ1');
subplot(1,2,2), imshow(img2), title('ͼ2');
%д��ͼ1��ͼ2
imwrite(img1,'./ͼ1_����.jpg');
imwrite(img2,'./ͼ2_����.png');