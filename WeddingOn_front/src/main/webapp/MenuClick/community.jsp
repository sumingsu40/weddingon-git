<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" href="../images/icon.png">
<title>Community</title>
<link rel="stylesheet" type="text/css" href="community.css">
</head>
<body>
    <div class="community-container" id="communityContainer">
        <div class="new-post">
            <input type="text" class="new-post-input" id="searchInput" placeholder="원하는 검색어를 입력해주세요">
            <button id="searchButton">검색</button>
            <img class="new-post-icon" src="../images/edit-icon.png" alt="작성 아이콘">
        </div>
        <div class="post-list" id="postList">
            <!-- 게시물 리스트는 JavaScript로 동적으로 추가 -->
        </div>
        <div class="pagination">
            <button class="page-btn" data-page="1">1</button>
        </div>
    </div>
    <div class="write-post hidden" id="writePost">
        <input type="text" class="write-post-title" placeholder="제목을 입력하세요..." />
        <textarea class="write-post-text" placeholder="내용을 작성하세요..."></textarea>
        <input type="text" class="write-post-hashtags" placeholder="해시태그를 입력하세요 (예: #웨딩, #드레스)" />
        <div class="button-group">
            <button class="save-btn" id="savePost">저장</button>
            <button class="reset-btn" id="resetPost">초기화</button>
        </div>
    </div>

    <script>

	    const postsPerPage = 6; // 페이지당 게시글 수
	    let currentPage = 1; // 현재 페이지
	    let totalPages = 0; // 총 페이지 수
	    let currentGroup = 1; // 현재 페이지 그룹
	    const buttonsPerGroup = 6; // 한 그룹당 최대 버튼 수
	    
	    document.getElementById('searchButton').addEventListener('click', () => {
	        const searchInput = document.getElementById('searchInput').value.trim();
	        currentPage = 1; // 검색 시 첫 번째 페이지로 이동
	        fetchPosts(currentPage, searchInput); // 검색어와 함께 게시글 요청
	    });
	    
	    
	 	// 페이지 버튼 렌더링
	    function renderPagination(totalPages) {
	        const paginationContainer = document.querySelector('.pagination');
	        paginationContainer.innerHTML = ''; // 기존 버튼 초기화

	        const startPage = (currentGroup - 1) * buttonsPerGroup + 1;
	        const endPage = Math.min(startPage + buttonsPerGroup - 1, totalPages);

	        for (let i = startPage; i <= endPage; i++) {
	            const button = document.createElement('button');
	            button.className = 'page-btn';
	            button.textContent = i;
	            button.dataset.page = i;

	            if (i === currentPage) {
	                button.classList.add('active');
	            }

	            button.addEventListener('click', () => {
	                currentPage = i;
	                fetchPosts(currentPage);
	                renderPagination(totalPages);
	            });

	            paginationContainer.appendChild(button);
	        }

	        // 다음 그룹으로 이동 버튼
	        if (endPage < totalPages) {
	            const nextGroupButton = document.createElement('button');
	            nextGroupButton.textContent = '>';
	            nextGroupButton.addEventListener('click', () => {
	                currentGroup++;
	                renderPagination(totalPages);
	            });
	            paginationContainer.appendChild(nextGroupButton);
	        }

	        // 이전 그룹으로 이동 버튼
	        if (currentGroup > 1) {
	            const prevGroupButton = document.createElement('button');
	            prevGroupButton.textContent = '<';
	            prevGroupButton.addEventListener('click', () => {
	                currentGroup--;
	                renderPagination(totalPages);
	            });
	            paginationContainer.insertBefore(prevGroupButton, paginationContainer.firstChild);
	        }
	    }
	
	    function renderPosts(posts) {
	        const postList = document.getElementById('postList'); // 게시글 컨테이너
	        postList.innerHTML = ''; // 기존 게시글 초기화

	        posts.forEach(post => {
	            const postCard = document.createElement('div');
	            postCard.className = 'post-card';

	            // 제목 생성
	            const postTitle = document.createElement('h3');
	            postTitle.textContent = post.title;

	            // 본문 내용 생성 (80자 제한)
	            const postContent = document.createElement('p');
	            const previewContent = post.content.length > 70
	                ? post.content.substring(0, 70) + '...' // 80자까지만 보여주고 "..." 추가
	                : post.content;
	            postContent.textContent = previewContent;

	            // postCard에 요소 추가
	            postCard.appendChild(postTitle);
	            postCard.appendChild(postContent);

	            // 클릭 이벤트 추가
	            postCard.addEventListener('click', () => {
	                window.location.href = `community-click.jsp?postId=` + post.post_id;
	                console.log(post.post_id);
	            });

	            // postList에 postCard 추가
	            postList.appendChild(postCard);
	        });
	    }


	
	    async function fetchPosts(page, keyword = '') {
	        try {
	            const url = `fetchPosts.jsp?page=`+page+`&keyword=`+keyword;
	            console.log("Request URL: ", url); // URL 로그 추가
	            const response = await fetch(url);

	            if (!response.ok) {
	                throw new Error('Network response was not ok');
	            }

	            const data = await response.json();
	            const posts = data.posts;
	            const totalPosts = data.totalPosts;

	            if (Array.isArray(posts)) {
	                renderPosts(posts); // 게시글 렌더링
	                const totalPages = Math.ceil(totalPosts / postsPerPage); // 총 페이지 수 계산
	                renderPagination(totalPages); // 동적으로 페이지 버튼 렌더링
	            } else {
	                console.error('잘못된 응답 형식:', data);
	            }
	            
	            
	        } catch (error) {
	            console.error('Error fetching posts:', error);
	        }
	    }



	
	    document.querySelectorAll('.page-btn').forEach(button => {
	        button.addEventListener('click', () => {
	            currentPage = parseInt(button.getAttribute('data-page')); // data-page 값을 가져옴
	            console.log("Clicked page: ", currentPage);
	            fetchPosts(currentPage); // 페이지 번호와 함께 fetchPosts 호출

	            // 활성화된 버튼 강조
	            document.querySelectorAll('.page-btn').forEach(btn => btn.classList.remove('active'));
	            button.classList.add('active');
	        });
	    });

	
	    document.querySelector('.new-post-icon').addEventListener('click', () => {
	        const container = document.getElementById('communityContainer');
	        const writePost = document.getElementById('writePost');
	
	        container.classList.toggle('shift');
	        writePost.classList.toggle('hidden');
	    });
	
	    
	    document.getElementById('savePost').addEventListener('click', async () => {
	        const title = document.querySelector('.write-post-title').value.trim();
	        const content = document.querySelector('.write-post-text').value.trim();
	        const hashtags = document.querySelector('.write-post-hashtags').value.trim();

	        if (!title || !content) {
	            alert('제목과 내용을 모두 입력해주세요.');
	            return;
	        }

	        try {
	            const response = await fetch('savePost.jsp', {
	                method: 'POST',
	                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	                body: `title=`+title+`&content=`+content+`&hashtags=`+hashtags
	            });

	            const result = await response.json();
	            if (result.status === 'success') {
	                alert('게시글이 성공적으로 저장되었습니다.');
	                
	             	// 글쓰기 팝업 닫기
	                document.getElementById('writePost').classList.add('hidden');
	                document.getElementById('communityContainer').classList.remove('shift');
	                
	                
	                fetchPosts(1); // 첫 페이지 새로고침
	                document.querySelector('.write-post-title').value = '';
	                document.querySelector('.write-post-text').value = '';
	                document.querySelector('.write-post-hashtags').value = '';
	            } else {
	                alert('게시글 저장에 실패했습니다.');
	            }
	        } catch (error) {
	            console.error('Error saving post:', error);
	            alert('게시글 저장 중 오류가 발생했습니다.');
	        }
	    });

	
	    document.getElementById('resetPost').addEventListener('click', () => {
	        document.querySelector('.write-post-title').value = '';
	        document.querySelector('.write-post-text').value = '';
	        document.querySelector('.write-post-hashtags').value = '';
	    });
	
	    // 첫 번째 페이지 데이터 가져오기
	    fetchPosts(1);
	
	
	</script>

</body>
</html>
