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
		goto CHILD_PROCESS_END;  
	}

	do 
	{
		//��ʱ�ַ�����
		char temp[BUFFER_SIZE];
		//�����ӽ��̶�����¼�
		if (!SetEvent(hChildReadOver))   
			goto CHILD_PROCESS_END;
		//�ȴ�������д���
		if (WaitForSingleObject(hFatherWriteOver, INFINITE) != WAIT_OBJECT_0)   
			goto CHILD_PROCESS_END; 
		//���ø�����д����¼�
		if (!ResetEvent(hFatherWriteOver))   
			goto CHILD_PROCESS_END;  
		//�򿪼��а�
		if(!OpenClipboard(NULL)) 
		{
			cout<<"�򿪼��а�ʧ�ܣ�"<<endl;
			goto CHILD_PROCESS_END;
		}
		//ָ����ʽ�����ڼ��а����Ƿ����
		if(IsClipboardFormatAvailable(CF_TEXT) || IsClipboardFormatAvailable(CF_OEMTEXT)) 
		{
			//�Ӽ��а��ȡ����
			HANDLE hClipboardData = GetClipboardData(CF_TEXT);
			//ͨ�������������
			char* pData = (char *)GlobalLock(hClipboardData);
			//�����ݿ�������ʱ�ַ�������
			strcpy(temp,pData);
			//����ʱ�ַ�������ֵ�����ַ���
			str.assign(temp);
			//����ַ���
			cout<<str<<endl; 
			//����
			GlobalUnlock(hClipboardData);
		}
		//�رռ��а�
		CloseClipboard();
	} while (str != "END");

CHILD_PROCESS_END:  
	//�ͷ��ڴ�ռ� 
	if (NULL != hFatherWriteOver)   CloseHandle(hFatherWriteOver);
	if (NULL != hChildReadOver)     CloseHandle(hChildReadOver);
	return 0;  
}  
