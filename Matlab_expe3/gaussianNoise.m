function outputImg = gaussianNoise(inputImg)
%��ͼƬתΪdouble��ʽ
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%���ɸ�˹����
noise = imnoise(zeros(size(inputImg)),'gaussian',0,0.001);
%��ԭͼ����Ӹ�˹����
outputImg = inputImg + noise;