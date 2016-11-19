clc,clear all;
symbol=['abc']          %��֪����ֵ��ַ��������̲����õ���
pr=[0.4 0.4 0.2]        %���ַ����ֵĸ���
disp('************************************');
format long;

in=['aabbc']
 
disp('*********��ʼ����*********');
%��̣�Ҫ������ʾÿһ�ֱ�����Ͻ���½�
low=0;
high=1;
len=length(in);
num=length(pr);
for i=1:len
    interval=zeros(1,num);
    interval(1)=low;
    width=high-low;
    for j=1:num
        interval(j+1)=interval(j)+width*pr(j);
    end
    switch(in(i))
        case 'a'
            k=1;
        case 'b'
            k=2;
        case 'c'
            k=3;
    end
    low=interval(k);
    high=interval(k+1);
    fprintf('�½�=%.6f\t�Ͻ�=%.6f\n',low,high);
end

disp('*********������*********');
value=low   %Ϊ�����ٽ�ЧӦ������ȡֵ(low+high)/2����ȫ
 
 
disp('*********��ʼ����*********');
%��̣�Ҫ������ʾÿһ�ֽ�����ֵ
low_char=[0.0 0.4 0.8];
out=zeros(1,len);
for i=1:len
    fprintf('����ֵ=%.6f\n',value);
    if(value>=low_char(1)&&value<low_char(2))
        out(i)='a';
        j=1;
    elseif(value>=low_char(2)&&value<low_char(3))
        out(i)='b';
        j=2;
    else
        out(i)='c';
        j=3;
    end
    value=(value-low_char(j))/pr(j);
end

disp('*********������*********');
char(out) 
