const dataContainer = document.getElementById('dataContainer');
const userId = dataContainer.getAttribute('data-user-id');
const companyId = dataContainer.getAttribute('data-company-id');

console.log("User ID:", userId);
console.log("Company ID:", companyId);


// 닫기 버튼 동작
document.getElementById('closePopup').addEventListener('click', () => {
    document.getElementById('chatPopup').style.display = 'none';
});

// 전송 버튼 동작
document.getElementById('sendButton').addEventListener('click', sendMessage);

function sendMessage() {
    const chatInput = document.getElementById('chatInput');
    const chatBody = document.getElementById('chatBody');
    const message = chatInput.value.trim();

    if (message && companyId) {
        const newMessage = document.createElement('div');
        newMessage.className = 'chat-message sent';
        newMessage.textContent = message;
        chatBody.appendChild(newMessage);

        chatInput.value = '';
        chatBody.scrollTop = chatBody.scrollHeight;

        const bodyData = `companyId=${encodeURIComponent(companyId)}&messageText=${encodeURIComponent(message)}&userId=${encodeURIComponent(userId)}`;

        fetch('sendMessage.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            },
            body: bodyData,
        })
        .then(response => response.text())
        .then(data => {
            console.log('서버 응답:', data);
            loadMessages();
        })
        .catch(error => console.error('전송 실패:', error));
    }
}

function loadMessages() {
    const chatId = companyId;
    fetch(`loadMessages.jsp?chatId=${encodeURIComponent(chatId)}`)
        .then(response => response.json())
        .then(data => {
            const chatBody = document.getElementById('chatBody');
            chatBody.innerHTML = '';

            data.forEach(message => {
                const newMessage = document.createElement('div');
                newMessage.className = message.senderId == userId ? 'chat-message sent' : 'chat-message received';
                newMessage.textContent = message.messageText;
                chatBody.appendChild(newMessage);
            });

            chatBody.scrollTop = chatBody.scrollHeight;
        })
        .catch(error => console.error('메시지 로드 실패:', error));
}

setInterval(loadMessages, 2000);
