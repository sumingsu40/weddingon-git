<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" href="../images/icon.png">
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
	    white-space: pre-line; /* 줄바꿈 유지 */
	    padding-top: 10px;
	    max-height: 300px;
	    overflow-y: auto; /* 내용이 많을 경우 세로 스크롤 */
	    word-wrap: break-word; /* 긴 단어를 줄바꿈 */
	    overflow-wrap: break-word; /* 긴 단어를 줄바꿈 */
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

	<%
        // 데이터베이스 연결 정보
        String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String dbUser = "admin";
        String dbPassword = "solution";

        Connection conn = null;
        PreparedStatement pstmtPost = null;
        PreparedStatement pstmtComments = null;
        ResultSet rsPost = null;
        ResultSet rsComments = null;

        // postId 파라미터 읽기
        String postIdParam = request.getParameter("postId");
        int postId = 0;
        if (postIdParam != null) {
            try {
                postId = Integer.parseInt(postIdParam);
            } catch (NumberFormatException e) {
                out.println("<h3>잘못된 요청입니다.</h3>");
            }
        }

        String postTitle = "제목을 불러오는 중...";
        String postContent = "내용을 불러오는 중...";
        String postAuthor = "작성자 정보를 불러오는 중...";
        
        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // 게시글 데이터 가져오기
            String sqlPost = "SELECT p.title, p.content, u.id AS user_id " +
			                 "FROM posts p " +
			                 "JOIN users u ON p.user_id = u.userID " +
			                 "WHERE p.post_id = ?";

            pstmtPost = conn.prepareStatement(sqlPost);
            pstmtPost.setInt(1, postId);
            rsPost = pstmtPost.executeQuery();

            if (rsPost.next()) {
                postTitle = rsPost.getString("title");
                postContent = rsPost.getString("content");
                postAuthor = rsPost.getString("user_id");
            } else {
                postTitle = "게시글을 찾을 수 없습니다.";
                postContent = "요청하신 게시글이 존재하지 않습니다.";
            }

            // 댓글 데이터 가져오기
            String sqlComments = "SELECT u.id AS user_id, c.content, DATE_FORMAT(c.created_at, '%Y-%m-%d %H:%i:%s') AS created_at " +
			                    "FROM comments c " +
			                    "JOIN users u ON c.user_id = u.userID " +
			                    "WHERE c.post_id = ? " +
			                    "ORDER BY c.created_at DESC";
			pstmtComments = conn.prepareStatement(sqlComments);
			pstmtComments.setInt(1, postId);
			rsComments = pstmtComments.executeQuery();
        } catch (Exception e) {
            e.printStackTrace();
            postTitle = "오류 발생";
            postContent = "게시글 데이터를 불러오는 중 오류가 발생했습니다.";
        }
    %>

    <div class="post-container">
        <div class="post-title">
            <%= postTitle %>
            <span class="post-id">작성자 : <%= postAuthor %></span>
        </div>
        <div class="post-content">
            <%= postContent %>
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
                <%
                    try {
                        while (rsComments.next()) {
                        	String userId = rsComments.getString("user_id"); // users 테이블의 id 값
                            String commentContent = rsComments.getString("content");
                            String createdAt = rsComments.getString("created_at");
                %>
                <div class="comment">
                    <span class="comment-id"><%= userId %></span> : <%= commentContent %>
                    <br>
                    <small>작성일: <%= createdAt %></small>
                </div>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        if (rsComments != null) try { rsComments.close(); } catch (SQLException ignored) {}
                        if (pstmtComments != null) try { pstmtComments.close(); } catch (SQLException ignored) {}
                        if (rsPost != null) try { rsPost.close(); } catch (SQLException ignored) {}
                        if (pstmtPost != null) try { pstmtPost.close(); } catch (SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                    }
                %>
            </div>
        </div>

        <button class="back-btn" onclick="history.back();">뒤로가기</button>
    </div>

    <script>
	    const addCommentBtn = document.getElementById('addCommentBtn');
	    const commentInput = document.getElementById('commentInput');
	    const commentList = document.getElementById('commentList');
	    const postId = "<%= postId %>"; // JSP에서 전달된 postId
	
	    addCommentBtn.addEventListener('click', async () => {
	        const commentText = commentInput.value.trim();
	        if (!commentText) {
	            alert('댓글 내용을 입력해주세요!');
	            return;
	        }

	        try {
	            // 서버로 댓글 데이터 전송
	            const response = await fetch('addComment.jsp', {
	                method: 'POST',
	                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	                body: `postId=`+postId+`&content=`+commentText
	            });

	            if (!response.ok) throw new Error('Network response was not ok');

	            const result = await response.json();
	            
	            console.log(result);
	            
	            if (result.status === 'success') {
	            	const comment = document.createElement('div');
	                comment.className = 'comment';
	                comment.innerHTML = `
	                    <span class="comment-id">`+result.userId+`</span>: `+result.content+`
	                    <br>
	                    <small>작성일: `+result.createdAt+`</small>
	                `;

	                commentList.prepend(comment);	
	                
	                commentInput.value = '';
	            } else {
	                console.error("댓글 추가 실패:", result.message);
	            }
	            
	        } catch (error) {
	            console.error('Error:', error);
	            alert('댓글 등록 중 오류가 발생했습니다.');
	        }
	    });

    </script>
</body>
</html>
