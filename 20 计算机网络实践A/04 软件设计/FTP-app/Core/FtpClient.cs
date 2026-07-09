using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;

namespace FTP_app.Core
{
    public class FtpClient
    {
        private Socket _ctrlSocket;
        private string _ip;
        private int _port;

        public FtpClient(string ip, int port = 21)
        {
            _ip = ip; _port = port;
        }

        // 发送指令并获取回复
        public string SendCommand(string cmd)
        {
            byte[] data = Encoding.UTF8.GetBytes(cmd + "\r\n");
            _ctrlSocket.Send(data);
            return ReadResponse();
        }

        public string ReadResponse()
        {
            byte[] buffer = new byte[1024];
            int len = _ctrlSocket.Receive(buffer);
            return Encoding.UTF8.GetString(buffer, 0, len);
        }

        public string Connect(string user, string pass)
        {
            _ctrlSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            _ctrlSocket.Connect(new IPEndPoint(IPAddress.Parse(_ip), _port));
            ReadResponse(); // 220
            SendCommand("USER " + user);
            return SendCommand("PASS " + pass); // 230
        }

        // 【核心】获取文件列表
        public List<string[]> GetFileList()
        {
            string response = SendCommand("PASV");
            int dataPort = ParsePasvPort(response);

            Socket dataSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            dataSocket.Connect(new IPEndPoint(IPAddress.Parse(_ip), dataPort));

            SendCommand("LIST");

            List<string[]> fileList = new List<string[]>();
            using (var sr = new StreamReader(new NetworkStream(dataSocket), Encoding.Default))
            {
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    // 使用正则表达式解析：权限 链接 拥有者 组 大小 月份 日期 时间/年份 文件名
                    // 这是一个匹配大多数 FTP Unix 格式的正则
                    var match = Regex.Match(line, @"^([\w-]{10})\s+\d+\s+\w+\s+\w+\s+(\d+)\s+(\w+\s+\d+\s+[\d:]+)\s+(.*)$");

                    if (match.Success)
                    {
                        string size = match.Groups[2].Value;   // 文件大小
                        string date = match.Groups[3].Value;   // 日期时间
                        string name = match.Groups[4].Value;   // 文件名

                        fileList.Add(new string[] { name, size, date });
                    }
                    else
                    {
                        // 如果正则匹配失败，至少把整行放进去防止漏掉数据
                        fileList.Add(new string[] { line, "", "" });
                    }
                }
            }
            dataSocket.Close();
            ReadResponse();
            return fileList;
        }

        private int ParsePasvPort(string res)
        {
            var m = Regex.Match(res, @"\((\d+),(\d+),(\d+),(\d+),(\d+),(\d+)\)");
            return int.Parse(m.Groups[5].Value) * 256 + int.Parse(m.Groups[6].Value);
        }

        // 下载文件
        public void DownloadFile(string remoteFile, string localPath)
        {
            // 1. 设置为二进制模式
            SendCommand("TYPE I");

            // 2. 开启被动模式
            string pasvRes = SendCommand("PASV");
            int dataPort = ParsePasvPort(pasvRes);

            // 3. 建立数据连接
            using (Socket dataSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp))
            {
                dataSocket.Connect(new IPEndPoint(IPAddress.Parse(_ip), dataPort));

                // 4. 发送下载指令
                SendCommand("RETR " + remoteFile);

                // 5. 接收字节流并写入本地文件
                using (FileStream fs = new FileStream(localPath, FileMode.Create))
                {
                    byte[] buffer = new byte[8192];
                    int received;
                    while ((received = dataSocket.Receive(buffer)) > 0)
                    {
                        fs.Write(buffer, 0, received);
                    }
                }
            }
            ReadResponse(); // 读取 226 Transfer complete
        }

        // 上传文件
        public void UploadFile(string localPath, string remoteFile)
        {
            SendCommand("TYPE I");

            string pasvRes = SendCommand("PASV");
            int dataPort = ParsePasvPort(pasvRes);

            using (Socket dataSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp))
            {
                dataSocket.Connect(new IPEndPoint(IPAddress.Parse(_ip), dataPort));

                SendCommand("STOR " + remoteFile);

                using (FileStream fs = new FileStream(localPath, FileMode.Open))
                {
                    byte[] buffer = new byte[8192];
                    int sent;
                    while ((sent = fs.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        dataSocket.Send(buffer, 0, sent, SocketFlags.None);
                    }
                }
            }
            ReadResponse(); // 读取 226 Transfer complete
        }

        public void DownloadFileResumable(string remoteFile, string localPath)
        {
            long localFileSize = 0;
            if (File.Exists(localPath))
            {
                localFileSize = new FileInfo(localPath).Length;
            }

            SendCommand("TYPE I");
            string pasvRes = SendCommand("PASV");
            int dataPort = ParsePasvPort(pasvRes);

            using (Socket dataSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp))
            {
                dataSocket.Connect(new IPEndPoint(IPAddress.Parse(_ip), dataPort));

                // 【关键】告诉服务器从哪个位置开始读取
                if (localFileSize > 0)
                {
                    SendCommand("REST " + localFileSize);
                }

                SendCommand("RETR " + remoteFile);

                // 使用 Append 模式打开本地文件流
                using (FileStream fs = new FileStream(localPath, FileMode.Append, FileAccess.Write))
                {
                    byte[] buffer = new byte[8192];
                    int received;
                    while ((received = dataSocket.Receive(buffer)) > 0)
                    {
                        fs.Write(buffer, 0, received);
                        // 这里可以计算进度：(localFileSize + fs.Position) / 总大小
                    }
                }
            }
            ReadResponse();
        }

        public void UploadFileResumable(string localPath, string remoteFile)
        {
            // 1. 获取服务器上已存在的文件大小 (使用 SIZE 指令)
            string sizeRes = SendCommand("SIZE " + remoteFile);
            long remoteSize = 0;
            if (sizeRes.StartsWith("213"))
            {
                remoteSize = long.Parse(sizeRes.Substring(4).Trim());
            }

            SendCommand("TYPE I");
            string pasvRes = SendCommand("PASV");
            int dataPort = ParsePasvPort(pasvRes);

            using (Socket dataSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp))
            {
                dataSocket.Connect(new IPEndPoint(IPAddress.Parse(_ip), dataPort));

                // 【关键】使用 APPE 指令实现追加上传
                SendCommand("APPE " + remoteFile);

                using (FileStream fs = new FileStream(localPath, FileMode.Open, FileAccess.Read))
                {
                    if (remoteSize > 0) fs.Seek(remoteSize, SeekOrigin.Begin); // 跳过已上传部分

                    byte[] buffer = new byte[8192];
                    int sent;
                    while ((sent = fs.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        dataSocket.Send(buffer, 0, sent, SocketFlags.None);
                    }
                }
            }
            ReadResponse();
        }
    }
}