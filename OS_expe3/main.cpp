#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

class Process
{
private:
	string name;		//��������
	int arriveTime;		//����ʱ��
	int runTime;		//����ʱ��
	int restRunTime;	//ʣ������ʱ��
	int priority;		//������
	int startTime;		//��ʼִ��ʱ��
	int endTime;		//����ִ��ʱ��
public:
	Process(string name, int arriveTime, int runTime, int priority){
		this->name = name;
		this->arriveTime = arriveTime;
		this->runTime = runTime;
		restRunTime = runTime;
		this->priority = priority;
	}
	//��ȡ��������
	string getName(){
		return name;
	}
	//��ȡ����ʱ��
	int getArriveTime(){
		return arriveTime;
	}
	//��ȡ����ʱ��
	int getRunTime(){
		return runTime;
	}
	//��ȡ������
	int getPriority(){
		return priority;
	}
	//ִ��һ�θý��̣�����ִ�к�ý����Ƿ����
	bool execute(){
		if(restRunTime > 0){
			if(--restRunTime <= 0){
				return true;
			} else {
				return false;
			}
		}
		return true;
	}
	//�ý����Ƿ��Ѿ���ִ�й�
	bool isStarted(){
		return runTime!=restRunTime;
	}
	//���ÿ�ʼִ��ʱ��
	void setStartTime(int startTime){
		this->startTime = startTime;
	}
	//���ý���ִ��ʱ��
	void setEndTime(int endTime){
		this->endTime = endTime;
	}
	//��ȡ��Ӧʱ��
	int getResponseTime(){
		return startTime - arriveTime;
	}
	//��ȡ��תʱ��
	int getTurnaroundTime(){
		return endTime - arriveTime;
	}
};

//��JOB1.txt�ж�ȡ��������
void getData(vector<Process> &ps){
	ifstream is("JOB1.txt");
	string tmp;
	while (getline(is,tmp))
	{
		istringstream iss(tmp);
		string name;
		int arriveTime;
		int runTime;
		int priority;
		iss >> name;
		iss >> arriveTime;
		iss >> runTime;
		iss >> priority;
		Process p(name,arriveTime,runTime,priority);
		ps.push_back(p);
	}
	is.close();
}

//���ݵ�ǰʱ����µȴ����У����н��̵���ʱ�����ý��̼���ȴ�����
void updateWaitQueue(vector<Process> &ps, vector<Process> &waitQueue, int currentTime){
	for(int i = 0; i < ps.size(); ){
		if(ps[i].getArriveTime() == currentTime){
			waitQueue.push_back(ps[i]);
			ps.erase(ps.begin()+i);
		} else {
			++i;
		}
	}
}

//������������ִ�����
void getResult(vector<Process> &doneQueue){
	//���ս���������
	for(int i=0;i<doneQueue.size()-1;i++){
		for(int j=i+1;j<doneQueue.size();j++){
			if(doneQueue[i].getName()>doneQueue[j].getName()){
				Process tmp = doneQueue[i];
				doneQueue[i] = doneQueue[j];
				doneQueue[j] = tmp;
			}
		}
	}
	for(int i = 0; i < doneQueue.size(); i++){
		cout<<doneQueue[i].getName()<<":\t��Ӧʱ��:"<<doneQueue[i].getResponseTime()<<"\t��תʱ��:"<<doneQueue[i].getTurnaroundTime()<<";"<<endl;
	}
}

//����ҵ�����㷨
void SJF(vector<Process> ps){
	//�ȴ�����
	vector<Process> waitQueue;
	//��ɶ���
	vector<Process> doneQueue;
	//��ǰִ�н���
	Process* currentP = NULL;
	//��ǰʱ��
	int currentTime = 0;
	cout<<"����ҵ�����㷨��"<<endl;
	//��δȫ��ִ����ʱ
	while(!(ps.empty() && waitQueue.empty() && !currentP)){
		//���µȴ�����
		updateWaitQueue(ps,waitQueue,currentTime);
		//��ǰ��ִ�н���ʱ
		if(!currentP){
			//Ѱ�ҵȴ�����������ʱ����̵Ľ��̣����ڵȴ������ǰ���ʱ���Ⱥ�˳�����У�������������ж��Ⱥ����˳��
			int index = 0;
			for(int i = 1; i < waitQueue.size(); i++){
				if(waitQueue[i].getRunTime() < waitQueue[index].getRunTime()){
					index = i;
				}
			}
			//ȡ���ý��̣���Ϊ�����ÿ�ʼִ��ʱ��
			currentP = new Process(waitQueue[index]);
			waitQueue.erase(waitQueue.begin()+index);
			currentP->setStartTime(currentTime);
		}
		//�����ǰִ�еĽ�����
		cout<<currentP->getName();
		//ִ��һ�ν���
		if(currentP->execute()){
			//������ִ�����ʱ�����ý���ִ��ʱ�䣬������ɶ�������Ӹý���
			currentP->setEndTime(currentTime+1);
			doneQueue.push_back(*currentP);
			currentP = NULL;
		}
		++currentTime;
	}
	//���ִ�����
	cout<<endl;
	getResult(doneQueue);
}

