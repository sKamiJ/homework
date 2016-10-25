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

	//子进程名称
	TCHAR* appName = TEXT("D:\\操作系统\\实验二\\1\\OS_expe2_1_child\\Debug\\OS_expe2_1_child.exe");
	//启动信息结构体
	STARTUPINFO startupInfo;
	//进程信息结构体
	PROCESS_INFORMATION processInfo;
	//将结构体内存区域用0来填充，用于初始化
	ZeroMemory(&startupInfo,sizeof(startupInfo));
	startupInfo.cb = sizeof(startupInfo);
	ZeroMemory(&processInfo,sizeof(processInfo));

	//先创建文件映射，再创建子进程，以防止子进程创建完成，想要打开文件映射时，父进程文件映射尚未创建而造成子进程出错
	//创建文件映射
	hFileMapping = CreateFileMapping(INVALID_HANDLE_VALUE,  //物理文件无关的内存映射
		NULL,					//安全设置
		PAGE_READWRITE,			//保护设置
		0,						//高位文件大小
		1024*1024,				//低位文件大小
		L"shareMemory");		//文件映射名称

	//创建文件映射失败
	if (NULL == hFileMapping)  
	{  
		cout << "创建文件映射失败：" << GetLastError() << endl;  
		goto FATHER_PROCESS_END;  
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
		goto FATHER_PROCESS_END;
	}  

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
		//将获取的字符串拷贝至内存中
		memcpy(lpShareMemory,temp,BUFFER_SIZE);
		//设置父进程写完毕事件
		if (!SetEvent(hFatherWriteOver)) 
			goto FATHER_PROCESS_END;  
	} while(str != "END");

FATHER_PROCESS_END:  
	//释放内存空间
	if (NULL != hFatherWriteOver)   CloseHandle(hFatherWriteOver);
	if (NULL != hChildReadOver)     CloseHandle(hChildReadOver);
	if (NULL != lpShareMemory)      UnmapViewOfFile(lpShareMemory);		//解除文件映射
	if (NULL != hFileMapping)       CloseHandle(hFileMapping);
	return 0;
}  
