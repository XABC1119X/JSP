<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.Cookie, java.util.*" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest, jakarta.servlet.http.HttpServletResponse" %>

<%
    String user = (String) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ServletContext ctx = getServletContext();
    List<String[]> posts = (List<String[]>) ctx.getAttribute("posts");
    if (posts == null) posts = new ArrayList<>();
%>
<%
String avatarUrl = (String) application.getAttribute("avatar_" + user);
if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
    avatarUrl = "img/avatar.png";
}

String usertext = (String) application.getAttribute("usertext_" + user);
if (usertext == null || usertext.trim().isEmpty()) {
    usertext = "這人很懶沒留下任何訊息";
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= user %> 的個人檔案</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type ="text/css" href="css/style.css">
</head>
<body class="bg-light">
<div class="container py-4" >
     <!-- 左側列表 -->
     <div class="sidebar">
        <ul>
            <h1>⚔︎</h1>
            <li><a href="index.jsp">🏠 回首頁</a></li>
            <li><a href="logout.jsp" class="logout">🚪 登出</a></li>
        </ul>
    </div>

     <!-- 右側留言牆 -->
     <div class="flex-grow-1 mx-auto" style="max-width: 700px;">
        <h6 class="text-center">個人檔案</h6>
        <!-- 個人資料卡 -->
        <div class="card shadow-sm p-4 rounded-4">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="fw-bold"><%= user %></h4>
                    <p class="text-muted">@<%= user %></p>
                    <p><%= usertext %></p>
                    <small class="text-muted">0 位粉絲</small>
                </div>
                <img id="avatarPreview"
                src="<%= avatarUrl %>"
                class="me-3"
                style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; aspect-ratio: 1 / 1;">

            </div>
            <div class="mt-3 text-center">
                <a href="editusertext.jsp" class="btn btn-outline-dark w-100 rounded-pill">編輯個人檔案</a>
            </div>
            <div class="d-flex justify-content-center gap-4 mt-4 border-bottom pb-2">
                <span class="fw-bold border-bottom border-dark pb-1">串文</span>
                <span class="text-muted">回覆</span>
                <span class="text-muted">轉發</span>
            </div>
        </div>

        <!-- Threads 貼文 -->
        <div class="mt-4" >
            <% for (int i = posts.size() - 1; i >= 0; i--) {
                String[] post = posts.get(i);
            
                String postUser = post[0];
                String postAvatar = (String) application.getAttribute("avatar_" + postUser);
                if (postAvatar == null || postAvatar.trim().isEmpty()) {
                    postAvatar = "img/avatar.png";
                }
            %>
            <div class="card mb-3 p-3">
                <div class="d-flex align-items-center mb-2">
                    <img src="<%= postAvatar %>" class="rounded-circle me-2" width="40" height="40">
                    <strong>@<%= postUser %></strong>
                </div>
                <p><%= post[1] %></p>
                <% if (post[2] != null && !post[2].isEmpty()) { %>
                    <img src="<%= post[2] %>" class="img-fluid rounded" style="max-width:300px">
                <% } %>
                <div class="mt-2 d-flex align-items-center gap-2">
                    <span style="cursor:pointer; color: red;">❤️</span>
                    <span id="like-count-<%= i %>"><%= post.length > 3 ? post[3] : "0" %> 人喜歡</span>
                    💬 <span class="text-dark fw-bold">留言</span>
                </div>

                <div class="comment-section mt-2 ps-2">
                    <%
                        for (int j = 4; j < post.length; j++) {
                    %>
                        <div class="comment-item d-flex align-items-start gap-1 mb-1">
                            <span class="text-muted">💬</span>
                            <div class="text-muted small"><%= post[j] %></div>
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>
        <% } %>
        </div>
    </div>
</div>
</div>
</div>
</body>
</html>

<script>
    function toggleComment(index) {
    const el = document.getElementById("comment-form-" + index);
    const btn = document.getElementById("comment-button-" + index);

    if (el.style.display === "none" || el.style.display === "") {
        el.style.display = "block";
        btn.classList.remove("btn-outline-secondary");
        btn.classList.add("btn-dark");
    } else {
        el.style.display = "none";
        btn.classList.remove("btn-dark");
        btn.classList.add("btn-outline-secondary");
    }
}
</script>