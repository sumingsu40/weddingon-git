<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
        const posts = [
            '여기서 결혼은 두번째?',
            '웨딩홀 추천 부탁드려요!',
            '드레스 투어 후기 공유',
            '스튜디오 선택 고민입니다.',
            '청첩장 디자인 뭐가 좋을까요?',
        ];

        const postsPerPage = 6;
        let currentPage = 1;

        function renderPosts(page) {
            const postList = document.getElementById('postList');
            postList.innerHTML = '';

            const startIndex = (page - 1) * postsPerPage;
            const endIndex = startIndex + postsPerPage;
            const currentPosts = posts.slice(startIndex, endIndex);

            currentPosts.forEach(post => {
                const postCard = document.createElement('div');
                postCard.className = 'post-card';
                postCard.innerHTML = `
                    <h3>${post}</h3>
                    <p>내용이 들어갑니다...</p>
                `;
                postList.appendChild(postCard);
            });
        }

        document.querySelectorAll('.page-btn').forEach(button => {
            button.addEventListener('click', () => {
                currentPage = parseInt(button.getAttribute('data-page'));
                renderPosts(currentPage);

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

        renderPosts(currentPage);
    </script>
</body>
</html>
