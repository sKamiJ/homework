using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace OS_expe4
{
    public partial class processMemoryInfoForm : Form
    {
        public processMemoryInfoForm()
        {
            //初始化构件
            InitializeComponent();
            //更新processMemoryInfoListView
            updateProcessMemoryInfoListView();
        }

        //更新processMemoryInfoListView
        private void updateProcessMemoryInfoListView()
        {
            //开始更新
            processMemoryInfoListView.BeginUpdate();
            //清除所有item
            processMemoryInfoListView.Items.Clear();
            //获取进程与进程内存信息键值对
            Dictionary<Process, ProcessMemoryInfo> dic = ProcessMemoryInfoUtils.getProcessMemoryInfos();
            //遍历键值对
            foreach (KeyValuePair<Process, ProcessMemoryInfo> kv in dic)
            {
                //新建item并赋值
                ListViewItem lvi = new ListViewItem();
                Process pro = kv.Key;
                ProcessMemoryInfo pmi = kv.Value;
                lvi.Text = pro.ProcessName;
                lvi.SubItems.Add(pro.Id.ToString());
                lvi.SubItems.Add(Convert.ToString(pmi.PageFaultCount / 1024) + "K");
                lvi.SubItems.Add(Convert.ToString(pmi.PeakWorkingSetSize / 1024) + "K");
                lvi.SubItems.Add(Convert.ToString(pmi.WorkingSetSize / 1024) + "K");
                lvi.SubItems.Add(Convert.ToString(pmi.QuotaPeakPagedPoolUsage / 1024) + "K");
                lvi.SubItems.Add(Convert.ToString(pmi.QuotaPagedPoolUsage / 1024) + "K");
                lvi.SubItems.Add(Convert.ToString(pmi.QuotaPeakNonPagedPoolUsage / 1024) + "K");
                lvi.SubItems.Add(Convert.ToString(pmi.QuotaNonPagedPoolUsage / 1024) + "K");
                lvi.SubItems.Add(Convert.ToString(pmi.PagefileUsage / 1024) + "K");
                lvi.SubItems.Add(Convert.ToString(pmi.PeakPagefileUsage / 1024) + "K");
                //添加item
                processMemoryInfoListView.Items.Add(lvi);
            }
            //结束更新
            processMemoryInfoListView.EndUpdate();
            //更新进程数
            processNumLabel.Text = "进程数：" + dic.Count;
        }

        private void updateProcessMemoryInfoListViewButton_Click(object sender, EventArgs e)
        {
            //更新processMemoryInfoListView
            updateProcessMemoryInfoListView();
        }

        private void killProcessButton_Click(object sender, EventArgs e)
        {
            //未选择进程
            if (processMemoryInfoListView.SelectedItems.Count == 0)
            {
                MessageBox.Show(this, "尚未选择所想要结束的进程！");
            }
            else
            {
                //对话框警告
                DialogResult res = MessageBox.Show(this, "您确定要结束 " + processMemoryInfoListView.SelectedItems[0].Text + " 吗？", "结束进程", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning);
                //未取消
                if (res != DialogResult.Cancel)
                {
                    try
                    {
                        //获取要关闭的进程
                        int pid = Int32.Parse(processMemoryInfoListView.SelectedItems[0].SubItems[1].Text);
                        Process pro = Process.GetProcessById(pid);
                        //发送关闭消息来关闭进程
                        if (!pro.CloseMainWindow())
                        {
                            //强制关闭进程
                            pro.Kill();
                        }
                        //等待进程退出
                        pro.WaitForExit();
                        //释放进程资源
                        pro.Close();
                    }
                    catch (Exception ex)
                    {

                    }
                    //更新processMemoryInfoListView
                    updateProcessMemoryInfoListView();
                }
            }
        }

    }
}
