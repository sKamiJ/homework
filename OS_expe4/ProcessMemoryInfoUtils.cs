using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace OS_expe4
{
    //进程内存信息结构体
    public struct ProcessMemoryInfo
    {
        public uint cb;
        public uint PageFaultCount;             //缺页中断次数
        public uint PeakWorkingSetSize;         //使用内存高峰
        public uint WorkingSetSize;             //当前使用的内存
        public uint QuotaPeakPagedPoolUsage;    //使用页面缓存池高峰
        public uint QuotaPagedPoolUsage;        //使用页面缓存池
        public uint QuotaPeakNonPagedPoolUsage; //使用非分页缓存池高峰
        public uint QuotaNonPagedPoolUsage;     //使用非分页缓存池
        public uint PagefileUsage;              //使用分页文件
        public uint PeakPagefileUsage;          //使用分页文件高峰
    }

    //进程内存信息工具类
    public class ProcessMemoryInfoUtils
    {
        //引用dll库，并声明GetProcessMemoryInfo函数
        [DllImport("psapi.dll", SetLastError = true)]
        static extern bool GetProcessMemoryInfo(IntPtr hprocess, out ProcessMemoryInfo pmi, int size);

        //获取进程与进程内存信息键值对
        public static Dictionary<Process, ProcessMemoryInfo> getProcessMemoryInfos()
        {
            //新建键值对
            Dictionary<Process, ProcessMemoryInfo> dic = new Dictionary<Process, ProcessMemoryInfo>();
            //获取所有进程
            Process[] pros = Process.GetProcesses();
            for (int i = 0; i < pros.Length; i++)
            {
                ProcessMemoryInfo pmi = new ProcessMemoryInfo();
                try
                {
                    //获取进程内存信息
                    if (GetProcessMemoryInfo(pros[i].Handle, out pmi, Marshal.SizeOf(pmi)))
                    {
                        //添加键值对
                        dic.Add(pros[i], pmi);
                    }
                }
                catch (Exception e)
                {

                }
            }
            return dic;
        }
    }
}
