<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Community</title>
<link rel="stylesheet" type="text/css" href="community.css">
</head>
<body>
    <div class="community-container" id="communityContainer">
        <div class="new-post">
            <input type="text" class="new-post-input" placeholder="원하는 검색어를 입력해주세요">
            <img class="new-post-icon" src="../images/edit-icon.png" alt="작성 아이콘">
        </div>
        <div class="post-list" id="postList">
            <!-- 게시물 리스트는 JavaScript로 동적으로 추가 -->
        </div>
        <div class="pagination">
            <button class="page-btn" data-page="1">1</button>
            <button class="page-btn" data-page="2">2</button>
            <button class="page-btn" data-page="3">3</button>
            <button class="page-btn" data-page="4">4</button>
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

	    const postsPerPage = 10;
	    let currentPage = 1;
	
	    function renderPosts(posts) {
	        const postList = document.getElementById('postList'); // 게시글 컨테이너
	        postList.innerHTML = ''; // 기존 게시글 초기화
			
	        const reversedPosts = [...posts].reverse();
	        
	        reversedPosts.forEach(post => {
	            const postCard = document.createElement('div');
	            postCard.className = 'post-card';

	            // 제목 생성
	            const postTitle = document.createElement('h3');
	            postTitle.textContent = post.title;

	            // 내용 생성
	            const postContent = document.createElement('p');
	            postContent.textContent = post.content;


	            // postCard에 요소 추가
	            postCard.appendChild(postTitle);
	            postCard.appendChild(postContent);

	            // 클릭 이벤트 추가
	            postCard.addEventListener('click', () => {
	                window.location.href = `community-click.jsp?postId=`+post.post_id;
	                console.log(post.post_id);
	            });

	            // postList에 postCard 추가
	            postList.appendChild(postCard);
	        });
	    }

	
	    async function fetchPosts(page) {
	        try {
	            const url = `fetchPosts.jsp?page=`+page;
	            console.log("Request URL: ", url); // URL 로그 추가
	            const response = await fetch(url);

	            if (!response.ok) {
	                throw new Error('Network response was not ok');
	            }

	            const posts = await response.json();

	            if (Array.isArray(posts)) {
	                renderPosts(posts);
	            } else {
	                console.error('Invalid response format:', posts);
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
	
	    document.getElementById('savePost').addEventListener('click', () => {
	        const container = document.getElementById('communityContainer');
	        const writePost = document.getElementById('writePost');
	
	        container.classList.remove('shift');
	        writePost.classList.add('hidden');
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
