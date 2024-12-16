<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="../images/icon.png">
    <title>로드맵</title>
    <style>
        @font-face {
    font-family: 'GowunBatang-Regular';
    src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/GowunBatang-Regular.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}

body {
    font-family: 'GowunBatang-Regular', 'Arial', sans-serif;
    margin: 0;
    padding: 0;
    background: linear-gradient(180deg, rgba(255, 200, 220, 0.9), rgba(255, 230, 240, 0.9));
    height: 100vh;
    width: 100vw;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
}

/* 상단 로고 */
.logo {
    position: relative; /* 부모 요소(.content) 기준으로 배치 */
    margin-bottom: -3vw; /* 문장과의 간격 조정 */
    width: 12vw; /* 화면 너비에 비례 */
    max-width: 130px; /* 최대 크기 제한 */
    height: auto;
    margin-left: auto; /* 수평 중앙 정렬을 위해 추가 */
    margin-right: auto;
    animation: fadeInDown 1.5s ease-out forwards;
}
/* 중앙 콘텐츠 컨테이너 */
.content {
    width: 100%;
    max-width: 1200px;
    text-align: center;
    position: absolute;
    top: 50%; /* 화면 중앙에 맞춤 */
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 1;
}

.header {
    font-size: 3vw; /* 화면 너비에 비례 */
    font-weight: bold;
    color: #ffffff;
    text-shadow: 4px 4px 8px rgba(0, 0, 0, 0.2);
    margin: 0;
    margin-top: 1vh; /* 로고와의 간격 추가 */
}

.sub-header {
    margin-top: 1vh;
    font-size: 2vw;
    color: #ffffff;
    font-style: italic;
}

        .loadmap-img {
    width: 70%;
    height: auto;
    max-width: 750px;
    margin-top: 2vh;
    border-radius: 20px;
    animation: fadeIn 2s ease-in-out;
}

     @keyframes fadeIn {
    0% { opacity: 0; }
    100% { opacity: 1; }
}

        .footer-message {
    margin-top: 2vh;
    font-size: 2.5vw; /* 화면 너비에 비례 */
    color: #ffffff;
    text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.2);
    font-weight: bold;
}

        .start-button {
    display: inline-block;
    margin-top: 3vh;
    padding: 1.5vh 3vw;
    font-size: 1.8vw; /* 버튼 텍스트 크기 */
    font-weight: bold;
    color: #ffffff;
    background-color: #ff69b4;
    border: none;
    border-radius: 25px;
    text-decoration: none;
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
    cursor: pointer;
    transition: all 0.3s ease;
    animation: buttonFadeUp 1.5s ease-out forwards;
}

.start-button:hover {
    background-color: #ff85c0;
    box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.3);
}
@keyframes fadeInDown {
    0% {
        opacity: 0;
        transform: translateY(-50px); /* 위에서부터 시작 */
    }
    100% {
        opacity: 1;
        transform: translateY(0); /* 제자리 */
    }
}

@keyframes buttonFadeUp {
    0% {
        transform: translateY(50px);
        opacity: 0;
    }
    100% {
        transform: translateY(0);
        opacity: 1;
    }
}

        /* 물방울 애니메이션 */
        .wrapper {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            overflow: hidden;
        }

        .bubble {
            position: absolute;
            border: 2px solid rgba(255, 255, 255, 0.5);
            border-radius: 50%;
            animation: animate 10s linear infinite;
        }

        @keyframes animate {
            0% {
                transform: scale(0.5) translateY(0) rotate(70deg);
            }
            100% {
                transform: scale(1.3) translateY(-300px) rotate(360deg);
            }
        }

        /* 물방울 개별 위치 */
        .bubble:nth-child(1) { top: 90%; left: 15%; width: 50px; height: 50px; animation-duration: 9s; }
        .bubble:nth-child(2) { top: 80%; left: 25%; width: 40px; height: 40px; animation-duration: 8s; }
        .bubble:nth-child(3) { top: 70%; left: 45%; width: 70px; height: 70px; animation-duration: 10s; }
        .bubble:nth-child(4) { top: 60%; left: 65%; width: 60px; height: 60px; animation-duration: 7s; }
        .bubble:nth-child(5) { top: 50%; left: 85%; width: 50px; height: 50px; animation-duration: 6s; }
        .bubble:nth-child(6) { top: 40%; left: 20%; width: 80px; height: 80px; animation-duration: 11s; }
        .bubble:nth-child(7) { top: 30%; left: 50%; width: 30px; height: 30px; animation-duration: 9s; }
        .bubble:nth-child(8) { top: 20%; left: 75%; width: 60px; height: 60px; animation-duration: 8s; }
        .bubble:nth-child(9) { top: 10%; left: 5%; width: 50px; height: 50px; animation-duration: 12s; }
        .bubble:nth-child(10) { top: 85%; left: 40%; width: 90px; height: 90px; animation-duration: 10s; }
        .bubble:nth-child(11) { top: 75%; left: 60%; width: 45px; height: 45px; animation-duration: 9s; }
        .bubble:nth-child(12) { top: 65%; left: 80%; width: 70px; height: 70px; animation-duration: 7s; }
        .bubble:nth-child(13) { top: 95%; left: 10%; width: 40px; height: 40px; animation-duration: 8s; }
        .bubble:nth-child(14) { top: 30%; left: 20%; width: 50px; height: 50px; animation-duration: 9s; }
        .bubble:nth-child(15) { top: 50%; left: 70%; width: 60px; height: 60px; animation-duration: 6s; }
        .bubble:nth-child(16) { top: 95%; left: 85%; width: 60px; height: 60px; animation-duration: 10s; }
        .bubble:nth-child(17) { top: 85%; left: 90%; width: 40px; height: 40px; animation-duration: 7s; }
    </style>
</head>
<body>

    <!-- 물방울 애니메이션 -->
    <div class="wrapper">
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
        <div class="bubble"></div>
    </div>

    <!-- 중앙 콘텐츠 -->
    <div class="content">
    <!-- 상단 로고 -->
    <img class="logo" src="../images/couple.png" alt="로고">
        <div class="header">특별한 여정을 위한 첫 걸음</div>
        <div class="sub-header">당신의 웨딩 여정을 완벽하게 디자인합니다</div>
        <img class="loadmap-img" src="../images/loadmap-icon.png" alt="로드맵 이미지">
        <div class="footer-message">함께 만들어가는 가장 특별한 순간!</div>
        <!-- 여정 시작하기 버튼 -->
        <a href="index.jsp" class="start-button">여정 시작하기</a>
    </div>
</body>
</html>
