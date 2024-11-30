<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 페이지</title>
    <link rel="stylesheet" href="join.css">
</head>
<body>
    <div class="join-container">
        <div class="join-box">
            <img src="../images/weddingon-logo.png" alt="Wedding.on 로고" class="logo">
            <form action="signup-db.jsp" method="post" onsubmit="return validateForm();">
                <div class="input-group">
                    <label for="name">이름</label>
                    <input type="text" id="name" name="name" class="input-field" required>
                </div>

                <div class="input-group">
                    <label for="username">아이디</label>
                    <input type="text" id="username" name="username" class="input-field-id" required>
                    <button type="button" onclick="checkDuplicate()" class="check-button">중복확인</button>
                </div>

                <div class="input-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" class="input-field" required>
                </div>

                <div class="input-group">
                    <label for="confirm-password">비밀번호 확인</label>
                    <input type="password" id="confirm-password" name="confirmPassword" class="input-field" required>
                </div>

                <div class="input-group">
                    <label for="phone">전화번호</label>
                    <input type="tel" id="phone" name="phone" class="input-field" required>
                </div>

                <div class="input-group">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" class="input-field" required>
                </div>

                <div class="input-group">
                    <label for="birthdate">생년월일</label>
                    <input type="date" id="birthdate" name="birthdate" class="input-field" required>
                </div>

                <div class="input-group">
                    <label for="wedding-date">결혼 예상 날짜</label>
                    <input type="date" id="wedding-date" name="weddingDate" class="input-field">
                </div>

                <button type="submit" class="join-button">회원가입하기</button>
            </form>
        </div>
    </div>

    <script>
        // 중복확인 버튼 로직
        function checkDuplicate() {
            const username = document.getElementById('username').value;
            if (username) {
                window.open(`checkDuplicate.jsp?username=${username}`, "중복확인", "width=400,height=200");
            } else {
                alert("아이디를 입력해주세요.");
            }
        }

        // 비밀번호 확인 로직
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirm-password').value;

            if (password !== confirmPassword) {
                alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                return false; // 폼 전송 중단
            }

            return true; // 폼 전송 허용
        }
    </script>
</body>
</html>