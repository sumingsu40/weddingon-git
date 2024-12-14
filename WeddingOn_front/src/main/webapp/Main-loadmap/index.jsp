<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>index</title>
    <link rel="stylesheet" type="text/css" href="index.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
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
            animation: fadeIn 1s ease-out;
        }

        /* 페이지 애니메이션 효과 */
        @keyframes fadeIn {
            0% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }

        /* 페이지가 로드될 때 애니메이션 */
        .page {
            position: absolute;
            top: 100%; /* 화면 아래에서 시작 */
            left: 0;
            width: 100%;
            height: 100%;
            background: white;
            animation: slideUp 1s ease-out forwards;
        }

        @keyframes slideUp {
            0% {
                top: 100%;
            }
            100% {
                top: 0;
            }
        }

        /* 페이지 이동 시 애니메이션 */
        .slide-in {
            animation: slideUp 1s ease-out forwards;
        }

    </style>
</head>
<body>
    <!-- 전체 페이지를 감싸는 애니메이션 컨테이너 -->
    <div class="page slide-in">
        <!-- 상단 바 -->
        <div class="top_bar">
        	<form class="search_container" id="searchForm" onsubmit="return false;">
		        <input class="search_icon" type="text" id="keyword" name="company_name" placeholder="검색어를 입력하세요">
		        <button type="button" class="search_button" id="searchButton">search</button>
		    </form>
            <img class="logo" src="../images/weddingon-logo.png" alt="로고">
            <img class="mypage" src="../images/mypage-icon.png" alt="마이페이지 아이콘">
        </div>

        <!-- 메뉴 바 -->
        <div class="menu_bar">
            <div class="menu_item" data-page="../MenuClick/community.jsp">
                <img class="menu_icon" src="../images/community-icon.png" alt="커뮤니티 아이콘">
                <span>커뮤니티</span>
            </div>
            <div class="menu_item active" data-page="../MenuClick/hall.jsp">
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
            <iframe id="contentFrame" src="../MenuClick/hall.jsp"></iframe>
        </div>
    </div>

<script>
    // iframe의 src 동기화 및 URL 업데이트
    function syncIframeFromUrl() {
        const iframe = document.getElementById('contentFrame');
        const urlParams = new URLSearchParams(window.location.search);
        const iframeSrc = urlParams.get('iframeSrc');

        if (iframeSrc && iframe) {
            iframe.src = iframeSrc; // URL에 저장된 iframeSrc로 iframe 업데이트
        }
    }

    function updateUrlForIframe(newIframeSrc) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('iframeSrc', newIframeSrc); // iframeSrc 파라미터 설정
        const newUrl = `${window.location.pathname}?${urlParams.toString()}`;
        window.history.replaceState(null, '', newUrl); // URL 갱신
    }

    // 페이지 로드 시 iframe 초기화
    document.addEventListener('DOMContentLoaded', () => {
        syncIframeFromUrl();

        const menuItems = document.querySelectorAll('.menu_item');
        const iframe = document.getElementById('contentFrame');
        const logo = document.querySelector('.logo');
        const myPageIcon = document.querySelector('.mypage');
        
        const searchButton = document.getElementById('searchButton');
        const searchInput = document.getElementById('keyword');

        menuItems.forEach(item => {
            item.addEventListener('click', () => {
                menuItems.forEach(i => i.classList.remove('active'));
                item.classList.add('active');
                const page = item.getAttribute('data-page');
                iframe.src = page; // iframe 내용 변경
                updateUrlForIframe(page); // URL 동기화
            });
        });

        logo.addEventListener('click', () => {
            window.location.href = 'loadmap.jsp'; // 전체 페이지 이동
        });

        myPageIcon.addEventListener('click', () => {
            window.location.href = '../Mypage/mypage.jsp'; // 전체 페이지 이동
        });
        
        searchButton.addEventListener('click', () => {
            const query = searchInput.value.trim();

            if (query === '') {
                alert('검색어를 입력해주세요.');
                return;
            }

            const searchUrl = `../MenuClick/searchResults.jsp?keyword=`+query; // 검색 결과 페이지 URL
            iframe.src = searchUrl; // iframe에 검색 결과 페이지 로드
            updateUrlForIframe(searchUrl); // URL에 반영
        });
        
    });
</script>

</body>
</html>
