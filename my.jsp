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

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ServletContext ctx = getServletContext();
    List<String[]> posts = (List<String[]>) ctx.getAttribute("posts");
    if (posts == null) posts = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= user %> 的 Threads</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type ="text/css" href="css/style.css">
</head>
<body class="bg-light">
<div class="container py-4">
     <!-- 左側列表 -->
     <div class="sidebar">
        <ul>
            <h1>⚔︎</h1>
            <li><a href="index.jsp">🏠 回首頁</a></li>
            <li><a href="logout.jsp" class="logout">🚪 登出</a></li>
        </ul>
    </div>

     <!-- 右側留言牆 -->
     <div class="content">
       <h3>👤 @<%= user %> 的 Threads</h3>
        <% for (int i = posts.size() - 1; i >= 0; i--) {
            String[] post = posts.get(i);
            if (user.equals(post[0])) {
        %>
            <div class="card mb-3 p-3">
                <strong>@<%= post[0] %></strong><br>
                <p><%= post[1] %></p>
                <% if (post[2] != null && !post[2].isEmpty()) { %>
                    <img src="<%= post[2] %>" class="img-fluid rounded" style="max-width:300px">
                <% } %>
            </div>
        <% }} %>
    </div>

    
</div>
</body>
</html>
