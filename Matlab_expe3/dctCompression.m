function outputImg = dctCompression(inputImg)
%将图片转为double格式
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%创建离散余弦变换矩阵
T = dctmtx(8);
%二值掩模，用来压缩DCT系数
mask = [ 1 1 1 0 0 0 0 0 
         1 1 0 0 0 0 0 0
         1 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 ];
%获取图片维度
dd = size(inputImg,3);
%DCT压缩
for i = 1:dd
    %分块正变换
    B = blkproc(inputImg(:,:,i),[8 8],' P1*x*P2 ',T,T'); 	
    %分块掩模运算
    B2 = blkproc(B,[8 8],' P1.*x ',mask);		
    %分块逆变换
    outputImg(:,:,i) = blkproc(B2,[8 8],' P1*x*P2 ',T',T);
end
