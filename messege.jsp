<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String sender = (String) session.getAttribute("user");
    String recipient = request.getParameter("to");

    if (sender == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (recipient == null || recipient.isEmpty()) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>選擇聊天對象</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
    <form method="get" action="messege.jsp">
        <label class="form-label">請輸入對方使用者名稱：</label>
        <div class="input-group">
            <input type="text" name="to" class="form-control" required>
            <button class="btn btn-success">開始聊天</button>
        </div>
    </form>
</body>
</html>
<%
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>與 @<%= recipient %> 聊天</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
    <h3>與 <strong>@<%= recipient %></strong> 私訊中</h3>
    <div id="chat-box" class="border rounded p-3 mb-3" style="height: 300px; overflow-y: auto;"></div>
    <div class="input-group">
        <input id="msgInput" class="form-control" placeholder="輸入訊息...">
        <button class="btn btn-primary" onclick="sendMessage()">送出</button>
    </div>
    <script>
        const sender = "<%= sender %>";
        const recipient = "<%= recipient %>";
        const chatBox = document.getElementById("chat-box");
        const ws = new WebSocket("ws://" + window.location.host + "<%= request.getContextPath() %>/private/" + sender);

        ws.onmessage = function(event) {
            const div = document.createElement("div");
            div.textContent = event.data;
            chatBox.appendChild(div);
            chatBox.scrollTop = chatBox.scrollHeight;
        };

        function sendMessage() {
            const input = document.getElementById("msgInput");
            const msg = input.value.trim();
            if (msg) {
                ws.send(recipient + ":" + msg);
                input.value = "";
            }
        }
    </script>
</body>
</html>
