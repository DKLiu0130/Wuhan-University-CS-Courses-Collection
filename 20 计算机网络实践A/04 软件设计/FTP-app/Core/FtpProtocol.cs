using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FTP_app.Core
{
    public static class FtpProtocol
    {
        // 常用指令
        public const string User = "USER";
        public const string Pass = "PASS";
        public const string Rest = "REST"; // 断点续传关键指令
        public const string Retr = "RETR"; // 下载
        public const string Stor = "STOR"; // 上传
        public const string Appe = "APPE"; // 追加上传（断点续传用）
        public const string Pasv = "PASV"; // 被动模式

        // 状态码判断
        public const string Welcome = "220";
        public const string LoggedIn = "230";
        public const string PathCreated = "257";
        public const string DataOpen = "150";
        public const string TransferComplete = "226";
    }
}