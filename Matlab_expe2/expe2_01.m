%哈夫曼编码的MATLAB实现（基于0、1编码）：
clc,clear;
A=[0.4 0.3 0.1 0.1 0.06 0.04];      %信源消息的概率序列
A=fliplr(sort(A));                  %按降序排列
T=A;								
n=length(A);                        %得到A的元素个数
B=zeros(n,n-1);                     %空的编码表（矩阵）
B(:,1)=T';                          %把T转置放入B的第一列
 
t=n;    
for j=2:n-1							%4列
    T(t-1)=T(t)+T(t-1);             %把当前T的后两位有效值相加
T(t)=0;							
T(n)=0;   					        %初始强制最后一个为0
    if (T(t-1)-T(t-2)>0.000000001)  %直接比较可能有问题
        T=fliplr(sort(T));          %降序排序
        T(n)=-1;                    %-1代表在排序过程中有数据位置交换
    end  
    B(:,j)=T';    
    t=t-1;    
end
B   
 
s=sym('[]');                     %生成符号矩阵 
for i=1:n-1  
    b=s(i);						    %存储未改变的s(i)值
    if B(n,n-i)==-1                 %之前排序发生过位置交换，编码也应反转
        s(i)=[char(b),'1'];
        s(i+1)=[char(b),'0'];
    else
        s(i)=[char(b),'0'];
        s(i+1)=[char(b),'1'];
    end         
end
A
s
 
 
for i=1:n    
    L(i)=length(char(s(i)));
end
L
avlen=sum(L.*A)                     %平均码长  
H1=log2(A);
H=-A*(H1')                          %熵, 也可以写成H=sum(-A.*H1)
