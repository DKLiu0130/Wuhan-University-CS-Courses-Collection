using System;
using System.Windows.Forms;
using FTP_app.Views; // 这里指向你放界面的文件夹

namespace FTP_app
{
    internal static class Program
    {
        [STAThread]
        static void Main()
        {
            ApplicationConfiguration.Initialize();
            // 启动时打开我们下面要创建的 MainForm
            Application.Run(new MainForm());
        }
    }
}