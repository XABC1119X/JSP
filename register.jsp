<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.UserDatabase" %>

<%
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (UserDatabase.exists(username)) {
            message = "⚠️ 此帳號已存在，請選擇其他帳號。";
        } else {
            UserDatabase.register(username, password);
            session.setAttribute("user", username);
            response.sendRedirect("index.jsp");
            return;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>註冊新帳號</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="d-flex justify-content-center align-items-center vh-100 bg-light">
    <div class="card p-4 shadow rounded" style="width: 350px;">
        <h5 class="text-center fw-bold mb-3">註冊帳號</h5>
        <form method="post">
            <input name="username" class="form-control mb-2" placeholder="帳號名稱" required>
            <input type="password" name="password" class="form-control mb-3" placeholder="密碼" required>
            <button type="submit" class="btn btn-primary w-100">註冊</button>
        </form>
        <% if (message != null) { %>
            <div class="alert alert-warning mt-3"><%= message %></div>
        <% } %>
        <a href="login.jsp" class="d-block mt-3 text-center text-decoration-none ">已有帳號？前往登入</a>
    </div>
</body>
</html>
