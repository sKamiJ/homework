#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//定义每行最大长度
#define MAX_LINE_LENGTH 1025

//栈节点
typedef struct stack_node{
	//节点信息，这里是文本行
	char line[MAX_LINE_LENGTH];
	//指向下一结点指针
	struct stack_node* next;
} stack_node;

//栈
typedef struct stack{
	//栈顶
	stack_node* top;
} stack;

//将该文本行压栈
void push(char* line, stack_node** top){
	//新建栈节点
	stack_node* n = (stack_node*)malloc(sizeof(stack_node));
	//无法申请内存
	if(!n)
		exit(0);
	//复制文本行
	strcpy(n->line,line);
	//栈顶为空，新节点指向NULL
	if(!*top)
		n->next = NULL;
	//栈顶不为空，新节点指向栈顶
	else 
		n->next = *top;
	//栈顶指向新节点
	*top = n;
	return;
}

//出栈，数组保存在dst中，成功返回1，失败返回0
int pop(char* dst, stack_node** top){
	//临时指针记录栈顶指针
	stack_node* tmp = *top;
	//栈顶为空，返回0
	if(!tmp)
		return 0;
	//复制栈顶文本行至目标数组
	strcpy(dst, tmp->line);
	//更改栈顶指针
	*top = tmp->next;
	//释放原栈顶内存
	free(tmp);
	return 1;
}

void main(){
	//初始化空栈
	stack stack = {NULL};
	//文件名数组
	char file_name[50];
	//文件指针
	FILE* fp;
	//临时存放从文件读取的字符
	char ch;
	//文本行信息数组
	char line[MAX_LINE_LENGTH];
	//记录文本行信息数组当前位置的游标
	int i = 0;

	//获取文件名
	printf("please input the file name:\r\n");
	gets(file_name);
	//打开文件
	fp = fopen(file_name,"rb");
	//打开文件失败
	if(!fp){
		printf("can't open the file;\r\n");
		exit(0);
	}
	//遍历文件
	while ((ch = fgetc(fp)) != EOF){
		//发现换行符
		if(ch == '\n'){
			//去除换行符，这样打印时不会多打印出一行，Windows为\r\n
			if(i > 0 && line[i - 1] == '\r')
				line[i - 1] = '\0';
			//Linux为\n
			else
				line[i] = '\0';
			//将文本行压栈
			push(line, &stack.top);
			//重置游标
			i = 0;
		} else {
			//非换行符，添加字符进文本行
			line[i++] = ch;
		}
	}
	//将最后一行压栈，Linux下不需要特殊处理最后一行，因为会自动添加一个\n
	//line[i] = '\0';
	//push(line, &stack.top);
	//循环弹出文本行
	while(pop(line,&stack.top))
		//打印文本行
		puts(line);
	//关闭文件
	fclose(fp);
	return;
}

