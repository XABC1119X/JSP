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

    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>


</head>

<body class="bg-light">

       <!-- 彈跳視窗 -->
       <div class="pop-out" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center;">
        <div class="pop-out-panel" style="background: white; width: 300px; padding: 20px; border-radius: 10px; text-align: center;">
            <h5>新增貼文</h5>

            <% if (user != null) { %>
                <form method="post" class="mb-4">
                    <textarea name="message" class="form-control mb-2" placeholder="輸入貼文內容..." required></textarea>
                    <input name="image" class="form-control mb-2" placeholder="圖片網址 (可選)">
                    <button type="submit" class="btn btn-success">發佈</button>
                    <button type="button" class="close-button btn btn-secondary">取消</button>
                </form>
            <% } else { %>
                <div class="alert alert-warning">登入後可留言</div>
                <div class="button-group">
                    <a href="login.jsp" class="action-button"  >👤 登入 / 註冊</a>
                    <button type="button" class="action-button close-button"  >取消</button>
                </div>
            <% } %>

            
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let popOut = document.querySelector(".pop-out");
            let popButton = document.querySelector(".pop-button");
            let closeButton = document.querySelector(".close-button");

            if (popButton) {
                popButton.addEventListener("click", function () {
                    popOut.style.display = "flex"; 
                    gsap.fromTo(".pop-out", { opacity: 0 }, { opacity: 1, duration: 0.5 });
                });
            }

            if (closeButton) {
                closeButton.addEventListener("click", function () {
                    gsap.to(".pop-out", { opacity: 0, duration: 0.5, onComplete: function() {
                        popOut.style.display = "none"; 
                    }});
                });
            }
        });
    </script>

    <div class="container py-4 d-flex">
        <!-- 左側列表 -->
        <div class="sidebar">
            <ul>
                <h1>⚔︎</h1>
                <li><a href="index.jsp">🏠 回首頁</a></li>
                <% if (user != null) { %>
                      <li><a href="my.jsp">👤 我的貼文</a></li>
                <% } else { %>
                    <li><a href="login.jsp">👤 登入 / 註冊</a></li>
                <% } %>
                <li>
                    <a class="pop-button ">➕ 新增貼文</a>
                </li>
                <% if (session.getAttribute("username") != null) { %>
                    <li><a href="logout.jsp" class="logout">🚪 登出</a></li>
                <% } %>

            </ul>
        </div>
    
        <!-- 右側留言牆 -->
        <div class="content">
            <h3>🧵 Threads 留言牆</h3>
    
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
    </div>
    
</body>
</html>
