<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.Cookie, java.util.*" %>
<%
    String user = (String) session.getAttribute("user");

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

 <!-- 愛心邏輯 -->
<%
    String action = request.getParameter("action");
    String likeIndexStr = request.getParameter("likeIndex");

    if ("like".equals(action) && likeIndexStr != null) {
        int index = Integer.parseInt(likeIndexStr);
        if (index >= 0 && index < posts.size()) {
            String[] p = posts.get(index);
            int likeCount = 0;

            if (p.length > 3) {
                likeCount = Integer.parseInt(p[3]);
            }

            likeCount++; // 每點一次加 1

            String[] updated;
            if (p.length > 3) {
                updated = Arrays.copyOf(p, p.length);
                updated[3] = String.valueOf(likeCount); 
            } else {
                updated = Arrays.copyOf(p, 4); 
                updated[3] = String.valueOf(likeCount); 
            }

            posts.set(index, updated);


        }
    }
%>
 <!-- 留言邏輯 -->
<%
    if ("comment".equals(action)) {
        String commentIndexStr = request.getParameter("commentIndex");
        String commentText = request.getParameter("comment");

        if (commentIndexStr != null && commentText != null && !commentText.trim().isEmpty()) {
            int index = Integer.parseInt(commentIndexStr);
            if (index >= 0 && index < posts.size()) {
                String[] p = posts.get(index);

                String commentFull = "@" + user + ": " + commentText;

                String[] updated = Arrays.copyOf(p, p.length + 1);
                updated[updated.length - 1] = commentFull;

                posts.set(index, updated); 
            }
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
                <% if (user != null) { %>
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

                   <!--按鈕區 -->
                    <div class="mt-2">
                        <% if (user != null) { %>
                            <form method="post" style="display:inline;">
                            <input type="hidden" name="likeIndex" value="<%= i %>">
                            <button type="submit" name="action" value="like" class="btn btn-outline-danger btn-sm">❤️</button>
                            <span><%= post.length > 3 ? post[3] : "0" %> 人喜歡</span>
                            </form>
                        <% } else { %>
                            <div class="pop-out" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center;">
                                <div class="pop-out-panel" style="background: white; width: 300px; padding: 20px; border-radius: 10px; text-align: center;">
                                    <div class="alert alert-warning">登入後可留言</div>
                                    <div class="button-group">
                                        <a href="login.jsp" class="action-button"  >👤 登入 / 註冊</a>
                                        <button type="button" class="action-button close-button"  >取消</button>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        
                        <% if (user != null) { %>
                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="toggleComment('<%= i %>')">💬 留言</button>
                        <% } else { %>
                            <div class="pop-out" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center;">
                                <div class="pop-out-panel" style="background: white; width: 300px; padding: 20px; border-radius: 10px; text-align: center;">
                                    <div class="alert alert-warning">登入後可留言</div>
                                    <div class="button-group">
                                        <a href="login.jsp" class="action-button"  >👤 登入 / 註冊</a>
                                        <button type="button" class="action-button close-button"  >取消</button>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                       
                    </div>

                    <!-- 留言 -->
                    <div id="comment-form-<%= i %>" style="display: none;" class="mt-2">
                        <form method="post">
                            <input type="hidden" name="commentIndex" value="<%= i %>">
                            <input type="text" name="comment" class="form-control form-control-sm mb-1" placeholder="留言..." required>
                            <button type="submit" name="action" value="comment" class="btn btn-sm btn-secondary">送出</button>
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
        if (el.style.display === "none") {
            el.style.display = "block";
        } else {
            el.style.display = "none";
        }
    }
    </script>
    