<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%@ page session="true" %>


<%
    // URL에서 company_id를 가져오기
    String companyId = request.getParameter("companyId");
	System.out.println("companyID: " + companyId);
	
    if (companyId == null || companyId.isEmpty()) {
        response.getWriter().println("<h1>올바른 회사 정보가 없습니다.</h1>");
        return;
    }
%>	

<%
    // 데이터베이스 연결 정보
   	String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 기업 정보를 저장할 변수
    String companyName = "";
    String address = "";
    String description = "";
    String mainPhoto = "";
    int rating = 0;
    String facilities = "";
    String reservation_notice = "";

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 회사 정보 가져오기
        String sql = "SELECT * FROM companies WHERE company_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, companyId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            companyName = rs.getString("company_name");
            address = rs.getString("address");
            description = rs.getString("summary");
            mainPhoto = rs.getString("image_path"); // DB에 저장된 이미지 경로
            rating = rs.getInt("rating");
            facilities = rs.getString("facilities");
            reservation_notice = rs.getString("reservation_notice");
            
        } else {
            response.getWriter().println("<h1>회사를 찾을 수 없습니다.</h1>");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("<h1>데이터베이스 오류</h1>");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>웨딩홀 페이지</title>
<link rel="stylesheet" type="text/css" href="companyClick.css">
<link rel="stylesheet" type="text/css" href="../Main-loadmap/index.css">
<style>
/* 활성화된 탭 스타일 */
.tab.active {
	background: #F9BBBB;
	font-weight: bold;
}
</style>
</head>
<body>
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

	<!-- 메뉴바 -->
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

	<!-- 첫 번째 화면 -->
	<div class="container">

		<div class="photos">
			<!-- 
			<div class="photo-main">사진 삽입란</div> 
			<div class="photo-side">사진더보기</div>
			-->
			
			<img src="<%= mainPhoto %>" alt="이미지" class="main-photo">
			
		</div>

		<div class="details-review-section">
			<div class="details">
				<h2><%= companyName %></h2>
			    <p><%= address %></p>
			    <p><%= description %></p>
				<!-- 버튼 컨테이너 -->
				<div class="like-share-buttons">
					<button class="chat-btn">채팅 하기</button>
					<img src="images/heart.png" alt="찜 버튼" class="heart-icon"> <img
						src="images/share.png" alt="공유 버튼" class="share-icon">
				</div>
			</div>
			<div class="reviews">
				<h3>평점: <%= rating %></h3>
				<p>1300건의 후기</p>
				
				<div class="review-box">
					<div class="review">“너무 좋아용”</div>
					<div class="review">“직원분들이 매우 친절해요”</div>
				</div>
				<button class="more-reviews">후기 더보기</button>
			</div>
		</div>
	</div>


	<div class="content">
		<!-- 왼쪽 섹션: 탭바와 상세 정보 -->
		<div class="left-section">
			<div class="tabs">
				<button class="tab active" data-target="#introduction">소개</button>
				<button class="tab" data-target="#facilities">시설/서비스</button>
				<button class="tab" data-target="#reviews">후기</button>
				<button class="tab" data-target="#notices">예약 공지</button>
			</div>
			<div id="introduction" class="content-area">
				<h3>소개</h3>
				<p><%= description %></p>
			</div>
			<div id="facilities" class="content-area">
				<h3>시설/서비스</h3>
				<p><%= facilities %></p>
			</div>
			<div id="reviews" class="content-area">
				<h3>후기</h3>
				<p>여기에 후기 내용이 들어갑니다.</p>
			</div>
			<div id="notices" class="content-area">
				<h3>예약 공지</h3>
				<p><%= reservation_notice %></p>
			</div>
		</div>

		<!-- 오른쪽 섹션: 지도, 가격 정보, 채팅 -->
		<div class="right-section">
			<div class="map-container">
				<img src="images/map-placeholder.png" alt="지도" class="map-image">
				<p>위치 평점: 9.3<br>도심에 위치</p>
			</div>
			<div class="price-info">
				<h4>최근 예약가</h4>
				<p>옵션: 식대/뷔페 포함</p>
				<p>거래가: 3000만 원</p>
				<p>거래 일시: 2025/03/03</p>
			</div>
			<button class="chat-btn2">채팅 하기</button>
		</div>
	</div>


	<script>
        // JavaScript를 JSP에 삽입
        document.addEventListener("DOMContentLoaded", () => {
            const tabs = document.querySelectorAll(".tab");

            tabs.forEach(tab => {
                tab.addEventListener("click", () => {
                    // 기존 활성화된 탭을 비활성화
                    tabs.forEach(t => t.classList.remove("active"));
                    tab.classList.add("active");

                    // 클릭한 탭의 대상 섹션으로 스크롤 이동
                    const targetId = tab.getAttribute("data-target");
                    const targetSection = document.querySelector(targetId);
                    if (targetSection) {
                        window.scrollTo({
                            top: targetSection.offsetTop - 100, // 고정된 메뉴바 높이를 고려하여 조정
                            behavior: "smooth",
                        });
                    }
                });
            });
        });
    </script>
</body>
</html>