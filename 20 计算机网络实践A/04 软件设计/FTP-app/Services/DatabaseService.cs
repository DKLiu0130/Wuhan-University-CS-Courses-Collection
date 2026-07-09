using Microsoft.Data.Sqlite;

namespace FTP_app.Services
{
    public class DatabaseService
    {
        private string _dbPath = "Data Source=ftp_tasks.db";

        public void InitDb()
        {
            using (var conn = new SqliteConnection(_dbPath))
            {
                conn.Open();
                var cmd = conn.CreateCommand();
                // 创建任务表：记录文件名、已下载大小、总大小
                cmd.CommandText = @"
                    CREATE TABLE IF NOT EXISTS DownloadTasks (
                        Id INTEGER PRIMARY KEY,
                        FileName TEXT,
                        LocalPath TEXT,
                        TransferredSize BIGINT,
                        TotalSize BIGINT
                    )";
                cmd.ExecuteNonQuery();
            }
        }
    }
}