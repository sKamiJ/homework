function outputImg = fourierTransform(inputImg)
%��RGBͼ��תΪ�Ҷ�ͼ��
if(size(inputImg,3) ~= 1)
    inputImg = rgb2gray(inputImg);
end
%��ά��ɢ����Ҷ�任
fftI = fft2(inputImg);
%ֱ�������Ƶ�Ƶ������
sfftI = fftshift(fftI);
%ȡ����Ҷ�任��ʵ��
RR = real(sfftI);
%ȡ����Ҷ�任���鲿
II = imag(sfftI);
%����Ƶ�׷�ֵ
A = sqrt(RR.^2 + II.^2);
%��һ��
A = (A - min(min(A))) / (max(max(A)) - min(min(A))) * 225;
%�������ͼ��
outputImg = A;