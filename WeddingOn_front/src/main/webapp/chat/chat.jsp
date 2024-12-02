<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채팅목록</title>
    <link rel="stylesheet" href="chat.css">
    <script>
	    function openChat(chatId, companyName) {
	        const chatPopup = document.getElementById("chatPopup");
	        const companyElement = document.getElementById("chatCompanyName");
	        const chatBody = document.getElementById("chatBody");
	
	        // 현재 로그인한 사용자 ID 가져오기
	        const currentUserId = document.getElementById("dataContainer").getAttribute("userid");
	
	        // 채팅방 정보 업데이트
	        companyElement.textContent = companyName;
	        chatBody.innerHTML = ""; // 기존 대화 초기화
	
	        // 서버에서 메시지 로드
	        fetch(`fetchChatMessages.jsp?chatId=` + chatId)
	            .then(response => response.json())
	            .then(data => {
	                if (Array.isArray(data)) {
	                    data.forEach(message => {
	                        const messageDiv = document.createElement("div");
	                        // 현재 사용자와 메시지의 sender_id를 비교하여 sent/received를 결정
	                        messageDiv.className = message.senderId == currentUserId ? "chat-message sent" : "chat-message received";
	                        messageDiv.textContent = message.messageText;
	                        chatBody.appendChild(messageDiv);
	                    });
	                    chatBody.scrollTop = chatBody.scrollHeight; // 스크롤 하단 이동
	                }
	            })
	            .catch(error => console.error("메시지 로드 실패:", error));
	
	        // 팝업 표시
	        chatPopup.style.transform = "translateX(0)";
	    }
	    
	    function sendMessage(chatId, companyName) {
	        const chatInput = document.getElementById("chatInput");
	        const chatBody = document.getElementById("chatBody");
	        const message = chatInput.value.trim();

	        if (!message) {
	            alert("메시지를 입력하세요.");
	            return;
	        }

	        const currentUserId = document.getElementById("dataContainer").getAttribute("userid");

	        // 서버로 메시지 전송
	        fetch("sendMessage.jsp", {
	            method: "POST",
	            headers: {
	                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
	            },
	            body: `chatId=`+chatId+`&senderId=`+currentUserId+`&companyName=`+companyName+`&messageText=`+message, })
	            .then((response) => response.json())
	            .then((result) => {
	                if (result.status === "success") {
	                    const newMessage = document.createElement("div");
	                    newMessage.className = "chat-message sent";
	                    newMessage.textContent = message;
	                    chatBody.appendChild(newMessage);

	                    chatInput.value = ""; // 입력 필드 초기화
	                    chatBody.scrollTop = chatBody.scrollHeight; // 스크롤 하단 이동
	                } else {
	                    alert("메시지 전송 실패: " + result.message);
	                }
	            })
	            .catch((error) => console.error("메시지 전송 실패:", error));
	    }


        function closeChat() {
            const chatPopup = document.getElementById("chatPopup");
            chatPopup.style.transform = "translateX(100%)"; // 오른쪽으로 숨김
        }
    </script>
</head>
<body>
    <h1>채팅목록</h1>
    <div class="chat-list">
        <% 
            String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
            String dbUser = "admin";
            String dbPassword = "solution";

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Integer userDbId = (Integer) session.getAttribute("userDbId");
                if (userDbId == null) {
                    out.println("<p>로그인 후 이용해주세요.</p>");
                    return;
                }

                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // sender_type이 1이고, chat_id가 고유한 목록을 가져오기
                String sql = "SELECT DISTINCT m.chat_id, " +
                             "       c.company_name, " +
                             "       (SELECT message_text FROM messages WHERE chat_id = m.chat_id ORDER BY sent_at DESC LIMIT 1) AS last_message, " +
                             "       MAX(m.sent_at) AS latest_message_time " +
                             "FROM messages m " +
                             "JOIN companies c ON m.chat_id = c.company_id " +
                             "WHERE m.receiver_id = ? AND m.sender_type = 1 " +
                             "GROUP BY m.chat_id, c.company_name " +
                             "ORDER BY latest_message_time DESC";

                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userDbId);

                rs = pstmt.executeQuery();

                // 채팅 목록 렌더링
                while (rs.next()) {
                    int chatId = rs.getInt("chat_id");
                    String companyName = rs.getString("company_name");
                    String lastMessage = rs.getString("last_message");
        %>
        <div class="chat_box" onclick="openChat('<%= chatId %>', '<%= companyName %>')">
		    <div class="chat_profile">
		        <img src="../images/chat.png" alt="채팅 아이콘">
		    </div>
		    <div class="chat_company"><%= companyName %></div>
		    <div class="chat_message"><%= lastMessage != null ? lastMessage : "메시지가 없습니다." %></div>
		</div>

        <% 
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>

    <!-- 오른쪽 고정 팝업 -->
    <div id="chatPopup" class="chat-popup">
        <div class="chat-header">
            <span id="chatCompanyName">업체명</span>
            <button onclick="closeChat()">X</button>
        </div>
        <div class="chat-body" id="chatBody"></div>
        <div class="chat-footer">
            <input type="text" id="chatInput" placeholder="메시지를 입력하세요">
            <button onclick="sendMessage('<%= session.getAttribute("userDbId") %>')">전송</button>
        </div>
    </div>
    
    <div id="dataContainer" userid="<%= session.getAttribute("userDbId") %>" companyid="<%= session.getAttribute("companyId") %>"></div>
    
</body>
</html>
