%��ȡͼ2
img = imread('./ͼ2.png');
%����תΪ�Ҷ�ͼ��
img = rgb2gray(img);
%��ʾԭʼͼ��
subplot(2,3,1), imshow(img), title('ԭʼͼ��');
%��ʾԭʼͼ���ֱ��ͼ
subplot(2,3,4), imhist(img), title('ԭʼͼ���ֱ��ͼ');
%��ʾĿ��ֱ��ͼ
h = 0 : 255;
h = h / 255;
subplot(2,3,3), plot(h), title('Ŀ��ֱ��ͼ');
%����ֱ��ͼ�涨��
img = histeq(img, h);
%��ʾֱ��ͼ�涨����ͼ��
subplot(2,3,2), imshow(img), title('ֱ��ͼ�涨����ͼ��');
%��ʾֱ��ͼ�涨����ͼ���ֱ��ͼ
subplot(2,3,5), imhist(img), title('ֱ��ͼ�涨����ͼ���ֱ��ͼ');