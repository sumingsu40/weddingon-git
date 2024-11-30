<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.time.*"%>
<%@ page import="java.time.temporal.ChronoUnit"%>
<%@ page import="java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>
<%@ page import="java.math.BigDecimal" %>


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

    // 기업 정보를 저장할 변수
    String companyName = "";
    String address = "";
    String description = "";
    String mainPhoto = "";
    int rating = 0;
    String facilities = "";
    String reservation_notice = "";

    // 리뷰 데이터를 저장할 변수
    List<Map<String, Object>> reviews = new ArrayList<>();
    double overallRatingAvg = 0.0;
    int totalReviewCount = 0;

    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
        // 회사 정보 가져오기
        String sqlCompany = "SELECT * FROM companies WHERE company_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sqlCompany)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    companyName = rs.getString("company_name");
                    address = rs.getString("address");
                    description = rs.getString("summary");
                    mainPhoto = rs.getString("image_path");
                    rating = rs.getInt("rating");
                    facilities = rs.getString("facilities");
                    reservation_notice = rs.getString("reservation_notice");
                } else {
                    response.getWriter().println("<h1>회사를 찾을 수 없습니다.</h1>");
                    return;
                }
            }
        }

        // 리뷰 가져오기
        String sqlReviews = "SELECT * FROM reviews WHERE company_id = ? ORDER BY created_at DESC";
        try (PreparedStatement pstmt = conn.prepareStatement(sqlReviews)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> review = new HashMap<>();
                    review.put("review_id", rs.getInt("review_id"));
                    review.put("user_id", rs.getInt("user_id"));
                    review.put("overall_rating", rs.getBigDecimal("overall_rating"));
                    review.put("traffic_rating", rs.getBigDecimal("traffic_rating"));
                    review.put("parking_rating", rs.getBigDecimal("parking_rating"));
                    review.put("atmosphere_rating", rs.getBigDecimal("atmosphere_rating"));
                    review.put("price_rating", rs.getBigDecimal("price_rating"));
                    review.put("location_rating", rs.getBigDecimal("location_rating"));
                    review.put("review_text", rs.getString("review_text"));
                    review.put("created_at", rs.getTimestamp("created_at"));

                    reviews.add(review);
                }
            }
        }

        // 전체 평점 평균 및 리뷰 개수 가져오기
        String sqlOverallRating = "SELECT AVG(overall_rating) AS avg_rating, COUNT(*) AS review_count FROM reviews WHERE company_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sqlOverallRating)) {
            pstmt.setString(1, companyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    overallRatingAvg = rs.getDouble("avg_rating");
                    totalReviewCount = rs.getInt("review_count");
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("<h1>데이터베이스 오류</h1>");
    }
%>

