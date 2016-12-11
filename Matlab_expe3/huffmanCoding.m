function outputImg = huffmanCoding(inputImg)
%将图片转为uint8格式
if ~isa(inputImg, 'uint8')
	X = im2uint8(inputImg);
else
    X = inputImg;
end
%获取三维
[mm,nn,dd] = size(X);
%对每个维度进行哈夫曼编码并解码
for i = 1:dd
    %哈夫曼编码
    vec = reshape(X(:,:,i),1,mm*nn);
    [zipped, info] = huffencode(vec);
    %哈夫曼解码
    af_vec = huffdecode(zipped, info);
    XX(:,:,i) = reshape(af_vec,mm,nn);
    %赋给输出图像
    outputImg(:,:,i) = uint8(XX(:,:,i));
end
end


%函数frequency计算各符号出现的概率
function f = frequency(vector)
f = zeros(1, 256);
len = length(vector);
for index = 0:255
    f(index+1) = sum(vector == uint8(index));
end
f = f./len;   %归一化
end

%函数addnode添加节点
function codeword_new = addnode(codeword_old, item)
codeword_new = cell(size(codeword_old));
for index = 1:length(codeword_old)
    codeword_new{index} = [item codeword_old{index}];
end
end

% 哈夫曼编码
function [zipped, info] = huffencode(vector)
% 输入和输出都是 uint8 格式
% info 返回解码需要的结构信息
% info.pad 是添加的比特数
% info.huffcodes 是 Huffman 码字
% info.rows 是原始图像行数
% info.cols 是原始图像列数
% info.length 是原始图像数据长度
% info.maxcodelen 是最大码长

[m, n] = size(vector);
vector = vector(:)';
f = frequency(vector);      %计算各符号出现的概率
symbols = find(f~=0);
f = f(symbols);
[f, sortindex] = sort(f);    %将符号按照出现的概率大小排列
symbols = symbols(sortindex);
len = length(symbols);
symbols_index = num2cell(1:len);
codeword_tmp = cell(len, 1);

% 生成 Huffman 树，得到码字编码表
while length(f)>1
    index1 = symbols_index{1};
    index2 = symbols_index{2};
    codeword_tmp(index1) = addnode(codeword_tmp(index1), uint8(0));
    codeword_tmp(index2) = addnode(codeword_tmp(index2), uint8(1));
    f = [sum(f(1:2)),f(3:end)];
    symbols_index = [{[index1, index2]},symbols_index(3:end)];
    [f, sortindex] = sort(f);
    symbols_index = symbols_index(sortindex);
end
codeword = cell(256, 1);
codeword(symbols) = codeword_tmp;
len = 0;
for index = 1:length(vector)       %得到整个图像所有比特数
    len = len + length(codeword{double(vector(index))+1});
end
string = repmat(uint8(0), 1, len);
pointer = 1;
for index = 1:length(vector)       %对输入图像进行编码
    code = codeword{double(vector(index))+1};
    len = length(code);
    string(pointer + (0:len-1))=code;
    pointer = pointer + len;
end
len = length(string);
pad = 8-mod(len, 8);
if pad > 0
    string = [string uint8(zeros(1, pad))];
end
codeword = codeword(symbols);
codelen = zeros(size(codeword));
weights = 2.^(0:23);
maxcodelen = 0;
for index = 1:length(codeword)
    len = length(codeword{index});
    if len > maxcodelen;
        maxcodelen = len;
    end
    if len > 0
        code = sum(weights(codeword{index} == 1));
        code = bitset(code, len + 1);
        codeword{index} = code;
        codelen(index) = len;
    end
end
codeword = [codeword{:}];
    
%计算压缩的向量
cols = length(string)/8;
string = reshape(string, 8, cols);
weights = 2.^(0: 7);
zipped = uint8(weights * double(string));
    
%码表存储到一个稀疏矩阵
huffcodes = sparse(1, 1);
for index = 1:nnz(codeword)
    huffcodes(codeword(index), 1) = symbols(index);
end
    
%填写解码时所需的结构信息
info.pad = pad;
info.huffcodes = huffcodes;
info.ratio = cols./length(vector);
info.length = length(vector);
info.maxcodelen = maxcodelen;
info.rows = m;
info.cols = n;
end

%函数decode返回码字对应的符号
function byte = decode(code, info)
byte = info.huffcodes(code);
end

% 哈夫曼解码
function vector = huffdecode(zipped, info)
% 函数对输入矩阵vector进行Huffman解码，返回解压后的图像数据

%产生0，1序列，每位占一个字节
len = length(zipped);
string = repmat(uint8(0), 1, len.*8);
bitindex = 1:8;
for index = 1:len
    string(bitindex + 8.*(index-1)) = uint8(bitget(zipped(index), bitindex));
end
string = logical(string(:)');
len = length(string);
string ((len-info.pad+1):end)=[];
len = length(string);

%开始解码
vector = repmat(uint8(0), 1, info.length);
vectorindex = 1;
codeindex = 1;
code = 0;
for index = 1:len
    code = bitset(code, codeindex, string(index));
    codeindex = codeindex+1;
    byte = decode(bitset(code, codeindex), info);
    if byte > 0
        vector(vectorindex) = byte-1;
        codeindex = 1;
        code = 0;
        vectorindex = vectorindex + 1;
    end
end
vector = reshape(vector, info.rows, info.cols);
end

