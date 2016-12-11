function outputImg = arCoding(inputImg)
%��ͼƬתΪuint8��ʽ
if ~isa(inputImg, 'uint8')
	inputImg = im2uint8(inputImg);
end
%��������
[arithCodedData,srtdCnt,index,dimensions] = arithmeticCode(inputImg);
%��������
decodedData = arithmeticDecode(arithCodedData,srtdCnt,index,dimensions);
%�������ͼ��
outputImg = uint8(decodedData);
end

%��������
function [arithCodedData,srtdCnt,index,dimensions] = arithmeticCode(data)
%�������ص����
dimensions = size(data);
dataSize = 1;
for i = 1: length(dimensions)
  dataSize = dataSize * dimensions(i);
end
%ͳ�Ƹ����ص�����
data = reshape(data,dataSize,1);
[count,index] = imhist(data);
countnz = count(count>0);
indexnz = index(count>0);
%����
[srtdCnt,srtIndx] = sort(countnz);
index = indexnz(srtIndx);
lengthInd = length(index);
%ӳ�����
data1 = zeros(dataSize,1);
for j = 1 : dataSize
	for m = 1 : lengthInd
        if data(j) == index(m)
            data1(j) = m;
        end
	end
end
%�Է������н�����������
arithCodedData = arithenco(data1,srtdCnt);
end

%��������
function [decodedData] = arithmeticDecode(arithCodedData,srtdCnt,index,dimensions)
%�������ص����
dataSize = 1;
for i = 1: length(dimensions)
    dataSize = dataSize * dimensions(i);
end
%������������
decodedData1 = arithdeco(arithCodedData,srtdCnt,dataSize);
%����ӳ�����
decodedData = zeros(length(decodedData1),1);
for i = 1:length(decodedData1)
    for l = 1:length(index)
        if decodedData1(i) == l
            decodedData(i) = index(l);
        end
    end
end
%���ݷ�������ͼ��
if length(dimensions) > 2   %RGBͼ��
    decodedDataRS = reshape(decodedData,dimensions(1),dimensions(2),dimensions(3));
elseif length(dimensions) > 1   %�Ҷ�ͼ��
    decodedDataRS = reshape(decodedData,dimensions(1),dimensions(2));
else	%һάͼ��
    decodedDataRS = decodedData;
end
%���������
decodedData = decodedDataRS;
end