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
	
	//���ļ�ӳ��
	hFileMapping = OpenFileMapping(FILE_MAP_ALL_ACCESS,		//������ļ�ӳ�����ȫ����
		FALSE,				//�ӽ��̲��̳о��
		L"shareMemory");	//�ļ�ӳ������

	//���ļ�ӳ��ʧ��
	if (NULL == hFileMapping)  
	{  
		cout << "���ļ�ӳ��ʧ�ܣ�" << GetLastError() << endl;  
		goto CHILD_PROCESS_END;  
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
		goto CHILD_PROCESS_END;  
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
		//���ڴ��е��ַ�����������ʱ�ַ�������
		memcpy(temp,lpShareMemory,BUFFER_SIZE);
		//����ʱ�ַ�������ֵ�����ַ���
		str.assign(temp);
		//����ַ���
		cout<<str<<endl;  
	} while (str != "END");

CHILD_PROCESS_END:  
	//�ͷ��ڴ�ռ� 
	if (NULL != hFatherWriteOver)   CloseHandle(hFatherWriteOver);
	if (NULL != hChildReadOver)     CloseHandle(hChildReadOver);
	if (NULL != lpShareMemory)      UnmapViewOfFile(lpShareMemory);		//����ļ�ӳ��
	if (NULL != hFileMapping)       CloseHandle(hFileMapping);
	return 0;  
}  
