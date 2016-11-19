#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

class Process
{
private:
	string name;		//进程名称
	int arriveTime;		//到达时间
	int runTime;		//运行时间
	int restRunTime;	//剩余运行时间
	int priority;		//优先数
	int startTime;		//开始执行时间
	int endTime;		//结束执行时间
public:
	Process(string name, int arriveTime, int runTime, int priority){
		this->name = name;
		this->arriveTime = arriveTime;
		this->runTime = runTime;
		restRunTime = runTime;
		this->priority = priority;
	}
	//获取进程名称
	string getName(){
		return name;
	}
	//获取到达时间
	int getArriveTime(){
		return arriveTime;
	}
	//获取运行时间
	int getRunTime(){
		return runTime;
	}
	//获取优先数
	int getPriority(){
		return priority;
	}
	//执行一次该进程，返回执行后该进程是否完成
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
	//该进程是否已经被执行过
	bool isStarted(){
		return runTime!=restRunTime;
	}
	//设置开始执行时间
	void setStartTime(int startTime){
		this->startTime = startTime;
	}
	//设置结束执行时间
	void setEndTime(int endTime){
		this->endTime = endTime;
	}
	//获取响应时间
	int getResponseTime(){
		return startTime - arriveTime;
	}
	//获取周转时间
	int getTurnaroundTime(){
		return endTime - arriveTime;
	}
};

//从JOB1.txt中读取进程数据
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

//根据当前时间更新等待队列，若有进程到达时，将该进程加入等待队列
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

//输出各进程最后执行情况
void getResult(vector<Process> &doneQueue){
	//按照进程名排序
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
		cout<<doneQueue[i].getName()<<":\t响应时间:"<<doneQueue[i].getResponseTime()<<"\t周转时间:"<<doneQueue[i].getTurnaroundTime()<<";"<<endl;
	}
}

//短作业优先算法
void SJF(vector<Process> ps){
	//等待队列
	vector<Process> waitQueue;
	//完成队列
	vector<Process> doneQueue;
	//当前执行进程
	Process* currentP = NULL;
	//当前时间
	int currentTime = 0;
	cout<<"短作业优先算法："<<endl;
	//当未全部执行完时
	while(!(ps.empty() && waitQueue.empty() && !currentP)){
		//更新等待队列
		updateWaitQueue(ps,waitQueue,currentTime);
		//当前无执行进程时
		if(!currentP){
			//寻找等待队列中运行时间最短的进程，由于等待队列是按照时间先后顺序排列，所以无需额外判断先后进入顺序
			int index = 0;
			for(int i = 1; i < waitQueue.size(); i++){
				if(waitQueue[i].getRunTime() < waitQueue[index].getRunTime()){
					index = i;
				}
			}
			//取出该进程，并为其设置开始执行时间
			currentP = new Process(waitQueue[index]);
			waitQueue.erase(waitQueue.begin()+index);
			currentP->setStartTime(currentTime);
		}
		//输出当前执行的进程名
		cout<<currentP->getName();
		//执行一次进程
		if(currentP->execute()){
			//当进程执行完毕时，设置结束执行时间，并向完成队列中添加该进程
			currentP->setEndTime(currentTime+1);
			doneQueue.push_back(*currentP);
			currentP = NULL;
		}
		++currentTime;
	}
	//输出执行情况
	cout<<endl;
	getResult(doneQueue);
}

//时间片轮转算法
void RR(vector<Process> ps, int timeSlice){
	//等待队列
	vector<Process> waitQueue;
	//完成队列
	vector<Process> doneQueue;
	//当前执行进程
	Process* currentP = NULL;
	//当前时间
	int currentTime = 0;
	//时间片执行次数
	int timeSliceDoneTime = 0;
	//被抢占的进程
	Process* preemptedP = NULL;
	cout<<"时间片轮转算法，时间片为"<<timeSlice<<"："<<endl;
	//当未全部执行完时
	while(!(ps.empty() && waitQueue.empty() && !currentP)){
		//更新等待队列
		updateWaitQueue(ps,waitQueue,currentTime);
		//当有进程被抢占时，向等待队列中添加该进程
		if(preemptedP){
			waitQueue.push_back(*preemptedP);
			preemptedP = NULL;
		}
		//当前无执行进程时
		if(!currentP){
			//取出等待队列队首进程
			currentP = new Process(waitQueue[0]);
			waitQueue.erase(waitQueue.begin());
			//未开始执行时为其设置开始时间
			if(!currentP->isStarted()){
				currentP->setStartTime(currentTime);
			}
		}
		//输出当前执行的进程名
		cout<<currentP->getName();
		//执行一次进程
		bool done = currentP->execute();
		//增加时间片执行次数
		++timeSliceDoneTime;
		if(done){
			//当进程执行完毕时，设置结束执行时间，并向完成队列中添加该进程
			currentP->setEndTime(currentTime+1);
			doneQueue.push_back(*currentP);
			currentP = NULL;
			timeSliceDoneTime = 0;
		} else if(timeSliceDoneTime >= timeSlice) {
			//当时间片执行次数到达上限时，该进程被抢占
			preemptedP = currentP;
			currentP = NULL;
			timeSliceDoneTime = 0;
		}
		++currentTime;
	}
	//输出执行情况
	cout<<endl;
	getResult(doneQueue);
}

//优先数算法
void PS(vector<Process> ps){
	//等待队列
	vector<Process> waitQueue;
	//完成队列
	vector<Process> doneQueue;
	//当前执行进程
	Process* currentP = NULL;
	//当前时间
	int currentTime = 0;
	cout<<"优先数算法："<<endl;
	//当未全部执行完时
	while(!(ps.empty() && waitQueue.empty() && !currentP)){
		//更新等待队列
		updateWaitQueue(ps,waitQueue,currentTime);
		//当前无执行进程时
		if(!currentP){
			//寻找等待队列中优先级最高的进程，由于等待队列是按照时间先后顺序排列，所以无需额外判断先后进入顺序
			int index = 0;
			for(int i = 1; i < waitQueue.size(); i++){
				if(waitQueue[i].getPriority() < waitQueue[index].getPriority()){
					index = i;
				}
			}
			//取出该进程，并为其设置开始执行时间
			currentP = new Process(waitQueue[index]);
			waitQueue.erase(waitQueue.begin()+index);
			currentP->setStartTime(currentTime);
		}
		//输出当前执行的进程名
		cout<<currentP->getName();
		//执行一次进程
		if(currentP->execute()){
			//当进程执行完毕时，设置结束执行时间，并向完成队列中添加该进程
			currentP->setEndTime(currentTime+1);
			doneQueue.push_back(*currentP);
			currentP = NULL;
		}
		++currentTime;
	}
	//输出执行情况
	cout<<endl;
	getResult(doneQueue);
}

void main() {
	//声明进程向量
	vector<Process> ps;
	//获取进程数据
	getData(ps);
	//短作业优先算法
	SJF(ps);
	//时间片轮转算法，时间片为1
	RR(ps,1);
	//时间片轮转算法，时间片为2
	RR(ps,2);
	//时间片轮转算法，时间片为3
	RR(ps,3);
	//优先数算法
	PS(ps);
	for(;;);
}