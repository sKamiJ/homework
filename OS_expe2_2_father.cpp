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

	//子进程名称
	TCHAR* appName = TEXT("D:\\操作系统\\实验二\\2\\OS_expe2_2_child\\Debug\\OS_expe2_2_child.exe");
	//启动信息结构体
	STARTUPINFO startupInfo;
	//进程信息结构体
	PROCESS_INFORMATION processInfo;
	//将结构体内存区域用0来填充，用于初始化
	ZeroMemory(&startupInfo,sizeof(startupInfo));
	startupInfo.cb = sizeof(startupInfo);
	ZeroMemory(&processInfo,sizeof(processInfo));

	//创建子进程
	BOOL result = CreateProcess(appName,NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &startupInfo, &processInfo);
	if (result == FALSE)
	{
		cout<<"创建子进程失败！"<<endl;
		goto FATHER_PROCESS_END;
	}
	else
	{
		cout<<"创建子进程成功！"<<endl;
		//关闭子进程主线程句柄
		CloseHandle( processInfo.hThread );
		//关闭子进程句柄
		CloseHandle( processInfo.hProcess );
	}

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
		goto FATHER_PROCESS_END;  
	}

	cout<<"请输入字符串："<<endl;

	do
	{
		//临时字符数组
		char temp[BUFFER_SIZE];
		//等待子进程读完毕，最大等待事件5s
		if (WaitForSingleObject(hChildReadOver, 5*1000) != WAIT_OBJECT_0)   
			goto FATHER_PROCESS_END; 
		//重置子进程读完毕事件
		if (!ResetEvent(hChildReadOver)) 
			goto FATHER_PROCESS_END; 
		//获取输入
		gets(temp);
		//将输入字符串赋给str
		str.assign(temp);
		//打开剪切板
		if(!OpenClipboard(NULL)) 
		{
			cout<<"打开剪切板失败！"<<endl;
			goto FATHER_PROCESS_END;
		}
		//清空剪切板
		EmptyClipboard();
		//申请一块全局内存
		HGLOBAL hClipboardData = GlobalAlloc(GHND,str.length()+1);
		//通过给全局内存对象加锁获得对全局内存块的引用
		char* pData = (char *)GlobalLock(hClipboardData);
		//把临时字符数组的字符赋给全局内存块中
		strcpy(pData, temp);
		//解锁全局内存块
		GlobalUnlock(hClipboardData);
		//把数据及其格式加入剪帖板
		SetClipboardData(CF_TEXT, hClipboardData);
		//释放全局内存
		GlobalFree(hClipboardData);
		//关闭剪切板
		CloseClipboard();
		//设置父进程写完毕事件
		if (!SetEvent(hFatherWriteOver)) 
			goto FATHER_PROCESS_END;  
	} while(str != "END");

FATHER_PROCESS_END:  
	//释放内存空间
	if (NULL != hFatherWriteOver)   CloseHandle(hFatherWriteOver);
	if (NULL != hChildReadOver)     CloseHandle(hChildReadOver);
	return 0;
}  
