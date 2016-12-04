function outputImg = huffmanCoding(inputImg)
%��ͼƬתΪuint8��ʽ
if ~isa(inputImg, 'uint8')
	X = im2uint8(inputImg);
else
    X = inputImg;
end
%��ȡ��ά
[mm,nn,dd] = size(X);
%��ÿ��ά�Ƚ��й��������벢����
for i = 1:dd
    %����������
    vec = reshape(X(:,:,i),1,mm*nn);
    [zipped, info] = huffencode(vec);
    %����������
    af_vec = huffdecode(zipped, info);
    XX(:,:,i) = reshape(af_vec,mm,nn);
    %�������ͼ��
    outputImg(:,:,i) = uint8(XX(:,:,i));
end
end


%����frequency��������ų��ֵĸ���
function f = frequency(vector)
f = zeros(1, 256);
len = length(vector);
for index = 0:255
    f(index+1) = sum(vector == uint8(index));
end
f = f./len;   %��һ��
end

%����addnode��ӽڵ�
function codeword_new = addnode(codeword_old, item)
codeword_new = cell(size(codeword_old));
for index = 1:length(codeword_old)
    codeword_new{index} = [item codeword_old{index}];
end
end

% ����������
function [zipped, info] = huffencode(vector)
% ������������ uint8 ��ʽ
% info ���ؽ�����Ҫ�Ľṹ��Ϣ
% info.pad ����ӵı�����
% info.huffcodes �� Huffman ����
% info.rows ��ԭʼͼ������
% info.cols ��ԭʼͼ������
% info.length ��ԭʼͼ�����ݳ���
% info.maxcodelen ������볤

[m, n] = size(vector);
vector = vector(:)';
f = frequency(vector);      %��������ų��ֵĸ���
symbols = find(f~=0);
f = f(symbols);
[f, sortindex] = sort(f);    %�����Ű��ճ��ֵĸ��ʴ�С����
symbols = symbols(sortindex);
len = length(symbols);
symbols_index = num2cell(1:len);
codeword_tmp = cell(len, 1);

% ���� Huffman �����õ����ֱ����
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
for index = 1:length(vector)       %�õ�����ͼ�����б�����
    len = len + length(codeword{double(vector(index))+1});
end
string = repmat(uint8(0), 1, len);
pointer = 1;
for index = 1:length(vector)       %������ͼ����б���
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
    
%����ѹ��������
cols = length(string)/8;
string = reshape(string, 8, cols);
weights = 2.^(0: 7);
zipped = uint8(weights * double(string));
    
%���洢��һ��ϡ�����
huffcodes = sparse(1, 1);
for index = 1:nnz(codeword)
    huffcodes(codeword(index), 1) = symbols(index);
end
    
%��д����ʱ����Ľṹ��Ϣ
info.pad = pad;
info.huffcodes = huffcodes;
info.ratio = cols./length(vector);
info.length = length(vector);
info.maxcodelen = maxcodelen;
info.rows = m;
info.cols = n;
end

%����decode�������ֶ�Ӧ�ķ���
function byte = decode(code, info)
byte = info.huffcodes(code);
end

% ����������
function vector = huffdecode(zipped, info)
% �������������vector����Huffman���룬���ؽ�ѹ���ͼ������

%����0��1���У�ÿλռһ���ֽ�
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

%��ʼ����
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

