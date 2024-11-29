<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.temporal.ChronoUnit"%>

<%@ page session="true"%>


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
		<a href="index.jsp"> <img class="logo"
			src="../images/weddingon-logo.png" alt="로고">
		</a> <a href="../Mypage/mypage.jsp"> <img class="mypage"
			src="../images/mypage-icon.png" alt="마이페이지 아이콘">
		</a>
	</div>

	<!-- 메뉴바 -->
	<div class="menu_bar">
		<div class="menu_item" data-page="community.html">
			<img class="menu_icon" src="../images/community-icon.png"
				alt="커뮤니티 아이콘"> <span>커뮤니티</span>
		</div>
		<div class="menu_item" data-page="../MenuClick/hall.jsp">
			<img class="menu_icon" src="../images/weddinghall-icon.png"
				alt="식장 아이콘"> <span>식장</span>
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
			<img src="<%= mainPhoto %>" alt="이미지" class="main-photo">
		</div>
		<div class="container2">
			<div class="left-section">
				<div class="details">
					<h2 id="wedding-hall-name"><%= companyName %></h2>
					<hr class="section-divider">
					<p id="address"><%= address %></p>
					<p id="description"><%= description %></p>
					<div class="basic-info">
						<p>
							<strong>홀 타입:</strong> <span id="hall-type">일반홀, 하우스</span>
						</p>
						<p>
							<strong>메뉴 유형:</strong> <span id="menu-type">뷔페</span>
						</p>
						<p>
							<strong>대관료:</strong> <span id="rental-fee">3000만원</span>
						</p>
						<p>
							<strong>식사 비용:</strong> <span id="meal-cost">77,000원</span>
						</p>
						<p>
							<strong>보증 인원:</strong> <span id="capacity">최소 200명, 최대
								420명</span>
						</p>
						<p>
							<strong>가능 행사:</strong> <span id="events">웨딩</span>
						</p>
					</div>
				</div>
			</div>

			<div class="right-section">
				<div class="action-buttons">
					<button class="chat-btn">채팅 하기</button>
					<div class="heart-icon">
						<!-- heart-icon 클래스를 추가 -->
						<img src="../images/heart.png" alt="찜 버튼" />
					</div>
					<img src="../images/share.png" alt="공유 버튼" class="share-icon" />
				</div>
				<div class="map-container">
					<img src="../images/map-placeholder.png" alt="지도" class="map-image" />
					<p>
						위치 평점: <span id="location-rating">9.3</span><br /> <span
							id="location-description">도심에 위치</span>
					</p>
				</div>
				<div class="reviews">
					<h3>
						<span id="overall-rating">5.0</span> 최우수 <span id="review-count">(1300건의
							후기)</span>
					</h3>
					<div class="review-box">
						<div class="review" id="review-1">“너무 좋아용”</div>
						<div class="review" id="review-2">“직원분들이 매우 친절해요”</div>
					</div>
					<button class="more-reviews" id="moreReviewsButton">후기 더보기</button>
				</div>
			</div>
		</div>


		<!-- 하단 컨텐츠 -->
		<div class="main-content">
			<div class="tabs">
				<button class="tab active" data-target="#introduction">소개</button>
				<button class="tab" data-target="#facilities">시설/서비스</button>
				<button class="tab" data-target="#reviews">후기</button>
				<button class="tab" data-target="#notices">예약 공지</button>
			</div>
			<div id="introduction" class="content-area">
				<h3>소개</h3>
				<%= description %>
			</div>
			<div id="facilities" class="content-area">
				<h3>시설/서비스</h3>
				<div class="facility-item">
					<img src="../images/check.png" alt="체크 아이콘" class="facility-icon">
					<p><%= facilities %></p>
				</div>
				<div class="facility-item">
					<img src="../images/check.png" alt="체크 아이콘" class="facility-icon">
					<p>또 다른 시설/서비스 내용이 들어갑니다.</p>
				</div>
			</div>
			<div id="reviews" class="content-area">
				<div class="overall-rating">
					<h3>전체 평점</h3>
					<p class="rating-score">
						<span>4.3</span> <span>리뷰 300개</span>
					</p>
					<div class="stars">★★★★☆</div>
				</div>
				<div class="detailed-ratings">
					<h4>항목별 평점</h4>
					<div class="rating-bars">
						<div class="rating-bar">
							<span>교통:</span>
							<div class="bar">
								<div class="filled-bar" style="width: 80%;"></div>
							</div>
							<span>4.0</span>
						</div>
						<div class="rating-bar">
							<span>주차:</span>
							<div class="bar">
								<div class="filled-bar" style="width: 70%;"></div>
							</div>
							<span>3.5</span>
						</div>
						<div class="rating-bar">
							<span>분위기:</span>
							<div class="bar">
								<div class="filled-bar" style="width: 90%;"></div>
							</div>
							<span>4.5</span>
						</div>
						<div class="rating-bar">
							<span>가격:</span>
							<div class="bar">
								<div class="filled-bar" style="width: 60%;"></div>
							</div>
							<span>3.0</span>
						</div>
						<div class="rating-bar">
							<span>위치:</span>
							<div class="bar">
								<div class="filled-bar" style="width: 95%;"></div>
							</div>
							<span>4.8</span>
						</div>
					</div>
				</div>
				<div class="review-write">
					<h4>리뷰 작성</h4>
					<form id="reviewForm">
						<div class="rating-input">
							<label>교통:</label> <input type="number" name="traffic" min="1"
								max="5" required> <label>주차:</label> <input
								type="number" name="parking" min="1" max="5" required> <label>분위기:</label>
							<input type="number" name="ambiance" min="1" max="5" required>
							<label>가격:</label> <input type="number" name="price" min="1"
								max="5" required> <label>위치:</label> <input
								type="number" name="location" min="1" max="5" required>
						</div>
						<textarea name="reviewText" placeholder="후기를 입력해주세요" required></textarea>
						<button type="submit">리뷰 등록</button>
					</form>
					<div id="submitted-reviews">
						<h4>작성된 리뷰</h4>
						<!-- 여기에 새로운 리뷰가 추가됩니다 -->
					</div>
				</div>
			</div>
			<div id="notices" class="content-area">
				<h3>예약 공지</h3>
				<p><%= reservation_notice %></p>
			</div>
		</div>
	</div>

	<!-- 하단바 -->
	<div class="bottom-bar">
		<div class="heart-icon">
			<!-- heart-icon 클래스를 추가 -->
			<img src="../images/heart.png" alt="찜 버튼" />
		</div>
		<div class="chat-btn">채팅하기</div>
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

        document.querySelector('.tab').click();
    
    // 리뷰 폼 제출 이벤트
    document.getElementById('reviewForm').addEventListener('submit', function(event) {
        event.preventDefault(); // 기본 폼 제출 방지

        // 폼 데이터 가져오기
        const traffic = document.querySelector('input[name="traffic"]').value;
        const parking = document.querySelector('input[name="parking"]').value;
        const ambiance = document.querySelector('input[name="ambiance"]').value;
        const price = document.querySelector('input[name="price"]').value;
        const location = document.querySelector('input[name="location"]').value;
        const reviewText = document.querySelector('textarea[name="reviewText"]').value;
     
        // 새로운 리뷰 요소 생성
        const reviewContainer = document.createElement('div');
        reviewContainer.className = 'submitted-review';
        reviewContainer.innerHTML = `
            <p><strong>교통:</strong> ${traffic}, <strong>주차:</strong> ${parking}, 
            <strong>분위기:</strong> ${ambiance}, <strong>가격:</strong> ${price}, 
            <strong>위치:</strong> ${location}</p>
            <p>${reviewText}</p>
            <hr>
        `;

        // 작성된 리뷰 추가
        document.getElementById('submitted-reviews').appendChild(reviewContainer);

        // 폼 초기화
        event.target.reset();
    });
    
 // 두 하트를 동기화하여 함께 작동하도록 설정
    document.querySelectorAll('.heart-icon img').forEach(icon => {
        icon.addEventListener('click', () => {
            const allIcons = document.querySelectorAll('.heart-icon img'); // 모든 하트 아이콘 가져오기
            const isFilled = icon.getAttribute('src') === '../images/fullheart.png';
            const newSrc = isFilled ? '../images/heart.png' : '../images/fullheart.png';

            // 모든 하트 아이콘의 src를 동기화
            allIcons.forEach(icon => {
                icon.setAttribute('src', newSrc);
            });
        });
    });

 // 후기 더보기 버튼 클릭 시 "후기" 탭으로 이동
    document.getElementById("moreReviewsButton").addEventListener("click", () => {
        // 모든 탭의 활성화 클래스 제거
        document.querySelectorAll(".tab").forEach(tab => tab.classList.remove("active"));
        document.querySelectorAll(".content-area").forEach(content => content.classList.remove("active"));

        // "후기" 탭 활성화
        const reviewTab = document.querySelector(".tab[data-target='#reviews']");
        const reviewContent = document.getElementById("reviews");
        reviewTab.classList.add("active");
        reviewContent.classList.add("active");

        // "후기" 섹션으로 스크롤 이동
        reviewContent.scrollIntoView({ behavior: "smooth" });
    });
</script>
    
</body>
</html>
