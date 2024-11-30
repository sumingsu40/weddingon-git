<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Community Post</title>
<style>
    body {
        margin: 0;
        padding: 0;
        font-family: 'Noto Sans KR', Arial, sans-serif;
        background-color: #FFFFFF;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .post-container {
        max-width: 800px;
        width: 90%;
        margin: auto;
        padding: 20px;
        background-color: #FFF8FB;
        border: 2px solid #DDD;
        border-radius: 15px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
        gap: 20px;
        position: relative;
        height: 82vh; /* 전체 높이 */
    }

    .post-title {
        font-size: 24px;
        font-weight: bold;
        color: #333;
        border-bottom: 1px solid #DDD;
        padding-bottom: 10px;
        display: flex;
        justify-content: space-between;
    }
    .post-id{
      font-size: 15px;
      padding-top:10px;
    }

    .post-content {
        font-size: 16px;
        color: #333;
        line-height: 1.6;
        white-space: pre-line;
        padding-top: 10px;
        max-height: 300px;
    	overflow-y: auto;
    }

    .comment-section {
        margin-top: 20px;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .comment-title {
        font-size: 18px;
        font-weight: bold;
        color: #333;
    }

    .comment-input {
        display: flex;
        gap: 10px;
    }

    .comment-input textarea {
        flex: 1;
        height: 50px;
        border: 1px solid #DDD;
        border-radius: 10px;
        padding: 10px;
        font-size: 14px;
        outline: none;
        resize: none;
    }

    .comment-input button {
        background-color: #FF99AA;
        color: #FFF;
        border: none;
        padding: 10px 20px;
        border-radius: 10px;
        cursor: pointer;
        font-size: 14px;
        transition: background-color 0.3s;
    }

    .comment-input button:hover {
        background-color: #FF6699;
    }

    .comment-list {
        max-height: 250px; /* 댓글 목록 최대 높이 */
        overflow-y: auto; /* 댓글 영역에만 스크롤 */
        display: flex;
        flex-direction: column;
        gap: 10px;
        border-radius: 10px;
        padding: 10px;
        background-color: #FFF8FB;
        margin-right:10px;
    }

    .comment {
        padding: 10px;
        background-color: #FFF;
        border: 1px solid #DDD;
        border-radius: 10px;
        font-size: 14px;
        color: #333;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .comment .comment-id {
        font-weight: bold;
        color: #FF99AA;
    }

    .back-btn {
        background-color: #FF99AA;
        color: #FFF;
        border: none;
        padding: 5px 15px;
        border-radius: 10px;
        cursor: pointer;
        font-size: 12px;
        transition: background-color 0.3s;
        position: absolute; /* 상자 밖으로 내리기 위해 position 사용 */
        bottom: -40px; /* 상자 아래로 내림 */
        right:0%; /* 중앙 정렬 */
        transform: translateX(-50%); /* 버튼을 중앙 정렬 */
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        margin-right:0;
    }

    .back-btn:hover {
        background-color: #FF6699;
    }
</style>
</head>
<body>
    <div class="post-container">
        <div class="post-title">
            제목(ex. 결혼식장은 여기로!)
            <span class="post-id">아이디 표시(ex.1234)</span>
        </div>
        <div class="post-content">
            내용은 여기에...
        </div>

        <!-- 댓글 섹션 -->
        <div class="comment-section">
            <div class="comment-title">댓글</div>
            <div class="comment-input">
                <textarea id="commentInput" placeholder="댓글을 입력하세요"></textarea>
                <button id="addCommentBtn">등록</button>
            </div>
            <div class="comment-list" id="commentList">
                <!-- 댓글이 여기에 추가됩니다 -->
            </div>
        </div>

        <button class="back-btn" onclick="history.back();">뒤로가기</button>
    </div>

    <script>
        const commentList = document.getElementById('commentList');
        const commentInput = document.getElementById('commentInput');
        const addCommentBtn = document.getElementById('addCommentBtn');

        // 댓글 추가 이벤트
        addCommentBtn.addEventListener('click', () => {
            const commentText = commentInput.value.trim();
            const userId = "user1234"; // 임의의 사용자 ID
            
            if (commentText) {
                // 댓글 UI 업데이트
                const comment = document.createElement('div');
                comment.className = 'comment';
                comment.innerHTML = `<span class="comment-id">${userId}</span>: ${commentText}`;
                commentList.prepend(comment); // 댓글 입력창 **아래에** 추가
                
                // 입력창 초기화
                commentInput.value = '';

                // 댓글 목록 스크롤을 가장 아래로 이동
                commentList.scrollTop = commentList.scrollHeight;
            } else {
                alert('댓글 내용을 입력해주세요!');
            }
        });
    </script>
</body>
</html>
