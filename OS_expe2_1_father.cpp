#include <Windows.h>   
#include <iostream> 
#include <string>

#define BUFFER_SIZE 512

using namespace std;  

int main()  
{  
	//�������
	HANDLE hFileMapping     = NULL;
	LPVOID lpShareMemory    = NULL;
	HANDLE hFatherWriteOver = NULL;
	HANDLE hChildReadOver   = NULL;
	//�����ַ���
	string str;

	//�ӽ�������
	TCHAR* appName = TEXT("D:\\����ϵͳ\\ʵ���\\1\\OS_expe2_1_child\\Debug\\OS_expe2_1_child.exe");
	//������Ϣ�ṹ��
	STARTUPINFO startupInfo;
	//������Ϣ�ṹ��
	PROCESS_INFORMATION processInfo;
	//���ṹ���ڴ�������0����䣬���ڳ�ʼ��
	ZeroMemory(&startupInfo,sizeof(startupInfo));
	startupInfo.cb = sizeof(startupInfo);
	ZeroMemory(&processInfo,sizeof(processInfo));

	//�ȴ����ļ�ӳ�䣬�ٴ����ӽ��̣��Է�ֹ�ӽ��̴�����ɣ���Ҫ���ļ�ӳ��ʱ���������ļ�ӳ����δ����������ӽ��̳���
	//�����ļ�ӳ��
	hFileMapping = CreateFileMapping(INVALID_HANDLE_VALUE,  //�����ļ��޹ص��ڴ�ӳ��
		NULL,					//��ȫ����
		PAGE_READWRITE,			//��������
		0,						//��λ�ļ���С
		1024*1024,				//��λ�ļ���С
		L"shareMemory");		//�ļ�ӳ������

	//�����ļ�ӳ��ʧ��
	if (NULL == hFileMapping)  
	{  
		cout << "�����ļ�ӳ��ʧ�ܣ�" << GetLastError() << endl;  
		goto FATHER_PROCESS_END;  
	}  

	//���ļ�����ӳ�䵽�����̵ĵ�ַ�ռ�
	lpShareMemory = MapViewOfFile(hFileMapping,	//�ļ�ӳ����
		FILE_MAP_ALL_ACCESS,					//�ɶ�д���
		0,
		0,				//�ڴ濪ʼ��ַ
		BUFFER_SIZE);	//�����ڴ�ռ�

	//ӳ�䵽�����̵�ַ�ռ�ʧ��
	if (NULL == lpShareMemory)  
	{  
		cout << "�ļ�����ӳ�䵽�����̵ĵ�ַ�ռ�ʧ�ܣ�" << GetLastError() << endl;  
		goto FATHER_PROCESS_END;
	}  

	//�����ӽ���
	BOOL result = CreateProcess(appName,NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &startupInfo, &processInfo);
	if (result == FALSE)
	{
		cout<<"�����ӽ���ʧ�ܣ�"<<endl;
		goto FATHER_PROCESS_END;
	}
	else
	{
		cout<<"�����ӽ��̳ɹ���"<<endl;
		//�ر��ӽ������߳̾��
		CloseHandle( processInfo.hThread );
		//�ر��ӽ��̾��
		CloseHandle( processInfo.hProcess );
	}

	//�����¼�����ɽ��̼�ͬ����Ҳ����ʹ�û����壬���Ҿ����û������޷���֤���ӽ��̵�ִ��˳��
	//����������д����¼�
	hFatherWriteOver = CreateEvent(NULL,	//��ȫ���ԣ��˾�����ܱ��̳У�Ĭ�ϻ��һ����ȫ��
		TRUE,		//��λ��ʽΪ�ֹ���λ
		FALSE,		//��ʼΪ���ź�״̬
		L"fatherWriteOver");	//�¼�����
	//�����ӽ��̶�����¼�
	hChildReadOver = CreateEvent(NULL,		//��ȫ���ԣ��˾�����ܱ��̳У�Ĭ�ϻ��һ����ȫ��
		TRUE,		//��λ��ʽΪ�ֹ���λ
		FALSE,		//��ʼΪ���ź�״̬
		L"childReadOver");		//�¼�����

	//�����¼�ʧ��
	if (NULL == hFatherWriteOver ||  
		NULL == hChildReadOver)  
	{  
		cout << "�����¼�ʧ�ܣ�" << GetLastError() << endl;  
		goto FATHER_PROCESS_END;  
	}

	cout<<"�������ַ�����"<<endl;

	do
	{
		//��ʱ�ַ�����
		char temp[BUFFER_SIZE];
		//�ȴ��ӽ��̶���ϣ����ȴ��¼�5s
		if (WaitForSingleObject(hChildReadOver, 5*1000) != WAIT_OBJECT_0)   
			goto FATHER_PROCESS_END; 
		//�����ӽ��̶�����¼�
		if (!ResetEvent(hChildReadOver)) 
			goto FATHER_PROCESS_END; 
		//��ȡ����
		gets(temp);
		//�������ַ�������str
		str.assign(temp);
		//����ȡ���ַ����������ڴ���
		memcpy(lpShareMemory,temp,BUFFER_SIZE);
		//���ø�����д����¼�
		if (!SetEvent(hFatherWriteOver)) 
			goto FATHER_PROCESS_END;  
	} while(str != "END");

FATHER_PROCESS_END:  
	//�ͷ��ڴ�ռ�
	if (NULL != hFatherWriteOver)   CloseHandle(hFatherWriteOver);
	if (NULL != hChildReadOver)     CloseHandle(hChildReadOver);
	if (NULL != lpShareMemory)      UnmapViewOfFile(lpShareMemory);		//����ļ�ӳ��
	if (NULL != hFileMapping)       CloseHandle(hFileMapping);
	return 0;
}  
