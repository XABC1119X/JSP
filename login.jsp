<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.*, java.util.*" %>

<%
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("1234".equals(username) && "1234".equals(password)) {
            session.setAttribute("user", username); 
            response.sendRedirect("index.jsp");
            return; 
        } else {
            error = "帳號或密碼錯誤";
        }
    }
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登入或註冊 Threads</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type ="text/css" href="css/style.css">
    <style>
        .card-style {
            border-radius: 20px;
            padding: 30px;
            max-width: 400px;
            background: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="d-flex justify-content-center align-items-center vh-100 bg-light">
    <div class="card-style text-center">
        <h5 class="fw-bold mb-3">登入或註冊 Threads</h5>
        <p class="text-muted">查看人們談論的主題，並加入對話。</p>
        <form method="post">
            <input name="username" class="form-control mb-2" placeholder="帳號名稱" required>
            <input type="password" name="password" class="form-control mb-3" placeholder="密碼" required>
            <div class="d-grid gap-2">
                <button name="action" value="login" class="btn btn-dark">登入</button>
                <button name="action" value="register" class="btn btn-outline-dark">註冊</button>
            </div>
        </form>
        <% if (error != null) { %>
            <div class="alert alert-danger mt-3"><%= error %></div>
        <% } %>
    </div>
</body>
</html>
