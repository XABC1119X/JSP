<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.Cookie, java.util.*" %>
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
String usertext = "這人很懶沒留下任何訊息";
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
       <br>
       <h5> <%= usertext %></h5>

       <% for (int i = posts.size() - 1; i >= 0; i--) {
        String[] post = posts.get(i);
    %>
        <div class="card mb-3 p-3">
            <strong>@<%= post[0] %></strong><br>
            <p><%= post[1] %></p>
            <% if (post[2] != null && !post[2].isEmpty()) { %>
                <img src="<%= post[2] %>" class="img-fluid rounded" style="max-width:300px">
            <% } %>

            <div class="mt-2 d-flex align-items-center">            
                    <input type="hidden" name="likeIndex" value="<%= i %>">
                    <span style="cursor:pointer;  color: red;" onclick="document.getElementById('likeForm-<%= i %>').submit()">❤️</span>&nbsp;&nbsp;
                <span id="like-count-<%= i %>"><%= post.length > 3 ? post[3] : "0" %> 人喜歡</span>&nbsp;&nbsp;</span>
                💬 <span class="text-dark fw-bold">留言</span>
            </div>



          <!-- 留言 -->
          <div id="comment-form-<%= i %>" style="display: none;" class="mt-2">
            <form method="post">
                <input type="hidden" name="commentIndex" value="<%= i %>">
            </form>
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