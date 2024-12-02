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
        let currentSenderId; // 현재 선택된 sender_id를 저장할 변수

        function openChat(chatId, receiverId, companyName) {
            const chatPopup = document.getElementById("chatPopup");
            const companyElement = document.getElementById("chatCompanyName");
            const chatBody = document.getElementById("chatBody");

            // 채팅방 정보 업데이트
            companyElement.textContent = companyName;
            chatBody.innerHTML = ""; // 기존 대화 초기화

            // AJAX 요청
            fetch(`fetchChat.jsp?chatId=`+chatId+`&userId=`+receiverId)
                .then((response) => response.json())
                .then((data) => {
                    if (Array.isArray(data)) {
                        data.forEach((msg) => {
                            const messageDiv = document.createElement("div");
                            messageDiv.className =
                                msg.senderType === 1 ? "chat-message sent" : "chat-message received";
                            messageDiv.textContent = msg.messageText;
                            chatBody.appendChild(messageDiv);
                        });
                        chatBody.scrollTop = chatBody.scrollHeight; // 스크롤 하단 이동
                    }
                })
                .catch((error) => console.error("메시지 로드 실패:", error));

            // 오른쪽 슬라이드 효과로 팝업 표시
            chatPopup.style.transform = "translateX(0)";
        }

        function closeChat() {
            const chatPopup = document.getElementById("chatPopup");
            chatPopup.style.transform = "translateX(100%)"; // 오른쪽으로 숨김
        }

        function sendMessage(receiverId) {
            const chatInput = document.getElementById("chatInput");
            const chatBody = document.getElementById("chatBody");
            const message = chatInput.value.trim();

            if (!message) {
                alert("메시지를 입력하세요.");
                return;
            }

            const dataContainer = document.getElementById("dataContainer");
            const companyId = dataContainer.getAttribute("companyid");
            const senderId = dataContainer.getAttribute("userid");

            fetch("sendMessage.jsp", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                },
                body: `companyId=`+companyId+`&senderId=`+senderId+`&receiverId=`+receiverId+`&messageText=`+message+`&senderType=1`, // senderType: 기업 = 1
            })
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

        
        setInterval(loadMessages, 2000);
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
            int senderId;

            try {
                Integer companyId = (Integer) session.getAttribute("companyId"); // 세션에서 기업 ID 가져오기
                if (companyId == null) {
                	response.sendRedirect("../login/login.jsp");
                    out.println("<p>로그인 후 이용해주세요.</p>");
                    return;
                }
                
                

                // 채팅목록 조회
                String sql = "SELECT m.sender_id, " +
				             "m.chat_id, " +
				             "(SELECT name FROM users WHERE userID = m.sender_id) AS user_name, " +
				             "(SELECT message_text FROM messages WHERE chat_id = m.chat_id AND sender_type = 0 ORDER BY sent_at DESC LIMIT 1) AS last_message " +
				             "FROM messages m " +
				             "WHERE m.receiver_id = ? AND m.sender_type = 0 " +
				             "GROUP BY m.sender_id, m.chat_id " +
				             "ORDER BY MAX(m.sent_at) DESC";


                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, companyId);

                rs = pstmt.executeQuery();
                while (rs.next()) {
                    int chatId = rs.getInt("chat_id");
                    senderId = rs.getInt("sender_id");
                    String userName = rs.getString("user_name");
                    String lastMessage = rs.getString("last_message");
        %>
        <div class="chat_box" onclick="openChat('<%= chatId %>', '<%= senderId %>', '<%= userName %>')">
		    <div class="chat_profile">프로필</div>
		    <div class="chat_company"><%= userName %></div>
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
            <button onclick="sendMessage('<%= session.getAttribute("companyId") %>')">전송</button>
        </div>
    </div>
    
    <div id="dataContainer" 
	     userid="<%= session.getAttribute("userDbId") %>" 
	     companyid="<%= session.getAttribute("companyId") %>">
	</div>
    
    
</body>
</html>
