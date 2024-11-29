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
<style>
    body {
        margin: 0;
        padding: 0;
    }

    .iframe_container {
        width: 100%;
        height: calc(100vh - 156px); /* 상단바와 메뉴바 높이를 제외한 화면 */
        margin-top: 147px; /* 상단바 + 메뉴바 높이 */
    }

    iframe {
        width: 100%;
        height: 100%;
        border: none;
    }
</style>
</head>
<body>

	<!-- 상단 바 -->
	<div class="top_bar">
		<form class="search_container" method="post">
			<input class="search_icon" type="text" name="company_name">
			<button type="submit" class="search_button">search</button>
		</form>
		<a href="index.jsp">
			<img class="logo" src="../images/weddingon-logo.png" alt="로고">
		</a>
		<a href="../Mypage/mypage.jsp">
			<img class="mypage" src="../images/mypage-icon.png" alt="마이페이지 아이콘">
		</a>
	</div>

	<!-- 메뉴 바 -->
	<div class="menu_bar">
		<div class="menu_item" data-page="community.html">
			<img class="menu_icon" src="../images/community-icon.png" alt="커뮤니티 아이콘">
			<span>커뮤니티</span>
		</div>
		<div class="menu_item" data-page="../MenuClick/hall.jsp">
			<img class="menu_icon" src="../images/weddinghall-icon.png" alt="식장 아이콘">
			<span>식장</span>
		</div>
		<div class="menu_item" data-page="../MenuClick/studio.jsp">
			<img class="menu_icon" src="../images/studio-icon.png" alt="스튜디오 아이콘">
			<span>스튜디오</span>
		</div>
		<div class="menu_item" data-page="../MenuClick/makeup.jsp">
			<img class="menu_icon" src="../images/makeup-icon.png" alt="메이크업 아이콘">
			<span>메이크업</span>
		</div>
		<div class="menu_item" data-page="../MenuClick/dress.jsp">
			<img class="menu_icon" src="../images/dress-icon.png" alt="드레스 아이콘">
			<span>드레스</span>
		</div>
		<div class="menu_item" data-page="../MenuClick/invitationLetter.jsp">
			<img class="menu_icon" src="../images/letter-icon.png" alt="청첩장 아이콘">
			<span>청첩장</span>
		</div>
	</div>

	<!-- Iframe 영역 -->
	<div class="iframe_container">
		<iframe id="contentFrame" src="loadmap.jsp"></iframe>
	</div>

	<script>
		// 모든 메뉴 항목과 로고를 선택
		const menuItems = document.querySelectorAll('.menu_item');
		const iframe = document.getElementById('contentFrame');
		const logo = document.querySelector('.logo');

		// 각 메뉴에 클릭 이벤트 추가
		menuItems.forEach(item => {
		    item.addEventListener('click', () => {
		        // 모든 메뉴에서 active 클래스 제거
		        menuItems.forEach(i => i.classList.remove('active'));

		        // 클릭된 메뉴에 active 클래스 추가
		        item.classList.add('active');

		        // 클릭된 메뉴의 data-page 속성으로 iframe src 변경
		        const page = item.getAttribute('data-page');
		        iframe.src = page;
		    });
		});

		// 로고 클릭 시 iframe을 로드맵 페이지로 변경
		logo.addEventListener('click', () => {
		    iframe.src = 'loadmap.jsp';

		    // 모든 메뉴에서 active 클래스 제거
		    menuItems.forEach(i => i.classList.remove('active'));
		});
	</script>
</body>
</html>
