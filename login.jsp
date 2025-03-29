<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.*, java.util.*" %>
<%
    String error = null;
    String user = null;
    ServletContext ctx = getServletContext();
    Map<String, String> users = (Map<String, String>) ctx.getAttribute("users");
    if (users == null) {
        users = new HashMap<>();
        ctx.setAttribute("users", users);
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            if (users.containsKey(u) && users.get(u).equals(p)) {
                Cookie c = new Cookie("user", u);
                c.setMaxAge(3600);
                response.addCookie(c);
                response.sendRedirect("index.jsp");
                return;
            } else {
                error = "登入失敗：帳號或密碼錯誤";
            }
        } else if ("register".equals(action)) {
            if (users.containsKey(u)) {
                error = "註冊失敗：帳號已存在";
            } else {
                users.put(u, p);
                Cookie c = new Cookie("user", u);
                c.setMaxAge(3600);
                response.addCookie(c);
                response.sendRedirect("index.jsp");
                return;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登入或註冊 Threads</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
