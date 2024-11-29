document.addEventListener("DOMContentLoaded", () => {
    const chatMessages = document.getElementById("chatMessages");
    const messageInput = document.getElementById("messageInput");
    const sendButton = document.getElementById("sendButton");

    // 서버에서 메시지 가져오기
    async function fetchMessages() {
        try {
            const response = await fetch("getMessages.jsp?chat_id=1"); // chat_id를 동적으로 변경
            const messages = await response.json();

            // 메시지 표시
            chatMessages.innerHTML = "";
            messages.forEach(msg => {
                const messageDiv = document.createElement("div");
                messageDiv.classList.add("message");
                messageDiv.classList.add(msg.sender_id === 1 ? "sender" : "receiver");
                messageDiv.textContent = msg.message_text;
                chatMessages.appendChild(messageDiv);
            });

            // 스크롤을 가장 아래로
            chatMessages.scrollTop = chatMessages.scrollHeight;
        } catch (error) {
            console.error("Error fetching messages:", error);
        }
    }

    // 메시지 전송
    async function sendMessage() {
        const message = messageInput.value.trim();
        if (!message) return;

        try {
            await fetch("sendMessage.jsp", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                },
                body: `chat_id=1&message_text=${encodeURIComponent(message)}`,
            });

            messageInput.value = ""; // 입력창 초기화
            fetchMessages(); // 메시지 다시 가져오기
        } catch (error) {
            console.error("Error sending message:", error);
        }
    }

    // 초기 메시지 가져오기
    fetchMessages();

    // 전송 버튼 클릭 이벤트
    sendButton.addEventListener("click", sendMessage);

    // Enter 키로 전송
    messageInput.addEventListener("keydown", (event) => {
        if (event.key === "Enter" && !event.shiftKey) {
            event.preventDefault();
            sendMessage();
        }
    });
});
