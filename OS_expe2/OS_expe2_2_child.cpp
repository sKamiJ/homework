#include <Windows.h>   
#include <iostream> 
#include <string>

#define BUFFER_SIZE 512

using namespace std;  

int main()  
{  
	//声明句柄
	HANDLE hFatherWriteOver = NULL;
	HANDLE hChildReadOver   = NULL;
	//声明字符串
	string str;

	//创建事件以完成进程间同步
	//创建父进程写完成事件
	hFatherWriteOver = CreateEvent(NULL,	//安全属性，此句柄不能被继承，默认获得一个安全符
		TRUE,		//复位方式为手工复位
		FALSE,		//初始为无信号状态
		L"fatherWriteOver");	//事件名称
	//创建子进程读完成事件
	hChildReadOver = CreateEvent(NULL,		//安全属性，此句柄不能被继承，默认获得一个安全符
		TRUE,		//复位方式为手工复位
		FALSE,		//初始为无信号状态
		L"childReadOver");		//事件名称

	//创建事件失败
	if (NULL == hFatherWriteOver ||  
		NULL == hChildReadOver)  
	{  
		cout << "创建事件失败：" << GetLastError() << endl;  
		goto CHILD_PROCESS_END;  
	}

	do 
	{
		//临时字符数组
		char temp[BUFFER_SIZE];
		//设置子进程读完毕事件
		if (!SetEvent(hChildReadOver))   
			goto CHILD_PROCESS_END;
		//等待父进程写完毕
		if (WaitForSingleObject(hFatherWriteOver, INFINITE) != WAIT_OBJECT_0)   
			goto CHILD_PROCESS_END; 
		//重置父进程写完毕事件
		if (!ResetEvent(hFatherWriteOver))   
			goto CHILD_PROCESS_END;  
		//打开剪切板
		if(!OpenClipboard(NULL)) 
		{
			cout<<"打开剪切板失败！"<<endl;
			goto CHILD_PROCESS_END;
		}
		//指定格式数据在剪切板上是否存在
		if(IsClipboardFormatAvailable(CF_TEXT) || IsClipboardFormatAvailable(CF_OEMTEXT)) 
		{
			//从剪切板读取数据
			HANDLE hClipboardData = GetClipboardData(CF_TEXT);
			//通过加锁获得引用
			char* pData = (char *)GlobalLock(hClipboardData);
			//将数据拷贝到临时字符数组中
			strcpy(temp,pData);
			//将临时字符数组中值赋给字符串
			str.assign(temp);
			//输出字符串
			cout<<str<<endl; 
			//解锁
			GlobalUnlock(hClipboardData);
		}
		//关闭剪切板
		CloseClipboard();
	} while (str != "END");

CHILD_PROCESS_END:  
	//释放内存空间 
	if (NULL != hFatherWriteOver)   CloseHandle(hFatherWriteOver);
	if (NULL != hChildReadOver)     CloseHandle(hChildReadOver);
	return 0;  
}  
