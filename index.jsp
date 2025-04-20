<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.Cookie, java.util.*" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest, jakarta.servlet.http.HttpServletResponse" %>

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
            posts.add(new String[]{user, msg, img, "0"}); 
        }
    }
    %>

    <!-- 愛心邏輯 -->
    <%
    String action = request.getParameter("action");
    String likeIndexStr = request.getParameter("likeIndex");
    Cookie[] cookies = request.getCookies();

    if ("like".equals(action) && likeIndexStr != null && user != null) {
        int index = Integer.parseInt(likeIndexStr);
    
        if (index >= 0 && index < posts.size()) {
            String cookieName = "liked_post_" + index;
            boolean hasLiked = false;
    
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals(cookieName)) {
                        hasLiked = true;
                        break;
                    }
                }
            }
    
            String[] p = posts.get(index);
            int likeCount = (p.length > 3) ? Integer.parseInt(p[3]) : 0;
    
            if (hasLiked) {
                if (likeCount > 0) likeCount--;
                Cookie unlikeCookie = new Cookie(cookieName, "");
                unlikeCookie.setMaxAge(0); 
                response.addCookie(unlikeCookie);
            } else {
                likeCount++;
                Cookie likeCookie = new Cookie(cookieName, "true");
                likeCookie.setMaxAge(60 * 60 * 24);
                response.addCookie(likeCookie);
            }
    
            String[] updated = Arrays.copyOf(p, 4);
            updated[3] = String.valueOf(likeCount);
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
    <title>首頁</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type ="text/css" href="css/style.css">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
</head>

<body class="bg-light">
       <!-- 彈跳視窗 -->
       <div id="newPostModal" class="pop-out" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center;">
            <div class="pop-out-panel" style="background: white; width: 300px; padding: 20px; border-radius: 10px; text-align: center;">
                <h1>⚔︎</h1>
                <h5>新增貼文</h5>
                <% if (user != null) { %>
                    <form method="post" class="mb-4">
                        <textarea name="message" class="form-control mb-2" placeholder="輸入貼文內容..." required></textarea>
                        <input name="image" class="form-control mb-2" placeholder="圖片網址 (可選)">
                        <button type="submit" class="btn btn-success">發佈</button>
                        <button type="button" class="close-button btn btn-secondary">取消</button>
                    </form>
                <% } else { %>
                    <div class="alert alert-warning">登入後可貼文貼文</div>
                    <div class="button-group">
                        <a href="login.jsp" class="action-button"  >👤 登入 / 註冊</a>
                        <button type="button" class="action-button close-button"  >取消</button>
                    </div>
                <% } %>
            </div>
        </div>

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
                <li><a href="search.jsp">🔍 搜尋</a></li>
                <li>
                    <a class="pop-button" data-target="#newPostModal">➕ 新增貼文</a>
                </li>
                <li><a href="messege.jsp">💬 訊息</a></li>
                <li><a href="notify.jsp">❤️ 通知</a></li>
                <% if (user != null) { %>
                    <li><a href="logout.jsp" class="logout">🚪 登出</a></li>
                <% } %>
            </ul>
        </div>
    
        <!-- 右側留言牆 -->
        <div class="content ">
            <h3>🧵 首頁</h3>
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
                    <img src="<%= postAvatar %>"
                    class="me-3"
                    style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover; aspect-ratio: 1 / 1;">
                    <strong>@<%= postUser %></strong>
                </div>
                <p><%= post[1] %></p>
                <% if (post[2] != null && !post[2].isEmpty()) { %>
                    <img src="<%= post[2] %>" class="img-fluid rounded" style="max-width:300px">
                <% } %>

                   <!--按鈕區 -->
                    <div class="mt-2 d-flex align-items-center"> 
                        <% if (user != null) { %>
                            <input type="hidden" name="likeIndex" value="<%= i %>">
                            <button type="button" class="btn btn-outline-danger btn-sm" onclick="likePost('<%= i %>')">❤️</button>&nbsp;&nbsp;
                        <% } else { %>
                            <button type="submit" name="action" value="like"  class="pop-button btn btn-outline-danger btn-sm ">❤️</button>&nbsp;&nbsp;
                           
                            <div class="pop-out" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center;">
                                <div class="pop-out-panel" style="background: white; width: 300px; padding: 20px; border-radius: 10px; text-align: center;">
                                    <h1>⚔︎</h1>
                                    <h5>註冊即可按讚</h5>
                                     <div class="alert alert-warning">加入即可對貼文按讚並互動</div>
                                    <div class="button-group">
                                        <a href="login.jsp" class="action-button "  >👤 登入 / 註冊</a>
                                        <button type="button" class="action-button close-button"  >取消</button>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        <span id="like-count-<%= i %>"><%= post.length > 3 ? post[3] : "0" %> 人喜歡</span>&nbsp;&nbsp;</span>

                        <% if (user != null) { %>
                            <button type="button" id="comment-button-<%= i %>" class="btn btn-outline-secondary btn-sm me-2" onclick="toggleComment('<%= i %>')">💬 留言</button>
                        <% } else { %>
                            <button type="button"  class="pop-button btn btn-outline-secondary btn-sm " >💬 留言</button>
                            <div class="pop-out" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center;">
                                <div class="pop-out-panel" style="background: white; width: 300px; padding: 20px; border-radius: 10px; text-align: center;">
                                    <h1>⚔︎</h1>
                                    <h5>註冊即可回覆</h5>
                                    <div class="alert alert-warning">加入即可參與對話。</div>
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
    // 彈窗
    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".pop-button").forEach(function(button) {
            button.addEventListener("click", function () {
                let popOut;
                const targetSelector = button.getAttribute("data-target");
                if (targetSelector) {
                    popOut = document.querySelector(targetSelector);
                } else {
                    popOut = button.nextElementSibling;
                }

                if (popOut && popOut.classList.contains("pop-out")) {
                    popOut.style.display = "flex";
                    gsap.fromTo(popOut, { opacity: 0 }, { opacity: 1, duration: 0.5 });
                }
            });
        });

    // 關閉彈窗
        document.querySelectorAll(".close-button").forEach(function(button) {
            button.addEventListener("click", function () {
                const popOut = button.closest(".pop-out");
                if (popOut) {
                    gsap.to(popOut, {
                        opacity: 0,
                        duration: 0.5,
                        onComplete: function () {
                            popOut.style.display = "none";
                        }
                    });
                }
            });
        });
    });
   
    // 留言
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

    // 喜歡
    function likePost(index) {
    const countSpan = document.getElementById("like-count-" + index);
    const likeBtn = event.target;

    fetch("index.jsp", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "action=like&likeIndex=" + index
    })
    .then(response => response.text())
    .then(() => {
        let currentLikes = parseInt(countSpan.textContent) || 0;
        if (likeBtn.classList.contains("liked")) {
            likeBtn.classList.remove("liked");
            likeBtn.classList.remove("btn-danger");
            likeBtn.classList.add("btn-outline-danger");
            countSpan.textContent = (currentLikes - 1) + " 人喜歡";
        } else {
            likeBtn.classList.add("liked");
            likeBtn.classList.remove("btn-outline-danger");
            likeBtn.classList.add("btn-danger");
            countSpan.textContent = (currentLikes + 1) + " 人喜歡";
        }
    })
    .catch(error => console.error("Error:", error));
}


</script>
    