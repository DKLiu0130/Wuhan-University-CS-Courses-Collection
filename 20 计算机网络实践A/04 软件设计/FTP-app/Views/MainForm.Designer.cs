namespace FTP_app.Views
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            btnConnect = new Button();
            gbConnection = new GroupBox();
            label4 = new Label();
            label3 = new Label();
            label2 = new Label();
            label1 = new Label();
            txtPort = new TextBox();
            txtPass = new TextBox();
            txtUser = new TextBox();
            txtIP = new TextBox();
            gbFiles = new GroupBox();
            lstFiles = new ListView();
            FileName = new ColumnHeader();
            Size = new ColumnHeader();
            DateModified = new ColumnHeader();
            gbStatus = new GroupBox();
            btnRefresh = new Button();
            btnUpload = new Button();
            btnDownload = new Button();
            progressBar1 = new ProgressBar();
            lstLog = new ListBox();
            gbConnection.SuspendLayout();
            gbFiles.SuspendLayout();
            gbStatus.SuspendLayout();
            SuspendLayout();
            // 
            // btnConnect
            // 
            btnConnect.Location = new Point(860, 91);
            btnConnect.Name = "btnConnect";
            btnConnect.Size = new Size(128, 46);
            btnConnect.TabIndex = 0;
            btnConnect.Text = "连接";
            btnConnect.UseVisualStyleBackColor = true;
            btnConnect.Click += button1_Click;
            // 
            // gbConnection
            // 
            gbConnection.Controls.Add(label4);
            gbConnection.Controls.Add(label3);
            gbConnection.Controls.Add(label2);
            gbConnection.Controls.Add(label1);
            gbConnection.Controls.Add(txtPort);
            gbConnection.Controls.Add(txtPass);
            gbConnection.Controls.Add(txtUser);
            gbConnection.Controls.Add(txtIP);
            gbConnection.Controls.Add(btnConnect);
            gbConnection.Location = new Point(97, 40);
            gbConnection.Name = "gbConnection";
            gbConnection.Size = new Size(1067, 154);
            gbConnection.TabIndex = 1;
            gbConnection.TabStop = false;
            gbConnection.Text = "Connection Area (gbConnection)";
            gbConnection.Enter += groupBox1_Enter;
            // 
            // label4
            // 
            label4.AutoSize = true;
            label4.Location = new Point(708, 52);
            label4.Name = "label4";
            label4.Size = new Size(62, 31);
            label4.TabIndex = 8;
            label4.Text = "端口";
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Location = new Point(477, 52);
            label3.Name = "label3";
            label3.Size = new Size(62, 31);
            label3.TabIndex = 7;
            label3.Text = "密码";
            label3.Click += label3_Click;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Location = new Point(288, 52);
            label2.Name = "label2";
            label2.Size = new Size(86, 31);
            label2.TabIndex = 6;
            label2.Text = "用户名";
            label2.Click += label2_Click;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(54, 52);
            label1.Name = "label1";
            label1.Size = new Size(84, 31);
            label1.TabIndex = 5;
            label1.Text = "IP地址";
            label1.Click += label1_Click;
            // 
            // txtPort
            // 
            txtPort.Location = new Point(708, 96);
            txtPort.Name = "txtPort";
            txtPort.Size = new Size(98, 38);
            txtPort.TabIndex = 4;
            // 
            // txtPass
            // 
            txtPass.Location = new Point(477, 96);
            txtPass.Name = "txtPass";
            txtPass.Size = new Size(200, 38);
            txtPass.TabIndex = 3;
            // 
            // txtUser
            // 
            txtUser.Location = new Point(288, 96);
            txtUser.Name = "txtUser";
            txtUser.Size = new Size(156, 38);
            txtUser.TabIndex = 2;
            // 
            // txtIP
            // 
            txtIP.Location = new Point(54, 96);
            txtIP.Name = "txtIP";
            txtIP.Size = new Size(200, 38);
            txtIP.TabIndex = 1;
            // 
            // gbFiles
            // 
            gbFiles.Controls.Add(lstFiles);
            gbFiles.Location = new Point(97, 222);
            gbFiles.Name = "gbFiles";
            gbFiles.Size = new Size(1067, 268);
            gbFiles.TabIndex = 2;
            gbFiles.TabStop = false;
            gbFiles.Text = "File Area (gbFiles)";
            // 
            // lstFiles
            // 
            lstFiles.Columns.AddRange(new ColumnHeader[] { FileName, Size, DateModified });
            lstFiles.FullRowSelect = true;
            lstFiles.GridLines = true;
            lstFiles.Location = new Point(54, 56);
            lstFiles.Name = "lstFiles";
            lstFiles.Size = new Size(966, 194);
            lstFiles.TabIndex = 0;
            lstFiles.UseCompatibleStateImageBehavior = false;
            lstFiles.View = View.Details;
            // 
            // FileName
            // 
            FileName.Text = "文件名";
            FileName.Width = 400;
            // 
            // Size
            // 
            Size.Text = "大小";
            Size.Width = 200;
            // 
            // DateModified
            // 
            DateModified.Text = "修改日期";
            DateModified.Width = 250;
            // 
            // gbStatus
            // 
            gbStatus.Controls.Add(btnRefresh);
            gbStatus.Controls.Add(btnUpload);
            gbStatus.Controls.Add(btnDownload);
            gbStatus.Controls.Add(progressBar1);
            gbStatus.Controls.Add(lstLog);
            gbStatus.Location = new Point(97, 527);
            gbStatus.Name = "gbStatus";
            gbStatus.Size = new Size(1067, 316);
            gbStatus.TabIndex = 3;
            gbStatus.TabStop = false;
            gbStatus.Text = "Status Area (gbStatus)";
            // 
            // btnRefresh
            // 
            btnRefresh.Location = new Point(708, 231);
            btnRefresh.Name = "btnRefresh";
            btnRefresh.Size = new Size(312, 46);
            btnRefresh.TabIndex = 4;
            btnRefresh.Text = "刷新";
            btnRefresh.UseVisualStyleBackColor = true;
            btnRefresh.Click += btnRefresh_Click;
            // 
            // btnUpload
            // 
            btnUpload.Location = new Point(708, 176);
            btnUpload.Name = "btnUpload";
            btnUpload.Size = new Size(312, 46);
            btnUpload.TabIndex = 3;
            btnUpload.Text = "上传";
            btnUpload.UseVisualStyleBackColor = true;
            btnUpload.Click += btnUpload_Click;
            // 
            // btnDownload
            // 
            btnDownload.Location = new Point(708, 119);
            btnDownload.Name = "btnDownload";
            btnDownload.Size = new Size(312, 46);
            btnDownload.TabIndex = 2;
            btnDownload.Text = "下载";
            btnDownload.UseVisualStyleBackColor = true;
            btnDownload.Click += btnDownload_Click;
            // 
            // progressBar1
            // 
            progressBar1.Location = new Point(708, 56);
            progressBar1.Name = "progressBar1";
            progressBar1.Size = new Size(312, 44);
            progressBar1.TabIndex = 1;
            // 
            // lstLog
            // 
            lstLog.FormattingEnabled = true;
            lstLog.Location = new Point(54, 56);
            lstLog.Name = "lstLog";
            lstLog.Size = new Size(623, 221);
            lstLog.TabIndex = 0;
            // 
            // MainForm
            // 
            AutoScaleDimensions = new SizeF(14F, 31F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1273, 907);
            Controls.Add(gbStatus);
            Controls.Add(gbFiles);
            Controls.Add(gbConnection);
            Name = "MainForm";
            Text = "MainForm";
            gbConnection.ResumeLayout(false);
            gbConnection.PerformLayout();
            gbFiles.ResumeLayout(false);
            gbStatus.ResumeLayout(false);
            ResumeLayout(false);
        }

        #endregion

        private Button btnConnect;
        private GroupBox gbConnection;
        private GroupBox gbFiles;
        private GroupBox gbStatus;
        private Label label1;
        private TextBox txtPort;
        private TextBox txtPass;
        private TextBox txtUser;
        private TextBox txtIP;
        private Label label4;
        private Label label3;
        private Label label2;
        private ListView lstFiles;
        private ColumnHeader FileName;
        private ColumnHeader Size;
        private ColumnHeader DateModified;
        private ProgressBar progressBar1;
        private ListBox lstLog;
        private Button btnRefresh;
        private Button btnUpload;
        private Button btnDownload;
    }
}