<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅창 팝업</title>
    <link rel="stylesheet" type="text/css" href="chatPopup.css">
</head>
<body>
    <!-- 채팅창 팝업 -->
    <div id="chatPopup" class="chat-popup">
        <div class="chat-header">
            <span id="chatCompanyName"><%= request.getParameter("companyName") != null ? request.getParameter("companyName") : "업체명" %></span>
            <button id="closePopup" class="close-btn">X</button>
        </div>
        <div class="chat-body" id="chatBody">
            <div class="chat-message received">안녕하세요! 무엇을 도와드릴까요?</div>
        </div>
        <div class="chat-footer">
            <input type="text" id="chatInput" class="chat-input" placeholder="대화 입력창">
            <button id="sendButton" class="send-btn">전송</button>
        </div>
    </div>

    <script>
        // 닫기 버튼 동작
        document.getElementById('closePopup').addEventListener('click', () => {
            document.getElementById('chatPopup').style.display = 'none';
        });

        // 전송 버튼 동작
        document.getElementById('sendButton').addEventListener('click', sendMessage);

        // 메시지 전송 함수
        function sendMessage() {
            const chatInput = document.getElementById('chatInput');
            const chatBody = document.getElementById('chatBody');
            const message = chatInput.value.trim();

            if (message) {
                // 전송된 메시지 추가
                const newMessage = document.createElement('div');
                newMessage.className = 'chat-message sent';
                newMessage.textContent = message;
                chatBody.appendChild(newMessage);

                // 입력 필드 초기화
                chatInput.value = '';
                chatBody.scrollTop = chatBody.scrollHeight; // 스크롤 하단 이동
            }
        }
    </script>
</body>
</html>
