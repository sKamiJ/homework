function outputImg = laplasseFilter(inputImg)
%��ͼƬתΪdouble��ʽ
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%������˹����
l = [1 1 1;1 -8 1;1 1 1];
%������˹�˲�
outputImg = inputImg - imfilter(inputImg, l, 'replicate');