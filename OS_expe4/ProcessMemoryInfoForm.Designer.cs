namespace OS_expe4
{
    partial class processMemoryInfoForm
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.processMemoryInfoListViewPanel = new System.Windows.Forms.Panel();
            this.processMemoryInfoListView = new System.Windows.Forms.ListView();
            this.ProcessName = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.Id = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.PageFaultCount = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.PeakWorkingSetSize = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.WorkingSetSize = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.QuotaPeakPagedPoolUsage = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.QuotaPagedPoolUsage = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.QuotaPeakNonPagedPoolUsage = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.QuotaNonPagedPoolUsage = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.PagefileUsage = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.PeakPagefileUsage = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.updateProcessMemoryInfoListViewButton = new System.Windows.Forms.Button();
            this.killProcessButton = new System.Windows.Forms.Button();
            this.processNumLabel = new System.Windows.Forms.Label();
            this.processMemoryInfoListViewPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // processMemoryInfoListViewPanel
            // 
            this.processMemoryInfoListViewPanel.Controls.Add(this.processMemoryInfoListView);
            this.processMemoryInfoListViewPanel.Location = new System.Drawing.Point(0, 0);
            this.processMemoryInfoListViewPanel.Name = "processMemoryInfoListViewPanel";
            this.processMemoryInfoListViewPanel.Size = new System.Drawing.Size(1082, 483);
            this.processMemoryInfoListViewPanel.TabIndex = 3;
            // 
            // processMemoryInfoListView
            // 
            this.processMemoryInfoListView.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.ProcessName,
            this.Id,
            this.PageFaultCount,
            this.PeakWorkingSetSize,
            this.WorkingSetSize,
            this.QuotaPeakPagedPoolUsage,
            this.QuotaPagedPoolUsage,
            this.QuotaPeakNonPagedPoolUsage,
            this.QuotaNonPagedPoolUsage,
            this.PagefileUsage,
            this.PeakPagefileUsage});
            this.processMemoryInfoListView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.processMemoryInfoListView.Location = new System.Drawing.Point(0, 0);
            this.processMemoryInfoListView.Name = "processMemoryInfoListView";
            this.processMemoryInfoListView.Size = new System.Drawing.Size(1082, 483);
            this.processMemoryInfoListView.TabIndex = 2;
            this.processMemoryInfoListView.UseCompatibleStateImageBehavior = false;
            this.processMemoryInfoListView.View = System.Windows.Forms.View.Details;
            // 
            // ProcessName
            // 
            this.ProcessName.Text = "进程名";
            // 
            // Id
            // 
            this.Id.Text = "ID";
            // 
            // PageFaultCount
            // 
            this.PageFaultCount.Text = "缺页中断次数";
            this.PageFaultCount.Width = 90;
            // 
            // PeakWorkingSetSize
            // 
            this.PeakWorkingSetSize.Text = "使用内存高峰";
            this.PeakWorkingSetSize.Width = 90;
            // 
            // WorkingSetSize
            // 
            this.WorkingSetSize.Text = "当前使用内存";
            this.WorkingSetSize.Width = 90;
            // 
            // QuotaPeakPagedPoolUsage
            // 
            this.QuotaPeakPagedPoolUsage.Text = "使用页面缓存池高峰";
            this.QuotaPeakPagedPoolUsage.Width = 120;
            // 
            // QuotaPagedPoolUsage
            // 
            this.QuotaPagedPoolUsage.Text = "使用页面缓存池";
            this.QuotaPagedPoolUsage.Width = 100;
            // 
            // QuotaPeakNonPagedPoolUsage
            // 
            this.QuotaPeakNonPagedPoolUsage.Text = "使用非分页缓存池高峰";
            this.QuotaPeakNonPagedPoolUsage.Width = 140;
            // 
            // QuotaNonPagedPoolUsage
            // 
            this.QuotaNonPagedPoolUsage.Text = "使用非分页缓存池";
            this.QuotaNonPagedPoolUsage.Width = 110;
            // 
            // PagefileUsage
            // 
            this.PagefileUsage.Text = "使用分页文件";
            this.PagefileUsage.Width = 90;
            // 
            // PeakPagefileUsage
            // 
            this.PeakPagefileUsage.Text = "使用分页文件高峰";
            this.PeakPagefileUsage.Width = 110;
            // 
            // updateProcessMemoryInfoListViewButton
            // 
            this.updateProcessMemoryInfoListViewButton.Location = new System.Drawing.Point(878, 497);
            this.updateProcessMemoryInfoListViewButton.Name = "updateProcessMemoryInfoListViewButton";
            this.updateProcessMemoryInfoListViewButton.Size = new System.Drawing.Size(111, 23);
            this.updateProcessMemoryInfoListViewButton.TabIndex = 4;
            this.updateProcessMemoryInfoListViewButton.Text = "更新进程内存信息";
            this.updateProcessMemoryInfoListViewButton.UseVisualStyleBackColor = true;
            this.updateProcessMemoryInfoListViewButton.Click += new System.EventHandler(this.updateProcessMemoryInfoListViewButton_Click);
            // 
            // killProcessButton
            // 
            this.killProcessButton.Location = new System.Drawing.Point(995, 497);
            this.killProcessButton.Name = "killProcessButton";
            this.killProcessButton.Size = new System.Drawing.Size(75, 23);
            this.killProcessButton.TabIndex = 5;
            this.killProcessButton.Text = "结束进程";
            this.killProcessButton.UseVisualStyleBackColor = true;
            this.killProcessButton.Click += new System.EventHandler(this.killProcessButton_Click);
            // 
            // processNumLabel
            // 
            this.processNumLabel.AutoSize = true;
            this.processNumLabel.Location = new System.Drawing.Point(12, 508);
            this.processNumLabel.Name = "processNumLabel";
            this.processNumLabel.Size = new System.Drawing.Size(53, 12);
            this.processNumLabel.TabIndex = 6;
            this.processNumLabel.Text = "进程数：";
            // 
            // processMemoryInfoForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1082, 532);
            this.Controls.Add(this.processNumLabel);
            this.Controls.Add(this.killProcessButton);
            this.Controls.Add(this.updateProcessMemoryInfoListViewButton);
            this.Controls.Add(this.processMemoryInfoListViewPanel);
            this.Name = "processMemoryInfoForm";
            this.Text = "进程内存信息";
            this.processMemoryInfoListViewPanel.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Panel processMemoryInfoListViewPanel;
        private System.Windows.Forms.ListView processMemoryInfoListView;
        private System.Windows.Forms.ColumnHeader ProcessName;
        private System.Windows.Forms.ColumnHeader Id;
        private System.Windows.Forms.ColumnHeader PageFaultCount;
        private System.Windows.Forms.ColumnHeader PeakWorkingSetSize;
        private System.Windows.Forms.ColumnHeader WorkingSetSize;
        private System.Windows.Forms.ColumnHeader QuotaPeakPagedPoolUsage;
        private System.Windows.Forms.ColumnHeader QuotaPagedPoolUsage;
        private System.Windows.Forms.ColumnHeader QuotaPeakNonPagedPoolUsage;
        private System.Windows.Forms.ColumnHeader QuotaNonPagedPoolUsage;
        private System.Windows.Forms.ColumnHeader PagefileUsage;
        private System.Windows.Forms.ColumnHeader PeakPagefileUsage;
        private System.Windows.Forms.Button updateProcessMemoryInfoListViewButton;
        private System.Windows.Forms.Button killProcessButton;
        private System.Windows.Forms.Label processNumLabel;


    }
}

