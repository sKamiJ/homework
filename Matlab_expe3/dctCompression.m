function outputImg = dctCompression(inputImg)
%��ͼƬתΪdouble��ʽ
if ~isa(inputImg, 'double')
	inputImg = im2double(inputImg);
end
%������ɢ���ұ任����
T = dctmtx(8);
%��ֵ��ģ������ѹ��DCTϵ��
mask = [ 1 1 1 0 0 0 0 0 
         1 1 0 0 0 0 0 0
         1 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0 ];
%��ȡͼƬά��
dd = size(inputImg,3);
%DCTѹ��
for i = 1:dd
    %�ֿ����任
    B = blkproc(inputImg(:,:,i),[8 8],' P1*x*P2 ',T,T'); 	
    %�ֿ���ģ����
    B2 = blkproc(B,[8 8],' P1.*x ',mask);		
    %�ֿ���任
    outputImg(:,:,i) = blkproc(B2,[8 8],' P1*x*P2 ',T',T);
end
