function outputImg = fourierTransform(inputImg)
%将RGB图像转为灰度图像
if(size(inputImg,3) ~= 1)
    inputImg = rgb2gray(inputImg);
end
%二维离散傅立叶变换
fftI = fft2(inputImg);
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
outputImg = A;