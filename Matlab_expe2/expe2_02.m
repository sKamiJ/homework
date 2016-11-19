clc,clear all;
symbol=['abc']          %已知会出现的字符。后面编程不再用到。
pr=[0.4 0.4 0.2]        %各字符出现的概率
disp('************************************');
format long;

in=['aabbc']
 
disp('*********开始编码*********');
%编程：要求能显示每一轮编码的上界和下界
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
    fprintf('下界=%.6f\t上界=%.6f\n',low,high);
end

disp('*********编码结果*********');
value=low   %为避免临界效应，可以取值(low+high)/2更安全
 
 
disp('*********开始解码*********');
%编程：要求能显示每一轮解码后的值
low_char=[0.0 0.4 0.8];
out=zeros(1,len);
for i=1:len
    fprintf('解码值=%.6f\n',value);
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

disp('*********解码结果*********');
char(out) 
