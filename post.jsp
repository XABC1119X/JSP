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

<div class="content">
    <h3>🧵 Threads 留言牆</h3>
    
    <% if (user != null) { %>
        <form method="post" class="mb-4">
            <textarea name="message" class="form-control mb-2" placeholder="輸入貼文內容..."></textarea>
            <input name="image" class="form-control mb-2" placeholder="圖片網址 (可選)">
            <button type="submit" class="btn btn-primary">發佈</button>
        </form>
    <% } else { %>
        <div class="alert alert-warning">登入後可留言</div>
    <% } %>

</div>