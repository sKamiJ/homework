function outputImg = arCoding(inputImg)
%将图片转为uint8格式
if ~isa(inputImg, 'uint8')
	inputImg = im2uint8(inputImg);
end
%算术编码
[arithCodedData,srtdCnt,index,dimensions] = arithmeticCode(inputImg);
%算术解码
decodedData = arithmeticDecode(arithCodedData,srtdCnt,index,dimensions);
%赋给输出图像
outputImg = uint8(decodedData);
end

%算术编码
function [arithCodedData,srtdCnt,index,dimensions] = arithmeticCode(data)
%计算像素点个数
dimensions = size(data);
dataSize = 1;
for i = 1: length(dimensions)
  dataSize = dataSize * dimensions(i);
end
%统计各像素点数量
data = reshape(data,dataSize,1);
[count,index] = imhist(data);
countnz = count(count>0);
indexnz = index(count>0);
%排序
[srtdCnt,srtIndx] = sort(countnz);
index = indexnz(srtIndx);
lengthInd = length(index);
%映射符号
data1 = zeros(dataSize,1);
for j = 1 : dataSize
	for m = 1 : lengthInd
        if data(j) == index(m)
            data1(j) = m;
        end
	end
end
%对符号序列进行算术编码
arithCodedData = arithenco(data1,srtdCnt);
end

%算术解码
function [decodedData] = arithmeticDecode(arithCodedData,srtdCnt,index,dimensions)
%计算像素点个数
dataSize = 1;
for i = 1: length(dimensions)
    dataSize = dataSize * dimensions(i);
end
%进行算术解码
decodedData1 = arithdeco(arithCodedData,srtdCnt,dataSize);
%重新映射符号
decodedData = zeros(length(decodedData1),1);
for i = 1:length(decodedData1)
    for l = 1:length(index)
        if decodedData1(i) == l
            decodedData(i) = index(l);
        end
    end
end
%根据符号重排图像
if length(dimensions) > 2   %RGB图像
    decodedDataRS = reshape(decodedData,dimensions(1),dimensions(2),dimensions(3));
elseif length(dimensions) > 1   %灰度图像
    decodedDataRS = reshape(decodedData,dimensions(1),dimensions(2));
else	%一维图像
    decodedDataRS = decodedData;
end
%输出解码结果
decodedData = decodedDataRS;
end