<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head runat="server">
  <meta charset="utf-8" />
  <title>HiyasuApp 測試首頁</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Noto Sans TC","Helvetica Neue",Arial;margin:24px;font-size:16px}
    h1{font-size:32px;margin-bottom:8px}
    .box{border:1px solid #ddd;padding:12px;border-radius:8px;margin:12px 0}
    input,button{font-size:16px;padding:8px;margin:4px}
    pre{white-space:pre-wrap;word-break:break-all;background:#111;color:#eee;padding:12px;border-radius:8px}
    a.btn{display:inline-block;border:1px solid #ccc;padding:6px 10px;border-radius:6px;text-decoration:none}
  </style>
</head>
<body>
  <h1>HiyasuApp 測試首頁</h1>
  <p>現在時間：<%= DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") %></p>

  <div class="box">
    <h3>健康檢查</h3>
    <button onclick="fetchJson('Api/HealthPing.ashx')">Ping</button>
    <button onclick="fetchJson('Api/HealthDb.ashx')">DB</button>
    <a class="btn" href="Api/HealthPing.ashx" target="_blank">開新視窗</a>
  </div>

  <div class="box">
    <h3>登入測試 (comCustomer.Email + comCustomer.Moderm)</h3>
    <input id="email" placeholder="Email">
    <input id="pwd" type="password" placeholder="Password">
    <button onclick="login()">Login</button>
  </div>

  <div class="box">
    <h3>商品查詢 (comProduct)</h3>
    <input id="kw" placeholder="關鍵字">
    <button onclick="products()">查詢</button>
  </div>

  <div class="box">
    <a class="btn" href="adalo_test.html">打開 adalo_test.html 測試頁</a>
  </div>

  <pre id="out"></pre>

  <script>
    async function fetchJson(url, opts = {}){
      try{
        const res = await fetch(url, Object.assign({method:'GET'}, opts));
        const txt = await res.text();
        document.getElementById('out').textContent = url + "\\n" + txt;
      }catch(e){
        document.getElementById('out').textContent = "呼叫失敗: " + e;
      }
    }
    function login(){
      const email = document.getElementById('email').value;
      const password = document.getElementById('pwd').value;
      fetchJson('Api/Login.ashx', {method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({email, password})});
    }
    function products(){
      const kw = document.getElementById('kw').value;
      fetchJson('Api/Products.ashx?keyword=' + encodeURIComponent(kw));
    }
  </script>
</body>
</html>