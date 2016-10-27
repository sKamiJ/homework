%��ȡͼ2
img = imread('./ͼ2.png');
%����תΪ�Ҷ�ͼ��
img = rgb2gray(img);
%��ʾԭʼͼ��
subplot(2,2,1), imshow(img), title('ԭʼͼ��');
%��ʾԭʼͼ���ֱ��ͼ
subplot(2,2,3), imhist(img), title('ԭʼͼ���ֱ��ͼ');
%��ȡͼ��߶�����
[height,width] = size(img);
%ͳ��ÿ���Ҷȵ�������
m = zeros(1,256);
for i = 1 : height
    for j = 1 : width
        m(img(i,j) + 1) = m(img(i,j) + 1) + 1;
    end
end
%ͳ��ÿ���Ҷȵ�Ƶ��
for i = 1 : 256
    m(i) = m(i) / (height * width * 1.0);
end
%�����ۼƷֲ�
for i = 2 : 256;
    m(i) = m(i-1) + m(i);
end
%��������
m = uint8(255 .* m + 0.5);
%����ֱ��ͼ���⻯
for i = 1 : height
    for j = 1 : width
        img(i,j) = m(img(i,j) + 1);
    end
end
%��ʾֱ��ͼ���⻯��ͼ��
subplot(2,2,2), imshow(img), title('ֱ��ͼ���⻯��ͼ��');
%��ʾֱ��ͼ���⻯��ͼ���ֱ��ͼ
subplot(2,2,4), imhist(img), title('ֱ��ͼ���⻯��ͼ���ֱ��ͼ');