//ʱ��Ƭ��ת�㷨
void RR(vector<Process> ps, int timeSlice){
	//�ȴ�����
	vector<Process> waitQueue;
	//��ɶ���
	vector<Process> doneQueue;
	//��ǰִ�н���
	Process* currentP = NULL;
	//��ǰʱ��
	int currentTime = 0;
	//ʱ��Ƭִ�д���
	int timeSliceDoneTime = 0;
	//����ռ�Ľ���
	Process* preemptedP = NULL;
	cout<<"ʱ��Ƭ��ת�㷨��ʱ��ƬΪ"<<timeSlice<<"��"<<endl;
	//��δȫ��ִ����ʱ
	while(!(ps.empty() && waitQueue.empty() && !currentP)){
		//���µȴ�����
		updateWaitQueue(ps,waitQueue,currentTime);
		//���н��̱���ռʱ����ȴ���������Ӹý���
		if(preemptedP){
			waitQueue.push_back(*preemptedP);
			preemptedP = NULL;
		}
		//��ǰ��ִ�н���ʱ
		if(!currentP){
			//ȡ���ȴ����ж��׽���
			currentP = new Process(waitQueue[0]);
			waitQueue.erase(waitQueue.begin());
			//δ��ʼִ��ʱΪ�����ÿ�ʼʱ��
			if(!currentP->isStarted()){
				currentP->setStartTime(currentTime);
			}
		}
		//�����ǰִ�еĽ�����
		cout<<currentP->getName();
		//ִ��һ�ν���
		bool done = currentP->execute();
		//����ʱ��Ƭִ�д���
		++timeSliceDoneTime;
		if(done){
			//������ִ�����ʱ�����ý���ִ��ʱ�䣬������ɶ�������Ӹý���
			currentP->setEndTime(currentTime+1);
			doneQueue.push_back(*currentP);
			currentP = NULL;
			timeSliceDoneTime = 0;
		} else if(timeSliceDoneTime >= timeSlice) {
			//��ʱ��Ƭִ�д�����������ʱ���ý��̱���ռ
			preemptedP = currentP;
			currentP = NULL;
			timeSliceDoneTime = 0;
		}
		++currentTime;
	}
	//���ִ�����
	cout<<endl;
	getResult(doneQueue);
}

//�������㷨
void PS(vector<Process> ps){
	//�ȴ�����
	vector<Process> waitQueue;
	//��ɶ���
	vector<Process> doneQueue;
	//��ǰִ�н���
	Process* currentP = NULL;
	//��ǰʱ��
	int currentTime = 0;
	cout<<"�������㷨��"<<endl;
	//��δȫ��ִ����ʱ
	while(!(ps.empty() && waitQueue.empty() && !currentP)){
		//���µȴ�����
		updateWaitQueue(ps,waitQueue,currentTime);
		//��ǰ��ִ�н���ʱ
		if(!currentP){
			//Ѱ�ҵȴ����������ȼ���ߵĽ��̣����ڵȴ������ǰ���ʱ���Ⱥ�˳�����У�������������ж��Ⱥ����˳��
			int index = 0;
			for(int i = 1; i < waitQueue.size(); i++){
				if(waitQueue[i].getPriority() < waitQueue[index].getPriority()){
					index = i;
				}
			}
			//ȡ���ý��̣���Ϊ�����ÿ�ʼִ��ʱ��
			currentP = new Process(waitQueue[index]);
			waitQueue.erase(waitQueue.begin()+index);
			currentP->setStartTime(currentTime);
		}
		//�����ǰִ�еĽ�����
		cout<<currentP->getName();
		//ִ��һ�ν���
		if(currentP->execute()){
			//������ִ�����ʱ�����ý���ִ��ʱ�䣬������ɶ�������Ӹý���
			currentP->setEndTime(currentTime+1);
			doneQueue.push_back(*currentP);
			currentP = NULL;
		}
		++currentTime;
	}
	//���ִ�����
	cout<<endl;
	getResult(doneQueue);
}

void main() {
	//������������
	vector<Process> ps;
	//��ȡ��������
	getData(ps);
	//����ҵ�����㷨
	SJF(ps);
	//ʱ��Ƭ��ת�㷨��ʱ��ƬΪ1
	RR(ps,1);
	//ʱ��Ƭ��ת�㷨��ʱ��ƬΪ2
	RR(ps,2);
	//ʱ��Ƭ��ת�㷨��ʱ��ƬΪ3
	RR(ps,3);
	//�������㷨
	PS(ps);
	for(;;);
}