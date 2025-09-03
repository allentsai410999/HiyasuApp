<%@ Page Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.Text" %>
<!DOCTYPE html><html><head><meta charset="utf-8" /><title>DB 測試</title>
<style>body{font-family:Arial;margin:24px}table{border-collapse:collapse}td,th{border:1px solid #ccc;padding:8px}</style></head>
<body><h2>DB 連線測試</h2>
<% Response.ContentEncoding = Encoding.UTF8;
var rows = new System.Collections.Generic.List<string>();
string mode = System.Configuration.ConfigurationManager.AppSettings["DbMode"];
string cs = HiyasuApp.DbUtil.GetConnectionString();
var sw = Stopwatch.StartNew();
try { using (var conn = new SqlConnection(cs)){
    conn.Open(); sw.Stop(); var openMs = sw.ElapsedMilliseconds;
    sw.Restart(); using (var cmd = new SqlCommand("SELECT 1", conn)) { cmd.ExecuteScalar(); } sw.Stop(); var pingMs = sw.ElapsedMilliseconds;
    int count = -1; try { using (var cmd2 = new SqlCommand("IF OBJECT_ID('dbo.comCustomer') IS NOT NULL SELECT COUNT(*) FROM dbo.comCustomer ELSE SELECT -1", conn)){ count = Convert.ToInt32(cmd2.ExecuteScalar()); } } catch {}
    DateTime dbTime; using (var cmd3 = new SqlCommand("SELECT GETDATE()", conn)){ dbTime = (DateTime)cmd3.ExecuteScalar(); }
    rows.Add("<tr><td>連線</td><td style='color:green'>成功</td></tr>");
    rows.Add("<tr><td>Open 延遲</td><td>"+openMs+" ms</td></tr>");
    rows.Add("<tr><td>Ping 延遲</td><td>"+pingMs+" ms</td></tr>");
    rows.Add("<tr><td>comCustomer 筆數</td><td>"+count+"</td></tr>");
    rows.Add("<tr><td>DB 時間</td><td>"+dbTime.ToString("yyyy-MM-dd HH:mm:ss")+"</td></tr>");
} } catch (Exception ex){ rows.Add("<tr><td>連線</td><td style='color:red'>失敗："+System.Web.HttpUtility.HtmlEncode(ex.Message)+"</td></tr>"); } %>
<table><%= string.Join("", rows.ToArray()) %></table>
<p>目前模式：<b><%= mode %></b></p>
</body></html>