<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>

<%
    // 세션 값 가져오기
    Integer userIdInteger = (Integer) session.getAttribute("userDbId");
    String userId = userIdInteger != null ? userIdInteger.toString() : null;
    String companyId = request.getParameter("company_id");

    String companyName = "업체명"; // 기본값
    String receiverId = null;

    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    if (companyId != null && !companyId.isEmpty()) {
        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
            // 회사 이름 가져오기
            String sql = "SELECT company_name FROM companies WHERE company_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, companyId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        companyName = rs.getString("company_name");
                    }
                }
            }

            // receiverId 가져오기
            String receiverQuery = "SELECT userID FROM users WHERE company_id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(receiverQuery)) {
                pstmt.setString(1, companyId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        receiverId = rs.getString("userID");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="../images/icon.png">
    <title>채팅창 팝업</title>
    <link rel="stylesheet" type="text/css" href="chatPopup.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>
    <!-- 채팅창 팝업 -->
    <div id="chatPopup" class="chat-popup">
        <div class="chat-header">
            <span id="chatCompanyName">
                <%= companyName %>
            </span>
        </div>
        <div class="chat-body" id="chatBody">
            <div class="chat-message received">안녕하세요! 무엇을 도와드릴까요?</div>
        </div>
        <div class="chat-footer">
            <input type="text" id="chatInput" class="chat-input" placeholder="대화 입력창">
            <button id="sendButton" class="send-btn">전송</button>
        </div>
    </div>

    <div id="dataContainer" 
        userid="<%= userId %>" 
        companyid="<%= companyId %>" 
        receiverid="<%= receiverId %>">
    </div>

   <script>
    let isUserScrolling = false; // 스크롤 상태 플래그 추가

    // 채팅창 스크롤 이벤트: 사용자가 스크롤 중인지 감지
    document.getElementById('chatBody').addEventListener('scroll', () => {
        isUserScrolling = true;
        setTimeout(() => {
            isUserScrolling = false; // 1.5초 후 플래그 초기화
        }, 1500);
    });

    document.getElementById('sendButton').addEventListener('click', () => {
        const dataContainer = document.getElementById('dataContainer');
        const chatInput = document.getElementById('chatInput');
        const message = chatInput.value.trim();

        const userId = dataContainer.getAttribute('userid');
        const companyId = dataContainer.getAttribute('companyid');
        const receiverId = dataContainer.getAttribute('receiverid');

        if (!message) {
            alert('메시지를 입력하세요.');
            return;
        }

        fetch('sendMessage.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            },
            body: `senderId=` + userId + `&receiverId=` + receiverId + `&chatId=` + companyId + `&messageText=` + message,
        })
        .then(response => response.json())
        .then(data => {
            console.log(data);
            if (data.status === "success") {
                chatInput.value = '';
                loadMessages(); // 메시지 전송 후 메시지 불러오기
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

        fetch(`loadMessages.jsp?companyId=` + companyId + `&senderId=` + senderId)
            .then(response => response.json())
            .then(data => {
                const chatBody = document.getElementById('chatBody');

                // 현재 스크롤 위치 저장
                const previousScrollHeight = chatBody.scrollHeight;

                // 기존 메시지 초기화
                chatBody.innerHTML = '';

                data.forEach(message => {
                    const newMessage = document.createElement('div');
                    newMessage.className = message.senderType === 0 ? 'chat-message sent' : 'chat-message received';
                    newMessage.textContent = message.messageText;
                    chatBody.appendChild(newMessage);
                });

                // 스크롤 제어: 사용자가 스크롤 중이 아닐 때만 맨 아래로 이동
                if (!isUserScrolling) {
                    chatBody.scrollTop = chatBody.scrollHeight;
                }
            })
            .catch(error => console.error('메시지 로드 실패:', error));
    }

    // 페이지 로드 시 초기 메시지 로드
    loadMessages();

    // 2초마다 메시지 갱신
    setInterval(loadMessages, 2000);
</script>

</body>
</html>
