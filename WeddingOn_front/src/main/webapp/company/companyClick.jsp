
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
    String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
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

<%
    boolean isFavorite = false;

    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
         PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM favorites WHERE user_id = ? AND company_id = ?")) {
        pstmt.setInt(1, (Integer) session.getAttribute("userDbId"));
        pstmt.setInt(2, Integer.parseInt(companyId));
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                isFavorite = true;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" href="../images/icon.png">
<title>웨딩홀 페이지</title>
<link rel="stylesheet" type="text/css" href="companyClick.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

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
               <div class="chat-btn" onclick="startChat('<%= companyId %>')">채팅하기</div>
               <div class="heart-icon">
                  <!-- heart-icon 클래스를 추가 -->
                  <img src="../images/<%= isFavorite ? "fullheart.png" : "heart.png" %>" alt="찜 버튼" />
               </div>
               <img src="../images/share.png" alt="공유 버튼" class="share-icon" id="shareButton"/>
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
         <img src="../images/<%= isFavorite ? "fullheart.png" : "heart.png" %>" alt="찜 버튼" />
      </div>
      <div class="chat-btn" onclick="startChat('<%= companyId %>')">채팅하기</div>
   </div>



    <script>
    function startChat(companyId) {
        if (!companyId) {
            alert("회사 정보를 확인할 수 없습니다.");
            return;
        }

        // 기존 채팅창 제거
        let chatContainer = document.getElementById('chatContainer');
        if (chatContainer) {
            chatContainer.remove();
        }
        
        

        // 새로운 채팅창 컨테이너 생성
        chatContainer = document.createElement('div');
        chatContainer.id = 'chatContainer';
        chatContainer.style.position = 'fixed';
        chatContainer.style.bottom = '10px';
        chatContainer.style.right = '10px';
        chatContainer.style.width = '400px';
        chatContainer.style.height = '600px';
        chatContainer.style.border = '1px solid #ccc';
        chatContainer.style.borderRadius = '8px';
        chatContainer.style.backgroundColor = '#fff';
        chatContainer.style.boxShadow = '0 4px 8px rgba(0, 0, 0, 0.2)';
        chatContainer.style.zIndex = '1000';
        chatContainer.style.overflow = 'hidden';

        // 닫기 버튼 추가
        const closeButton = document.createElement('button');
        closeButton.innerText = 'X';
        closeButton.style.position = 'absolute';
        closeButton.style.top = '5px';
        closeButton.style.right = '5px';
        closeButton.style.border = 'none';
        closeButton.style.backgroundColor = '#f06292';
        closeButton.style.color = '#fff';
        closeButton.style.padding = '5px 10px';
        closeButton.style.borderRadius = '50%';
        closeButton.style.cursor = 'pointer';
        closeButton.style.fontSize = '14px';
        closeButton.onclick = () => chatContainer.remove();
        chatContainer.appendChild(closeButton);

        // iframe 생성 및 JSP 로드
        const iframe = document.createElement('iframe');
        iframe.src = "../chat/chatPopup.jsp?company_id=" + companyId;
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.style.border = 'none';
        chatContainer.appendChild(iframe);

        // 페이지에 추가
        document.body.appendChild(chatContainer);
    }
          
    	document.addEventListener('DOMContentLoaded', () => {
          const heartIcons = document.querySelectorAll('.heart-icon img'); // 모든 하트 아이콘 가져오기

          heartIcons.forEach((heartIcon) => {
              heartIcon.addEventListener('click', async () => {
                  console.log("Heart icon clicked");

                  const userId = "<%= session.getAttribute("userDbId") %>"; // 세션에서 사용자 ID 가져오기
                  const companyId = "<%= companyId %>"; // 회사 ID

                  if (!userId || !companyId) {
                      alert("로그인 후 사용해주세요.");
                      return;
                  }

                  try {
                      // 서버에 좋아요/취소 요청 보내기
                      const response = await fetch('addFavorite.jsp', {
                          method: 'POST',
                          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                          body: `userId=`+userId+`&companyId=`+companyId
                      });

                      const result = await response.json(); // 서버 응답 처리
                      console.log(result);

                      if (result.status === 'success') {
                          if (result.message === 'Favorite added') {
                              heartIcons.forEach(icon => {
                                  icon.src = "../images/fullheart.png"; // 모든 하트 아이콘을 채워진 하트로 변경
                              });
                              alert("좋아요가 추가되었습니다.");
                          } else if (result.message === 'Favorite removed') {
                              heartIcons.forEach(icon => {
                                  icon.src = "../images/heart.png"; // 모든 하트 아이콘을 빈 하트로 변경
                              });
                              alert("좋아요가 취소되었습니다.");
                          }
                      } else {
                          alert(result.message || "요청 처리 중 오류 발생");
                      }
                  } catch (error) {
                      console.error('Error:', error);
                      alert("요청 처리 중 문제가 발생했습니다.");
                  }
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
    
    
       document.addEventListener('DOMContentLoaded', () => {
   	    const tabs = document.querySelectorAll('.tab');
   	    const sections = document.querySelectorAll('.content-area');
   	    const tabContainer = document.querySelector('.tabs-container');
   	    const tabContainerHeight = tabContainer.offsetHeight;
   	    let isScrolling = false; // 스크롤 중 상태 확인 변수
   	    // 각 섹션의 ID와 top 위치를 계산
   	    const sectionOffsets = Array.from(sections).map(section => ({
   	        id: section.id,
   	        offsetTop: section.offsetTop - tabContainerHeight - 10 // 탭바 높이와 여백을 고려
   	    }));
   	    // 마지막 섹션 보정 처리
   	    const lastSection = sections[sections.length - 1];
   	    const lastSectionBottomOffset = lastSection.offsetTop + lastSection.offsetHeight;
   	    // 탭 클릭 시 스크롤 이동
   	    tabs.forEach(tab => {
   	        tab.addEventListener('click', event => {
   	            event.preventDefault(); // 기본 동작 방지
   	            isScrolling = true; // 스크롤 이벤트 비활성화
   	            const target = document.querySelector(tab.getAttribute('data-target'));
   	            // 탭바 높이 계산
   	            const menuBarHeight = document.querySelector('.menu_bar')?.offsetHeight || 0;
   	            const totalOffset = menuBarHeight + tabContainerHeight + 10;
   	            // 정확한 위치로 스크롤 이동
   	            const targetOffset = Math.max(target.offsetTop - totalOffset, 0);
   	            // 모든 탭 비활성화 후 클릭한 탭 활성화
   	            tabs.forEach(t => t.classList.remove('active'));
   	            tab.classList.add('active');
   	            window.scrollTo({
   	                top: targetOffset,
   	                behavior: 'smooth'
   	            });
   	            // 스크롤이 끝난 후 스크롤 이벤트 활성화
   	            setTimeout(() => {
   	                isScrolling = false; // 스크롤 이벤트 활성화
   	            }, 500); // 애니메이션 시간(500ms) 이후 실행
   	        });
   	    });
   	    // 스크롤 이벤트: 활성 탭 변경
   	    window.addEventListener('scroll', () => {
   	        if (isScrolling) return; // 탭 클릭으로 스크롤 중이면 이벤트 중단
   	        const scrollPosition = window.scrollY + tabContainerHeight + 20;
   	        // 현재 활성화할 섹션 찾기
   	        let currentSection = sectionOffsets[0].id; // 기본값
   	        for (let i = 0; i < sectionOffsets.length; i++) {
   	            if (scrollPosition >= sectionOffsets[i].offsetTop) {
   	                currentSection = sectionOffsets[i].id;
   	            } else {
   	                break;
   	            }
   	        }
   	        // 마지막 섹션 처리
   	        if (scrollPosition >= lastSectionBottomOffset - window.innerHeight) {
   	            currentSection = lastSection.id;
   	        }
   	        // 해당 섹션의 탭 활성화
   	        tabs.forEach(tab => {
   	            const targetId = tab.getAttribute('data-target').substring(1); // # 제거
   	            if (targetId === currentSection) {
   	                tab.classList.add('active');
   	            } else {
   	                tab.classList.remove('active');
   	            }
   	        });
   	    });
   	    // 탭바 고정 처리
   	    const tabsContainer = document.querySelector('.tabs-container');
   	    const tabsElement = document.querySelector('.tabs');
   	    const tabsOffsetTop = tabsContainer.offsetTop;
   	    window.addEventListener('scroll', () => {
   	        if (window.scrollY >= tabsOffsetTop) {
   	            tabsElement.classList.add('sticky-tabs');
   	            tabsElement.style.top = '0'; // 상단에 고정
   	        } else {
   	            tabsElement.classList.remove('sticky-tabs');
   	            tabsElement.style.top = ''; // 기본 위치 복원
   	        }
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

       document.addEventListener('DOMContentLoaded', () => {
           const tabsContainer = document.querySelector('.tabs-container');
           const tabs = document.querySelector('.tabs');
           const tabsOffsetTop = tabsContainer.offsetTop;

           window.addEventListener('scroll', () => {
               if (window.scrollY >= tabsOffsetTop) {
                   tabs.classList.add('sticky-tabs');
                   tabs.style.top = '0'; // 상단에 고정
               } else {
                   tabs.classList.remove('sticky-tabs');
                   tabs.style.top = ''; // 기본 위치로 복원
               }
           });
       });

       
       document.getElementById('shareButton').addEventListener('click', () => {
    	    // 현재 페이지의 URL 가져오기
    	    const currentUrl = window.location.href;

    	    // URL을 클립보드에 복사
    	    navigator.clipboard.writeText(currentUrl)
    	        .then(() => {
    	            // 복사 성공 시 알림
    	            alert('URL이 클립보드에 복사되었습니다!');
    	        })
    	        .catch(err => {
    	            // 복사 실패 시 알림
    	            console.error('URL 복사 실패:', err);
    	            alert('URL 복사에 실패했습니다.');
    	        });
    	});
   
   </script>
    
</body>
</html>

