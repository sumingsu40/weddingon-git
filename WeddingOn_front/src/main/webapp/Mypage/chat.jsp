<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <div class="chat_box" onclick="openChat('웨딩업체', '00 웨딩 업체')">
        <div class="chat_profile">프로필</div>
        <div class="chat_company">00 웨딩 업체</div>
        <div class="chat_message">고객님 00일로 예약되었습니다~! 그때 뵙도록 하겠습니다.</div>
    </div>
    <div class="chat_box" onclick="openChat('메이크업스튜디오', '00 메이크업 스튜디오')">
        <div class="chat_profile">프로필</div>
        <div class="chat_company">00 메이크업 스튜디오</div>
        <div class="chat_message">고객님 00일로 예약되었습니다~! 그때 뵙도록 하겠습니다.</div>
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

