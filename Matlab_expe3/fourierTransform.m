function outputImg = fourierTransform(inputImg)
%获取图片维度
dd = size(inputImg,3);
%对每一维图像进行处理
for i = 1:dd
    %二维离散傅立叶变换
    fftI = fft2(inputImg(:,:,i));
    %直流分量移到频谱中心
    sfftI = fftshift(fftI);
    %取傅立叶变换的实部
    RR = real(sfftI);
    %取傅立叶变换的虚部
    II = imag(sfftI);
    %计算频谱幅值
    A = sqrt(RR.^2 + II.^2);
    %归一化
    A = (A - min(min(A))) / (max(max(A)) - min(min(A))) * 225;
    %赋给输出图像
    outputImg(:,:,i) = A;
end