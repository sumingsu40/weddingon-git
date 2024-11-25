<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>웨딩홀 페이지</title>
    <link rel="stylesheet" type="text/css" href="companyClick.css">
    <style>
        /* 활성화된 탭 스타일 */
        .tab.active {
            background: #F9BBBB;
            font-weight: bold;
        }
    </style>
</head>
<body>
	<!-- 3트 -->
    <!-- 상단 검색바 -->
    <div class="top_bar">
        <form class="search_container" method="post">
            <input class="search_icon" type="text" name="company_name" placeholder="검색어를 입력하세요">
            <button type="submit" class="search_button">🔍</button>
        </form>
        <img class="logo" src="images/weddingon-logo.png" alt="로고">
        <img class="Mypage" src="images/mypage-icon.png" alt="마이페이지 아이콘">
    </div>

    <!-- 메뉴바 -->
    <div class="menu_bar">
        <div class="box">
            <img id="menu-icon" src="images/community-icon.png" alt="커뮤니티 아이콘">
            <span>커뮤니티</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="images/weddinghall-icon.png" alt="식장 아이콘">
            <span>식장</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="images/studio-icon.png" alt="스튜디오 아이콘">
            <span>스튜디오</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="images/makeup-icon.png" alt="메이크업 아이콘">
            <span>메이크업</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="images/dress-icon.png" alt="드레스 아이콘">
            <span>드레스</span>
        </div>
        <div class="box">
            <img id="menu-icon" src="images/letter-icon.png" alt="청첩장 아이콘">
            <span>청첩장</span>
        </div>
    </div>

    <!-- 첫 번째 화면 -->
    <div class="container">

            <div class="photos">
                <div class="photo-main">사진 삽입란</div>
                <div class="photo-side">사진더보기</div>
            </div>

            <div class="details-review-section">
                <div class="details">
                    <h2>아이콘 웨딩홀 다이너스티</h2>
                    <p>서문대로 663번안길 12, 61736 지도보기</p>
                    <p>아이콘 웨딩홀은 대한민국 최고의 웨딩홀이며 엄청난 위치와 서비스를 자랑합니다.</p>                   
				 <!-- 버튼 컨테이너 -->
				    <div class="like-share-buttons">
				        <button class="chat-btn">채팅 하기</button>
					    <img src="images/heart.png" alt="찜 버튼" class="heart-icon">
					    <img src="images/share.png" alt="공유 버튼" class="share-icon">				        
				    </div>  
            </div>
                <div class="reviews">
                    <h3>5.0 최우수 <span>(1300건의 후기)</span></h3>
                    <div class="review-box">
                        <div class="review">“너무 좋아용”</div>
                        <div class="review">“직원분들이 매우 친절해요”</div>
                    </div>
                    <button class="more-reviews">후기 더보기</button>
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
            <p>다이너스티 홀은 300명 규모의 중형 웨딩부터 600명 규모의 대형 웨딩까지 다양하게 연출이 가능한 최적의 공간입니다.</p>
        </div>
        <div id="facilities" class="content-area">
            <h3>시설/서비스</h3>
            <p>여기에 시설/서비스 관련 내용이 들어갑니다.</p>
        </div>
        <div id="reviews" class="content-area">
            <h3>후기</h3>
            <p>여기에 후기 내용이 들어갑니다.</p>
        </div>
        <div id="notices" class="content-area">
            <h3>예약 공지</h3>
            <p>여기에 예약 공지 내용이 들어갑니다.</p>
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