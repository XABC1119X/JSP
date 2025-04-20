<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.Cookie, java.util.*" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest, jakarta.servlet.http.HttpServletResponse" %>

<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String usertext = (String) application.getAttribute("usertext_" + user);
    if (usertext == null) usertext = "";

    String avatarUrl = (String) application.getAttribute("avatar_" + user);
    if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
        avatarUrl = "img/avatar.png";
    }

    String gender = (String) application.getAttribute("gender_" + user);
    if (gender == null) gender = "男性";

    // 接收與儲存
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newText = request.getParameter("usertext");
        String newAvatarUrl = request.getParameter("avatarUrl");
        String newGender = request.getParameter("gender");

        if (newText != null) application.setAttribute("usertext_" + user, newText);
        if (newAvatarUrl != null && !newAvatarUrl.trim().isEmpty())
            application.setAttribute("avatar_" + user, newAvatarUrl.trim());
        if (newGender != null) application.setAttribute("gender_" + user, newGender);

        // 更新當前顯示
        usertext = newText;
        avatarUrl = newAvatarUrl;
        gender = newGender;

        request.setAttribute("saved", true);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>編輯個人檔案</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type ="text/css" href="css/style.css">
</head>

<body class="bg-light">
    <div class="container py-4">
        <!-- 左側選單 -->
        <div class="sidebar">
           <ul>
               <h1>⚔︎</h1>
               <li><a href="my.jsp">🏠 回個人檔案</a></li>
               <li><a href="logout.jsp" class="logout">🚪 登出</a></li>
           </ul>
       </div>

        <!-- 編輯區 -->
        <div class="flex-grow-1 mx-auto" style="max-width: 700px;">
            <h5 class="text-center">👤 編輯個人檔案</h5>
        <div class="card shadow-sm p-4 rounded-4">
            <% if (request.getAttribute("saved") != null) { %>
                <div class="alert alert-success">✅ 資料已儲存成功！</div>
            <% } %>
            <form method="post">
                <!-- 頭像 -->
                <div class="d-flex align-items-center mb-3 p-3 bg-white rounded shadow-sm">
                    <img id="avatarPreview" src="<%= avatarUrl %>" class="rounded-circle me-3" width="60" height="60">
                    <div>
                        <strong><%= user %></strong><br>
                        <input type="text" name="avatarUrl" class="form-control mt-1" placeholder="貼上圖片網址"
                               value="<%= avatarUrl.equals("img/avatar.png") ? "" : avatarUrl %>">
                        <small class="text-muted">變更照片（請使用圖片網址）</small>
                    </div>
                </div>

                <!-- 網站 -->
                <div class="mb-3">
                    <label class="form-label fw-bold">網站</label>
                    <input type="url" class="form-control" placeholder="連結" disabled>
                    <small class="text-muted">你只能在行動裝置編輯網站連結。</small>
                </div>

                <!-- 個人簡介 -->
                <div class="mb-3">
                    <label for="usertext" class="form-label fw-bold">個人簡介</label>
                    <textarea class="form-control" id="usertext" name="usertext" rows="5" maxlength="150"><%= usertext %></textarea>
                    <div class="text-end text-muted small mt-1" id="char-count">0 / 150</div>
                </div>

                <!-- 性別 -->
                <div class="mb-3">
                    <label class="form-label fw-bold">性別</label>
                    <select class="form-select" name="gender">
                        <option <%= "男性".equals(gender) ? "selected" : "" %>>男性</option>
                        <option <%= "女性".equals(gender) ? "selected" : "" %>>女性</option>
                        <option <%= "其他".equals(gender) ? "selected" : "" %>>其他</option>
                    </select>
                    <small class="text-muted">這不會顯示在你的公開個人檔案中。</small>
                </div>

                <!-- 儲存按鈕 -->
                <button type="submit" class="btn btn-dark">儲存</button>
                <a href="my.jsp" class="btn btn-outline-secondary">取消</a>
            </form>
        </div>
    </div>
</div>

<script>
    function updateCount() {
        const textarea = document.getElementById("usertext");
        const counter = document.getElementById("char-count");
        if (textarea && counter) {
            counter.textContent = textarea.value.length + " / 150";
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        updateCount();

        const avatarInput = document.querySelector("input[name='avatarUrl']");
        const avatarImg = document.getElementById("avatarPreview");
        if (avatarInput && avatarImg) {
            avatarInput.addEventListener("input", function () {
                avatarImg.src = avatarInput.value || "img/avatar.png";
            });
        }
    });
</script>
</body>
</html>
