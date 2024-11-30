<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 페이지</title>
    <link rel="stylesheet" href="login.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <img src="../images/weddingon-logo.png" alt="Wedding.on 로고" class="logo">
            <form action="login-check.jsp"> <!-- 추가하슈 -->

                <input type="text" name="id" placeholder="아이디" class="input-field" required>
                <input type="password" name="password" placeholder="비밀번호" class="input-field" required>
                <button type="submit" class="login-button">로그인</button>
                <div class="signup-link">
                    <a href="./join.jsp">회원가입</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>