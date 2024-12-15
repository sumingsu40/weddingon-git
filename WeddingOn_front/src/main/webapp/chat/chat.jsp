<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채팅목록</title>
    <link rel="stylesheet" href="chat.css">
</head>
<body>
    <h1>채팅목록</h1>
    <div class="chat-list">
        <%
        	String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
		    String dbUser = "admin";
		    String dbPassword = "solution";
		
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmt2 = null; // 추가된 PreparedStatement
		    ResultSet rs = null;
		    ResultSet rs2 = null; // 추가된 ResultSet
		
		    try {
		        // 세션에서 로그인된 사용자 ID 가져오기
		        Integer userDbId = (Integer) session.getAttribute("userDbId");

		        if (userDbId == null) {
		            response.sendRedirect("../login/login.jsp");
		            out.println("<p>로그인 후 이용해주세요.</p>");
		            return;
		        }
		        
		
		        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
		
		        // 첫 번째 쿼리 실행
		        String sql = "SELECT DISTINCT m.chat_id, " +
		                     "       c.company_name, " +
		                     "       (SELECT message_text FROM messages WHERE chat_id = m.chat_id AND sender_type = 0 ORDER BY sent_at DESC LIMIT 1) AS last_message, " +
		                     "       MAX(m.sent_at) AS latest_message_time " +
		                     "FROM messages m " +
		                     "JOIN companies c ON m.chat_id = c.company_id " +
		                     "WHERE m.sender_id = ? AND m.sender_type = 0 " +
		                     "GROUP BY m.chat_id, c.company_name " +
		                     "ORDER BY latest_message_time DESC";
		
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, userDbId);
		        rs = pstmt.executeQuery();
		
		        while (rs.next()) {
		            int chatId = rs.getInt("chat_id");
		            String companyName = rs.getString("company_name");
		            String lastMessage = rs.getString("last_message");
		            String receiverId = null;
		
		            // 두 번째 쿼리 실행
		            String receiverQuery = "SELECT userID FROM users WHERE company_id = ?";
		            pstmt2 = conn.prepareStatement(receiverQuery); // 새 PreparedStatement 사용
		            pstmt2.setInt(1, chatId);
		            rs2 = pstmt2.executeQuery(); // 새 ResultSet 사용
		
		            if (rs2.next()) {
		                receiverId = rs2.getString("userID");
		            }
		
		            // JSP 출력
		%>
		            <div class="chat_box" onclick="openChat('<%= chatId %>', '<%= userDbId %>', '<%= companyName %>')">
		                <div class="chat_profile">프로필</div>
		                <div class="chat_company"><%= companyName %></div>
		                <div class="chat_message"><%= lastMessage != null ? lastMessage : "메시지가 없습니다." %></div>
		            </div>
		<%
		            // 두 번째 ResultSet과 PreparedStatement 닫기
		            if (rs2 != null) rs2.close();
		            if (pstmt2 != null) pstmt2.close();
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        out.println("<p>채팅 목록을 불러오는 중 오류가 발생했습니다.</p>");
		    } finally {
		        // 모든 자원 닫기
		        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
		        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
		        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
		    }
		%>

    </div>

    <!-- 채팅 팝업 -->
    <div id="chatPopup" class="chat-popup">
        <div class="chat-header">
            <span id="chatCompanyName">업체명</span>
            <button onclick="closeChat()">X</button>
        </div>
        <div class="chat-body" id="chatBody"></div>
        <div class="chat-footer">
            <input type="text" id="chatInput" placeholder="메시지를 입력하세요">
            <button id="sendButton" class="send-btn">전송</button>
        </div>
    </div>
    
    <div id="dataContainer" 
         userid="<%= session.getAttribute("userDbId") %>" 
         companyid="<%= session.getAttribute("companyId") %>">
    </div>
    
    <script>
	    let isChatOpen = false; // 채팅창 상태

    
        function openChat(chatId, receiverId, companyName) {
            const chatPopup = document.getElementById("chatPopup");
            const companyElement = document.getElementById("chatCompanyName");
            const chatBody = document.getElementById("chatBody");

            // 채팅방 정보 업데이트
            companyElement.textContent = companyName;
            chatBody.innerHTML = ""; // 기존 대화 초기화
            dataContainer.setAttribute("chatid", chatId);

            // 메시지 로드
            fetch(`fetchChatMessages.jsp?chatId=`+chatId+`&userId=`+receiverId)
                .then((response) => response.json())
                .then((data) => {
                    if (Array.isArray(data)) {
                        data.forEach((msg) => {
                            const messageDiv = document.createElement("div");
                            messageDiv.className =
                                msg.senderType === 0 ? "chat-message sent" : "chat-message received";
                            messageDiv.textContent = msg.messageText;
                            chatBody.appendChild(messageDiv);
                        });
                        chatBody.scrollTop = chatBody.scrollHeight; // 스크롤 하단 이동
                    }
                })
                .catch((error) => console.error("메시지 로드 실패:", error));

            // 팝업 표시
            chatPopup.style.transform = "translateX(0)";
            isChatOpen = true; // 채팅창이 열려 있음
        }

        function closeChat() {
            const chatPopup = document.getElementById("chatPopup");
            chatPopup.style.transform = "translateX(100%)"; // 오른쪽으로 숨김
            isChatOpen = false; // 채팅창이 닫혀 있음
        }
        
        document.getElementById('sendButton').addEventListener('click', () => {
            const dataContainer = document.getElementById('dataContainer');
            const chatInput = document.getElementById('chatInput');
            const message = chatInput.value.trim();

            const userId = dataContainer.getAttribute('userid');
            const companyId = dataContainer.getAttribute('companyid');
            const receiverId = dataContainer.getAttribute('receiverid');
            const chatId = dataContainer.getAttribute('chatid'); // chatId 가져오기
            
            //console.log('chat'+chatId);

            if (!message) {
                alert('메시지를 입력하세요.');
                return;
            }
            
            //console.log(companyId);

            fetch('sendMessage.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                },
                body: `senderId=`+userId+`&receiverId=`+receiverId+`&chatId=`+chatId+`&messageText=`+message, })
            .then(response => response.json())
            .then(data => {
            	console.log(data);
                if (data.status === "success") {
                    chatInput.value = '';
                    loadMessages();
                } else {
                    alert('메시지 전송 중 오류가 발생했습니다.');
                }
            })
            .catch(error => console.error('전송 실패:', error));
        });
        
        function loadMessages() {
            const dataContainer = document.getElementById('dataContainer');
            const senderId = dataContainer.getAttribute('userid');
            const companyId = dataContainer.getAttribute('companyid');
            const chatId = dataContainer.getAttribute('chatid'); // chatId 가져오기

            fetch(`loadMessages.jsp?companyId=`+chatId+`&senderId=`+senderId)
                .then(response => response.json())
                .then(data => {
                    const chatBody = document.getElementById('chatBody');
                    chatBody.innerHTML = '';

                    data.forEach(message => {
                        const newMessage = document.createElement('div');
                        newMessage.className = message.senderType === 0 ? 'chat-message sent' : 'chat-message received';
                        newMessage.textContent = message.messageText;
                        chatBody.appendChild(newMessage);
                    });

                    chatBody.scrollTop = chatBody.scrollHeight;
                })
                .catch(error => console.error('메시지 로드 실패:', error));
        }
                
        setInterval(() => {
            if (isChatOpen) {
                loadMessages();
            }
        }, 2000);


    </script>
    
</body>
</html>