<% 
    // 각 평점의 평균을 계산
    double trafficRatingAvg = 0.0;
    double parkingRatingAvg = 0.0;
    double atmosphereRatingAvg = 0.0;
    double priceRatingAvg = 0.0;
    double locationRatingAvg = 0.0;
    int totalReviews = reviews.size();

    if (totalReviews > 0) {
        for (Map<String, Object> review : reviews) {
            if (review.get("traffic_rating") instanceof BigDecimal) {
                trafficRatingAvg += ((BigDecimal) review.get("traffic_rating")).doubleValue();
            } else if (review.get("traffic_rating") instanceof Double) {
                trafficRatingAvg += (Double) review.get("traffic_rating");
            }
            if (review.get("parking_rating") instanceof BigDecimal) {
                parkingRatingAvg += ((BigDecimal) review.get("parking_rating")).doubleValue();
            } else if (review.get("parking_rating") instanceof Double) {
                parkingRatingAvg += (Double) review.get("parking_rating");
            }
            if (review.get("atmosphere_rating") instanceof BigDecimal) {
                atmosphereRatingAvg += ((BigDecimal) review.get("atmosphere_rating")).doubleValue();
            } else if (review.get("atmosphere_rating") instanceof Double) {
                atmosphereRatingAvg += (Double) review.get("atmosphere_rating");
            }
            if (review.get("price_rating") instanceof BigDecimal) {
                priceRatingAvg += ((BigDecimal) review.get("price_rating")).doubleValue();
            } else if (review.get("price_rating") instanceof Double) {
                priceRatingAvg += (Double) review.get("price_rating");
            }
            if (review.get("location_rating") instanceof BigDecimal) {
                locationRatingAvg += ((BigDecimal) review.get("location_rating")).doubleValue();
            } else if (review.get("location_rating") instanceof Double) {
                locationRatingAvg += (Double) review.get("location_rating");
            }
        }

        // 평균 계산
        trafficRatingAvg /= totalReviews;
        parkingRatingAvg /= totalReviews;
        atmosphereRatingAvg /= totalReviews;
        priceRatingAvg /= totalReviews;
        locationRatingAvg /= totalReviews;
    }


    // JSP에서 JavaScript 스타일을 사용해 동적 width를 계산
    double trafficWidth = trafficRatingAvg * 20; // 평점 5점 기준 100% 환산
    double parkingWidth = parkingRatingAvg * 20;
    double atmosphereWidth = atmosphereRatingAvg * 20;
    double priceWidth = priceRatingAvg * 20;
    double locationWidth = locationRatingAvg * 20;
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
		<a href="../Main-loadmap/index.jsp"> <img class="logo"
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
						위치 평점: <span id="location-rating"><%= String.format("%.1f", locationRatingAvg) %></span><br /> <span
							id="location-description">도심에 위치</span>
					</p>
				</div>
				<div class="reviews">
					<h3>
						<span id="overall-rating"><%= String.format("%.1f", overallRatingAvg) %></span> <span id="review-count">(<%= totalReviewCount %>건의
							후기)</span>
					</h3>
						<div class="review-box">
						    <%
						        int displayedReviews = 0; // 출력된 리뷰 개수를 추적
						        for (Map<String, Object> review : reviews) {
						            if (displayedReviews >= 2) break; // 두 개만 출력
						    %>
						            <div class="review" id="review-<%= displayedReviews + 1 %>">
						                “<%= review.get("review_text") %>”
						            </div>
						    <%
						            displayedReviews++;
						        }
						
						        if (displayedReviews == 0) {
						    %>
						            <p>아직 작성된 리뷰가 없습니다.</p>
						    <%
						        }
						    %>
						</div>

					<button class="more-reviews" id="moreReviewsButton">후기 더보기</button>
				</div>
			</div>
		</div>


		<!-- 하단 컨텐츠 -->
		<div class="main-content">
			<div class="tabs-container">
			    <div class="tabs">
			        <button class="tab active" data-target="#introduction">소개</button>
			        <button class="tab" data-target="#facilities">시설/서비스</button>
			        <button class="tab" data-target="#reviews">후기</button>
			        <button class="tab" data-target="#notices">예약 공지</button>
			    </div>
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
					<p><%= facilities %></p>
				</div>
			</div>
						<div id="reviews" class="content-area">
						<h3>후기</h3>
				<div class="overall-rating">
				    <p class="rating-score">
				        <h1><span><%= String.format("%.1f", overallRatingAvg) %></span></h1>
				        <span>리뷰 <%= totalReviewCount %>개</span>
				    </p>
				    <div class="stars">
				        <% 
				            // 별 개수 계산
				            int fullStars = (int) overallRatingAvg; // 꽉 찬 별의 개수
				            boolean hasHalfStar = (overallRatingAvg - fullStars) >= 0.5; // 반 별 여부
				
				            for (int i = 0; i < fullStars; i++) { 
				        %>
				            ★
				        <% 
				            }
				            if (hasHalfStar) { 
				        %>
				            ☆
				        <% 
				            }
				            for (int i = fullStars + (hasHalfStar ? 1 : 0); i < 5; i++) { 
				        %>
				            ☆
				        <% 
				            } 
				        %>
				    </div>
				</div>

				<div class="detailed-ratings">
					<h4>항목별 평점</h4>
					<div class="rating-bars">
					    <div class="rating-bar">
					        <span>교통:</span>
					        <div class="bar">
					            <div class="filled-bar" style="width: <%= trafficWidth %>%;"></div>
					        </div>
					        <span><%= String.format("%.1f", trafficRatingAvg) %></span>
					    </div>
					    <div class="rating-bar">
					        <span>주차:</span>
					        <div class="bar">
					            <div class="filled-bar" style="width: <%= parkingWidth %>%;"></div>
					        </div>
					        <span><%= String.format("%.1f", parkingRatingAvg) %></span>
					    </div>
					    <div class="rating-bar">
					        <span>분위기:</span>
					        <div class="bar">
					            <div class="filled-bar" style="width: <%= atmosphereWidth %>%;"></div>
					        </div>
					        <span><%= String.format("%.1f", atmosphereRatingAvg) %></span>
					    </div>
					    <div class="rating-bar">
					        <span>가격:</span>
					        <div class="bar">
					            <div class="filled-bar" style="width: <%= priceWidth %>%;"></div>
					        </div>
					        <span><%= String.format("%.1f", priceRatingAvg) %></span>
					    </div>
					    <div class="rating-bar">
					        <span>위치:</span>
					        <div class="bar">
					            <div class="filled-bar" style="width: <%= locationWidth %>%;"></div>
					        </div>
					        <span><%= String.format("%.1f", locationRatingAvg) %></span>
					    </div>
					</div>
				</div>
					
				<div class="review-write">
					<h4>리뷰 작성</h4>
					<form id="reviewForm" action="insert-review.jsp" method="post" accept-charset="UTF-8">
					    <input type="hidden" name="companyId" value="<%= companyId %>">
					    <div class="rating-input">
					        <label>교통:</label> <input type="number" name="traffic" min="1" max="5" required>
					        <label>주차:</label> <input type="number" name="parking" min="1" max="5" required>
					        <label>분위기:</label> <input type="number" name="ambiance" min="1" max="5" required>
					        <label>가격:</label> <input type="number" name="price" min="1" max="5" required>
					        <label>위치:</label> <input type="number" name="location" min="1" max="5" required>
					    </div>
					    <textarea name="reviewText" placeholder="후기를 입력해주세요" required></textarea>
					    <button type="submit">리뷰 등록</button> 
					</form>
					<hr class="review-divider"> 

					<div id="submitted-reviews">
					    <h4>작성된 리뷰</h4>
					    <% 
					        if (!reviews.isEmpty()) {
					            for (Map<String, Object> review : reviews) {
					    %>
					               <div class="review-item">
									    <div class="review-header">
									        <span class="review-user"><strong>작성자:</strong> 사용자 <%= review.get("user_id") %></span>
									        <span class="review-date"><small><%= review.get("created_at") %></small></span>
									    </div>
									    <div class="review-ratings">
									        <p><strong>평점:</strong></p>
									        <ul class="ratings-list">
									            <li>전체: <%= ((BigDecimal) review.get("overall_rating")).toPlainString() %></li>
									            <li>교통: <%= ((BigDecimal) review.get("traffic_rating")).toPlainString() %></li>
									            <li>주차: <%= ((BigDecimal) review.get("parking_rating")).toPlainString() %></li>
									            <li>분위기: <%= ((BigDecimal) review.get("atmosphere_rating")).toPlainString() %></li>
									            <li>가격: <%= ((BigDecimal) review.get("price_rating")).toPlainString() %></li>
									            <li>위치: <%= ((BigDecimal) review.get("location_rating")).toPlainString() %></li>
									        </ul>
									    </div>
									    <div class="review-content">
									        <p><strong>리뷰 내용:</strong> <%= review.get("review_text") %></p>
									    </div>
									    <hr>
									</div>
					               
					    <%
					            }
					        } else {
					    %>
					        <p>아직 작성된 리뷰가 없습니다.</p>
					    <%
					        }
					    %>
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
	 
	 
	 // 탭 클릭 시 해당 섹션으로 이동
	    document.querySelectorAll('.tab').forEach(tab => {
	        tab.addEventListener('click', () => {
	            // 모든 탭의 활성화 상태 제거
	            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
	            tab.classList.add('active');

	            // 모든 섹션의 활성화 상태 제거
	            document.querySelectorAll('.content-area').forEach(content => content.classList.remove('active'));
	            const target = document.querySelector(tab.getAttribute('data-target'));

	            // 섹션 활성화
	            target.classList.add('active');

	            // 상단 고정 메뉴바와 탭바 높이를 고려한 오프셋 계산
	            const menuBarHeight = document.querySelector('.menu_bar')?.offsetHeight || 0; // 메뉴바 높이
	            const tabsHeight = document.querySelector('.tabs')?.offsetHeight || 0; // 탭바 높이
	            const totalOffset = menuBarHeight + tabsHeight + 10; // 여유 공간 10px 추가

	            // 정확한 위치로 스크롤 이동
	            const targetOffset = Math.max(target.offsetTop - totalOffset, 0);

	            // 스크롤 이동
	            window.scrollTo({
	                top: targetOffset,
	                behavior: 'smooth' // 부드러운 스크롤
	            });
	        });
	    });

	    // "후기 더보기" 버튼 클릭 시 "후기" 탭으로 이동
	    document.getElementById('moreReviewsButton').addEventListener('click', () => {
	        // "후기" 탭과 섹션 활성화
	        const reviewTab = document.querySelector(".tab[data-target='#reviews']");
	        const reviewContent = document.getElementById('reviews');

	        // 모든 탭 및 섹션 초기화
	        document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
	        document.querySelectorAll('.content-area').forEach(content => content.classList.remove('active'));

	        reviewTab.classList.add('active');
	        reviewContent.classList.add('active');

	        // 상단 고정 메뉴바와 탭바 높이 계산
	        const menuBarHeight = document.querySelector('.menu_bar')?.offsetHeight || 0; // 메뉴바 높이
	        const tabsHeight = document.querySelector('.tabs')?.offsetHeight || 0; // 탭바 높이
	        const totalOffset = menuBarHeight + tabsHeight + 10; // 여유 공간 추가

	        // 스크롤 이동
	        const targetOffset = Math.max(reviewContent.offsetTop - totalOffset, 0);

	        window.scrollTo({
	            top: targetOffset,
	            behavior: 'smooth' // 부드러운 스크롤
	        });
	    });

	    // 탭바 고정 관련 코드
	    const tabsContainer = document.querySelector('.tabs-container');
	    const tabs = document.querySelector('.tabs');
	    const tabsOffsetTop = tabsContainer.offsetTop;

	    window.addEventListener('scroll', () => {
	        const menuBarHeight = document.querySelector('.menu_bar')?.offsetHeight || 0; // 메뉴바 높이
	        if (window.scrollY >= tabsOffsetTop - menuBarHeight) {
	            tabs.classList.add('sticky-tabs');
	            tabsContainer.classList.add('sticky-spacing'); // 여백 추가
	        } else {
	            tabs.classList.remove('sticky-tabs');
	            tabsContainer.classList.remove('sticky-spacing'); // 여백 제거
	        }
	    });

	
	</script>
    
</body>
</html>