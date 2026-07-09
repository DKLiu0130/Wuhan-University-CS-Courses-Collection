using FTP_app.Core;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net.Sockets;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace FTP_app.Views
{
    public partial class MainForm : Form
    {
        // 【核心修正】在这里声明变量，类型是 FtpClient
        // 加个问号表示它可以为空
        private FtpClient? _client;

        public MainForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                // 从界面文本框抓取数据
                _client = new FtpClient(txtIP.Text, int.Parse(txtPort.Text));
                string res = _client.Connect(txtUser.Text, txtPass.Text);

                if (res.Contains("230"))
                {
                    lstLog.Items.Add(">登录成功！");
                    RefreshFiles(); // 登录后自动刷新一次列表
                }
                else
                {
                    lstLog.Items.Add(">登录失败: " + res);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void btnDownload_Click(object sender, EventArgs e)
        {
            if (lstFiles.SelectedItems.Count == 0) return;
            string remoteFile = lstFiles.SelectedItems[0].Text;

            SaveFileDialog sfd = new SaveFileDialog { FileName = remoteFile };
            if (sfd.ShowDialog() == DialogResult.OK)
            {
                // 检查文件是否已存在
                if (File.Exists(sfd.FileName))
                {
                    var result = MessageBox.Show("文件已存在，是否断点续传？", "提示", MessageBoxButtons.YesNoCancel);
                    if (result == DialogResult.Cancel) return;
                    if (result == DialogResult.No) File.Delete(sfd.FileName); // 重新下载
                }

                Task.Run(() => { // 放在后台线程跑，防止界面卡死
                    try
                    {
                        _client.DownloadFileResumable(remoteFile, sfd.FileName);
                        this.Invoke(new Action(() => lstLog.Items.Add("下载完成（含续传）")));
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                    }
                });
            }
        }

        private void btnUpload_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            if (ofd.ShowDialog() == DialogResult.OK)
            {
                try
                {
                    string remoteFile = Path.GetFileName(ofd.FileName);
                    _client.UploadFile(ofd.FileName, remoteFile);
                    lstLog.Items.Add($"上传完成: {remoteFile}");
                    RefreshFiles(); // 上传后刷新列表查看新文件
                    MessageBox.Show("上传成功！");
                }
                catch (Exception ex)
                {
                    MessageBox.Show("上传失败: " + ex.Message);
                }
            }
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            RefreshFiles();
        }

        private void RefreshFiles()
        {
            if (_client == null) return;

            lstFiles.Items.Clear();
            var files = _client.GetFileList();

            foreach (var fileInfo in files)
            {
                // 1. 第一列显示文件名
                ListViewItem item = new ListViewItem(fileInfo[0]);

                // 2. 如果解析成功，填充剩余两列
                if (fileInfo.Length > 1)
                {
                    item.SubItems.Add(fileInfo[1]); // 大小列
                    item.SubItems.Add(fileInfo[2]); // 修改日期列
                }

                lstFiles.Items.Add(item);
            }
            lstLog.Items.Add(">列表解析完成");
        }

        
    }
}