<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // 清除所有 session 資料
    response.sendRedirect("login.jsp"); // 導向登入頁
%>