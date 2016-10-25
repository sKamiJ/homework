#include <Windows.h>   
#include <iostream> 
#include <string>

#define BUFFER_SIZE 512

using namespace std;  

int main()  
{  
	//�������
	HANDLE hFatherWriteOver = NULL;
	HANDLE hChildReadOver   = NULL;
	//�����ַ���
	string str;

	//�ӽ�������
	TCHAR* appName = TEXT("D:\\����ϵͳ\\ʵ���\\2\\OS_expe2_2_child\\Debug\\OS_expe2_2_child.exe");
	//������Ϣ�ṹ��
	STARTUPINFO startupInfo;
	//������Ϣ�ṹ��
	PROCESS_INFORMATION processInfo;
	//���ṹ���ڴ�������0����䣬���ڳ�ʼ��
	ZeroMemory(&startupInfo,sizeof(startupInfo));
	startupInfo.cb = sizeof(startupInfo);
	ZeroMemory(&processInfo,sizeof(processInfo));

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

	//�����¼�����ɽ��̼�ͬ��
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
		//�򿪼��а�
		if(!OpenClipboard(NULL)) 
		{
			cout<<"�򿪼��а�ʧ�ܣ�"<<endl;
			goto FATHER_PROCESS_END;
		}
		//��ռ��а�
		EmptyClipboard();
		//����һ��ȫ���ڴ�
		HGLOBAL hClipboardData = GlobalAlloc(GHND,str.length()+1);
		//ͨ����ȫ���ڴ���������ö�ȫ���ڴ�������
		char* pData = (char *)GlobalLock(hClipboardData);
		//����ʱ�ַ�������ַ�����ȫ���ڴ����
		strcpy(pData, temp);
		//����ȫ���ڴ��
		GlobalUnlock(hClipboardData);
		//�����ݼ����ʽ���������
		SetClipboardData(CF_TEXT, hClipboardData);
		//�ͷ�ȫ���ڴ�
		GlobalFree(hClipboardData);
		//�رռ��а�
		CloseClipboard();
		//���ø�����д����¼�
		if (!SetEvent(hFatherWriteOver)) 
			goto FATHER_PROCESS_END;  
	} while(str != "END");

FATHER_PROCESS_END:  
	//�ͷ��ڴ�ռ�
	if (NULL != hFatherWriteOver)   CloseHandle(hFatherWriteOver);
	if (NULL != hChildReadOver)     CloseHandle(hChildReadOver);
	return 0;
}  
