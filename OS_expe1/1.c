#include<stdio.h>
#include<string.h>
#include<stdlib.h>

//定义单词最大长度
#define MAX_WORD_LENGTH 50

//树的叶子节点
typedef struct tree_node{
	//该节点存放的单词
	char word[MAX_WORD_LENGTH];
	//该单词出现次数
	unsigned int num;
	//左孩子，字典序比该单词小
	struct tree_node* l_child;
	//右孩子，字典序比该单词大
	struct tree_node* r_child;
} tree_node;

//树
typedef struct tree{
	//根节点
	tree_node* root;
} tree;

//递归添加单词
void add_word(const char* word, tree_node** p) {
	//节点为空，说明该单词未出现过
	if(!*p) {
		//申请内存
		*p = (tree_node*)malloc(sizeof(tree_node));
		//无法申请内存
		if(!*p)
			exit(0);
		//复制单词
		strcpy((*p)->word,word);
		//该单词出现次数为1
		(*p)->num = 1;
		//设置左右孩子为NULL
		(*p)->l_child = (*p)->r_child = NULL;
	} else {
		//节点不为空，比较两节点单词字典序
		int res = strcmp(word, (*p)->word);
		//新单词字典序小时，在左孩子添加
		if(res < 0)
			add_word(word, &(*p)->l_child);
		//新单词字典序大时，在右孩子添加
		else if(res > 0)
			add_word(word, &(*p)->r_child);
		//相同单词，出现次数加1
		else
			(*p)->num++;
	}
	return;
}

//中序遍历树，并打印出单词出现频数
void get_result(const tree_node* p){
	//空节点，返回
	if(!p)
		return;
	//打印左子树单词
	get_result(p->l_child);
	//打印该节点单词
	printf("\"%s\" : %d;\r\n", p->word, p->num);
	//打印右子树单词
	get_result(p->r_child);
	return;
}

//判断该字符是否属于单词一部分
int is_letter(const char ch){
	//大小写字母、数字以及'和-合法
	if((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9') || ch == '\'' || ch == '-')
		return 1;
	else
		return 0;
}

void main(){
	//初始化空树
	tree t = {NULL};
	//文件名数组
	char file_name[50];
	//文件指针
	FILE* fp;
	//临时存放从文件读取的字符
	char ch;
	//存放单词的数组
	char word[MAX_WORD_LENGTH];
	//记录单词数组当前位置的游标
	int i = 0;
	//是否开始记录单词
	int is_start = 0;
	
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
	while(!feof(fp)){
		//获取字符，文件结束时会多读取一个结束符，正好可以用来判断最后一个单词是否结束
		ch = fgetc(fp);
		//判断是否是单词的一部分
		if(is_letter(ch)){
			//添加至单词数组
			word[i++] = ch;
			//开始记录单词
			is_start = 1;
		} else {
			//不是单词
			if(is_start){
				//若已经开始记录单词，则结束记录并提交
				//添加结束符
				word[i] = '\0';
				//在树中添加单词
				add_word(word, &t.root);
				//重置游标
				i = 0;
				//结束记录单词
				is_start = 0;
			}
		}
	}
	//获取结果
	get_result(t.root);
	//关闭文件
	fclose(fp);
	return;
}

