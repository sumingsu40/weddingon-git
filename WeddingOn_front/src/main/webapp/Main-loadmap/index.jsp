<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        // 로그인되지 않은 상태 -> 로그인 페이지로 이동
        response.sendRedirect("../login/login.jsp");
        return;
    }
    else {
    	System.out.println("index userId: " + userId);
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
<link rel="stylesheet" type="text/css" href="index.css">
</head>
<body>

    <div class="top_bar">
        <form class="search_container" method="post">
            <input class="search_icon" type="text" name="company_name">
            <button type="submit" class="search_button">search</button>
        </form>
        <a href="index.jsp">
            <img class="logo" src="../images/weddingon-logo.png">
        </a>
        <a href="../Mypage/mypage.jsp">
            <img class="Mypage" src="../images/mypage-icon.png" alt="마이페이지">
        </a>
    </div>

    <div class="menu_bar">
        <div class="box">
			<img id="menu-icon" src="../images/community-icon.png" alt="커뮤니티 아이콘">
            <span style="margin-bottom: 5px;">커뮤니티</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="../images/weddinghall-icon.png" alt="커뮤니티 아이콘">
            <span style="margin-bottom: 5px;">식장</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="../images/studio-icon.png" alt="커뮤니티 아이콘">
            <span style="margin-bottom: 5px;">스튜디오</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="../images/makeup-icon.png" alt="커뮤니티 아이콘">
            <span style="margin-bottom: 5px;">메이크업</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="../images/dress-icon.png" alt="커뮤니티 아이콘">
            <span style="margin-bottom: 5px;">드레스</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="../images/letter-icon.png" alt="커뮤니티 아이콘">
            <span style="margin-bottom: 5px;">청첩장</span>
        </div>
    </div>
    <div class="loadmap">
        <h2>당신의 특별한 날을 위한 여정이 시작됩니다!</h2>
        <img src="../images/loadmap.png">
    </div>
</body>
</html>
