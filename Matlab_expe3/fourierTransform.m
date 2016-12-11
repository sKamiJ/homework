function outputImg = fourierTransform(inputImg)
%��ȡͼƬά��
dd = size(inputImg,3);
%��ÿһάͼ����д���
for i = 1:dd
    %��ά��ɢ����Ҷ�任
    fftI = fft2(inputImg(:,:,i));
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
    outputImg(:,:,i) = A;
end