<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>채팅방</title>
    <link rel="stylesheet" href="chat.css">
    <script>
        function openChat(chatName, companyName) {
            const chatPopup = document.getElementById("chatPopup");
            const companyElement = document.getElementById("chatCompanyName");

            // 동적으로 채팅방 정보 업데이트
            companyElement.textContent = companyName;

            // 오른쪽 슬라이드 효과로 팝업 표시
            chatPopup.style.transform = "translateX(0)";
        }

        function closeChat() {
            const chatPopup = document.getElementById("chatPopup");

            // 오른쪽 슬라이드 효과로 팝업 숨김
            chatPopup.style.transform = "translateX(100%)";
        }

        function sendMessage() {
            const chatInput = document.getElementById("chatInput");
            const chatBody = document.getElementById("chatBody");
            const message = chatInput.value.trim();

            if (message) {
                // 전송된 메시지 추가
                const newMessage = document.createElement("div");
                newMessage.className = "chat-message sent";
                newMessage.textContent = message;
                chatBody.appendChild(newMessage);

                // 입력 필드 초기화
                chatInput.value = "";
                chatBody.scrollTop = chatBody.scrollHeight; // 스크롤 하단 이동
            }
        }
    </script>
</head>
<body>
    <h1>채팅목록</h1>
    <div class="chat-list">
        <% 
            // 데이터베이스 연결 정보
            String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
            String dbUser = "admin";
            String dbPassword = "solution";

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // 세션에서 userDbId 가져오기
                Integer userDbId = (Integer) session.getAttribute("userDbId");
                if (userDbId == null) {
                    out.println("<p>로그인 후 이용해주세요.</p>");
                    return;
                }

                // 데이터베이스 연결
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // sender_id가 userDbId이고, sender_type이 0인 chat_id 기준으로 고유한 채팅목록 가져오기
                String sql = "SELECT DISTINCT m.chat_id, " +
                             "       m.receiver_id, " +
                             "       (SELECT name FROM users WHERE userID = m.receiver_id) AS company_name, " +
                             "       (SELECT message_text FROM messages WHERE chat_id = m.chat_id ORDER BY sent_at DESC LIMIT 1) AS last_message " +
                             "FROM messages m " +
                             "WHERE m.sender_id = ? AND m.sender_type = 0 " +
                             "GROUP BY m.chat_id " +
                             "ORDER BY MAX(m.sent_at) DESC";
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
                <img src="../../images/chat.png" alt="채팅 아이콘">
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
        <div class="chat-body" id="chatBody">
            <div class="chat-message received">안녕하세요! 무엇을 도와드릴까요?</div>
        </div>
        <div class="chat-footer">
            <input type="text" id="chatInput" placeholder="대화 입력창">
            <button id="sendButton" onclick="sendMessage()">전송</button>
        </div>
    </div>
</body>
</html>
