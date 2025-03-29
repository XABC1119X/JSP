<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.Cookie, java.util.*" %>
<%
    String user = null;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("user".equals(c.getName())) {
                user = c.getValue();
            }
        }
    }

    ServletContext ctx = getServletContext();
    List<String[]> posts = (List<String[]>) ctx.getAttribute("posts");
    if (posts == null) {
        posts = new ArrayList<>();
        ctx.setAttribute("posts", posts);
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && user != null) {
        String msg = request.getParameter("message");
        String img = request.getParameter("image");
        if (msg != null && !msg.trim().isEmpty()) {
            posts.add(new String[]{user, msg, img});
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Threads 留言牆</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type ="text/css" href="css/style.css">
</head>

<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3>🧵 Threads 留言牆</h3>
        <% if (user != null) { %>
            <a href="my.jsp" class="btn btn-sm btn-outline-dark">👤 我的主頁</a>
        <% } else { %>
            <a href="login.jsp" class="btn btn-sm btn-outline-primary">登入 / 註冊</a>
        <% } %>
    </div>

    <% if (user != null) { %>
    <form method="post" class="mb-4">
        <textarea name="message" class="form-control mb-2" placeholder="輸入貼文內容..."></textarea>
        <input name="image" class="form-control mb-2" placeholder="圖片網址 (可選)">
        <button type="submit" class="btn btn-primary">發佈</button>
    </form>
    <% } else { %>
        <div class="alert alert-warning">登入後可留言</div>
    <% } %>

    <% for (int i = posts.size() - 1; i >= 0; i--) {
        String[] post = posts.get(i);
    %>
        <div class="card mb-3 p-3">
            <strong>@<%= post[0] %></strong><br>
            <p><%= post[1] %></p>
            <% if (post[2] != null && !post[2].isEmpty()) { %>
                <img src="<%= post[2] %>" class="img-fluid rounded" style="max-width:300px">
            <% } %>
        </div>
    <% } %>
</div>
</body>
</html>
