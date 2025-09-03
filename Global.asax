<%@ Application Language="C#" %>
<script runat="server">
    bool IsPrivateIp(string ip) {
        if (string.IsNullOrEmpty(ip)) return false;
        // handle IPv6 localhost
        if (ip == "::1") return true;
        // strip port if any
        int idx = ip.IndexOf(':');
        if (idx > -1) ip = ip.Substring(0, idx);
        return ip.StartsWith("10.") || ip.StartsWith("192.168.") ||
               (ip.StartsWith("172.") && IsInRange172(ip));
    }
    bool IsInRange172(string ip) {
        // 172.16.0.0 - 172.31.255.255
        try {
            var parts = ip.Split('.');
            int second = int.Parse(parts[1]);
            return second >= 16 && second <= 31;
        } catch { return false; }
    }

    void Application_BeginRequest(object sender, EventArgs e) {
        try {
            var force = System.Configuration.ConfigurationManager.AppSettings["ForceHttps"];
            var allowInternal = System.Configuration.ConfigurationManager.AppSettings["AllowInternalHttp"];
            string host = Request.Headers["HOST"];
            string clientIp = Request.UserHostAddress;
            bool isInternal = Request.IsLocal || IsPrivateIp(clientIp);

            if (!string.IsNullOrEmpty(force) && force.ToLower() == "true" && !Request.IsSecureConnection) {
                // 若允許內網 HTTP 且來源為內網，則不轉向
                if (!("true".Equals((allowInternal ?? "").ToLower())) || !isInternal) {
                    string url = "https://" + host + Request.RawUrl;
                    Response.RedirectPermanent(url, true);
                }
            }
        } catch {}
    }

    void Application_Error(object sender, EventArgs e) {
        try {
            var ex = Server.GetLastError();
            var path = System.Configuration.ConfigurationManager.AppSettings["LogDir"];
            if (!System.IO.Directory.Exists(path)) System.IO.Directory.CreateDirectory(path);
            var file = System.IO.Path.Combine(path, "errors-" + DateTime.Now.ToString("yyyyMMdd") + ".log");
            using (var sw = new System.IO.StreamWriter(file, true, new System.Text.UTF8Encoding(true))) {
                sw.WriteLine(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " | " + ex);
            }
        } catch {}
    }
</script>
