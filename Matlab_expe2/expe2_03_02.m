clc,clear all;
I=imread('rice.png');	%��ȡͼ��
Id=im2double(I);		 	%���޷���8λͼ��תΪ˫��������
T=dctmtx(8); 			%������ɢ���ұ任����
B=blkproc(Id,[8 8],' P1*x*P2 ',T,T'); 	%�ֿ����任

mask=[  1 1 1 0 0 0 0 0 
        1 1 0 0 0 0 0 0
        1 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 
        0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0];					%��ֵ��ģ������ѹ��DCTϵ��

B2=blkproc(B,[8 8],' P1.*x ',mask);		%�ֿ���ģ����
%ע���˴��ɲ������벿��
I2=blkproc(B2,[8 8],' P1*x*P2 ',T',T);	%�ֿ���任
figure,subplot(1,2,1),imshow(I),title('ԭʼͼ��');
subplot(1,2,2),imshow(I2),title('ѹ��ͼ��');
