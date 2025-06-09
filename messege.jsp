<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String sender = (String) session.getAttribute("user");
    String recipient = request.getParameter("to");

    if (sender == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (recipient == null || recipient.trim().isEmpty()) {
%>
        <!DOCTYPE html>
        <html>
        <head>
            <title>私訊聊天室</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>
        <body class="container py-4">
            <h3>輸入要聊天的使用者名稱</h3>
            <form method="get" action="chat.jsp">
                <div class="input-group mb-3">
                    <input type="text" name="to" class="form-control" placeholder="對方使用者名稱">
                    <button type="submit" class="btn btn-success">開始聊天</button>
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
    <title>與 @<%= recipient %> 聊天中</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
    <h3>與 <strong>@<%= recipient %></strong> 私訊中</h3>
    <div id="chat-box" class="border rounded p-3 mb-3" style="height: 300px; overflow-y: auto; background: #f8f9fa;"></div>
    
    <div class="input-group">
        <input type="text" id="msgInput" class="form-control" placeholder="輸入訊息...">
        <button onclick="sendMessage()" class="btn btn-primary">送出</button>
    </div>

    <script>
        const sender = "<%= sender %>";
        const recipient = "<%= recipient %>";
        const ws = new WebSocket("ws://" + window.location.host + "/你的專案名/private/" + sender);
        const chatBox = document.getElementById("chat-box");

        ws.onmessage = function(event) {
            const div = document.createElement("div");
            div.textContent = event.data;
            chatBox.appendChild(div);
            chatBox.scrollTop = chatBox.scrollHeight;
        };

        function sendMessage() {
            const input = document.getElementById("msgInput");
            const text = input.value.trim();
            if (text !== "") {
                ws.send(recipient + ":" + text);
                input.value = "";
            }
        }
    </script>
</body>
</html>
