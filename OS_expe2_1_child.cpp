#include <Windows.h>   
#include <iostream> 
#include <string>

#define BUFFER_SIZE 512

using namespace std;  
  
int main()  
{  
	//声明句柄
	HANDLE hFileMapping     = NULL;
	LPVOID lpShareMemory    = NULL;
	HANDLE hFatherWriteOver = NULL;
	HANDLE hChildReadOver   = NULL;
	//声明字符串
	string str;
	
	//打开文件映射
	hFileMapping = OpenFileMapping(FILE_MAP_ALL_ACCESS,		//请求对文件映射的完全访问
		FALSE,				//子进程不继承句柄
		L"shareMemory");	//文件映射名称

	//打开文件映射失败
	if (NULL == hFileMapping)  
	{  
		cout << "打开文件映射失败：" << GetLastError() << endl;  
		goto CHILD_PROCESS_END;  
	}  
  
	//将文件数据映射到本进程的地址空间
	lpShareMemory = MapViewOfFile(hFileMapping,	//文件映射句柄
		FILE_MAP_ALL_ACCESS,					//可读写许可
		0,
		0,				//内存开始地址
		BUFFER_SIZE);	//所有内存空间

	//映射到本进程地址空间失败
	if (NULL == lpShareMemory)  
	{  
		cout << "文件数据映射到本进程的地址空间失败：" << GetLastError() << endl;  
		goto CHILD_PROCESS_END;  
	}  
  
	//创建事件以完成进程间同步，也可以使用互斥体，但我觉得用互斥体无法保证父子进程的执行顺序
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
		//将内存中的字符串拷贝至临时字符数组中
		memcpy(temp,lpShareMemory,BUFFER_SIZE);
		//将临时字符数组中值赋给字符串
		str.assign(temp);
		//输出字符串
		cout<<str<<endl;  
	} while (str != "END");

CHILD_PROCESS_END:  
	//释放内存空间 
	if (NULL != hFatherWriteOver)   CloseHandle(hFatherWriteOver);
	if (NULL != hChildReadOver)     CloseHandle(hChildReadOver);
	if (NULL != lpShareMemory)      UnmapViewOfFile(lpShareMemory);		//解除文件映射
	if (NULL != hFileMapping)       CloseHandle(hFileMapping);
	return 0;  
}  
