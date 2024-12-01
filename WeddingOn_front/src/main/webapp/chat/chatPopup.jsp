<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>

<%
    // JSP에서 세션과 요청 값 가져오기
    Integer userIdInteger = (Integer) session.getAttribute("userDbId");
	String userId = userIdInteger != null ? userIdInteger.toString() : null;
	
    String companyId = request.getParameter("companyId");
    
    System.out.println("chat");
    System.out.println("userId : " + userId);
    System.out.println("companyId : " + companyId);
    
%>

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
            <span id="chatCompanyName">
                <%= request.getParameter("companyName") != null ? request.getParameter("companyName") : "업체명" %>
            </span>
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

	<div id="dataContainer" 
     	userid="<%= userId %>" 
     	companyid="<%= companyId != null ? companyId : "" %>">
	</div>


	<script>
			
		document.getElementById('sendButton').addEventListener('click', () => {
		    const dataContainer = document.getElementById('dataContainer');
		    
		    const chatInput = document.getElementById('chatInput'); // 입력 필드
		    const message = chatInput.value.trim(); // 입력된 메시지 가져오기

		    const userId = dataContainer.getAttribute('userid');
		    const companyId = dataContainer.getAttribute('companyid');
		    
		    console.log("Sender ID:", userId);
		    console.log("Company ID:", companyId);
		    console.log("Message:", message);
		    
		    if (!message) {
		        alert('메시지를 입력하세요.');
		        return;
		    }

		    const bodyData = `senderId=`+userId+`&companyId=`+companyId+`&messageText=`+message;

		    fetch('sendMessage.jsp', {
		        method: 'POST',
		        headers: {
		            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
		        },
		        body: bodyData,
		    })
		    .then(response => response.text())
		    
		    .then(data => {
		    	console.log('Received data:', `"`+data+`"`);
		    	
		        if (data.trim() === "success") {
		            console.log('메시지가 성공적으로 저장되었습니다.');
		            chatInput.value = ''; // 메시지 전송 후 입력창 초기화
		            loadMessages(); // 새 메시지 목록 로드
		            
		        } else if (data.trim() === "company_not_found") {
		            alert('기업 정보를 찾을 수 없습니다.');
		        } else {
		            alert('메시지 전송 중 오류가 발생했습니다.');
		        }
		    })
		    .catch(error => console.error('전송 실패:', error));
		});
		
		function loadMessages() {
		    const dataContainer = document.getElementById('dataContainer');
		    const senderId = dataContainer.getAttribute('userid'); // 로그인한 사용자의 ID
		    const companyId = dataContainer.getAttribute('companyid'); // 채팅방의 회사 ID

		    // URL 문자열을 올바르게 연결
		    fetch(`loadMessages.jsp?companyId=`+companyId+`&senderId=`+senderId, {
		        method: 'GET',
		    })
		        .then(response => response.json())
		        .then(data => {
		            const chatBody = document.getElementById('chatBody');
		            chatBody.innerHTML = ''; // 기존 메시지 초기화

		            data.forEach(message => {
		                const newMessage = document.createElement('div');

		                // senderType이 0이면 사용자, 1이면 기업 메시지로 분류
		                if (message.senderType === 0) {
		                    newMessage.className = 'chat-message sent'; // 사용자가 보낸 메시지
		                } else {
		                    newMessage.className = 'chat-message received'; // 기업이 보낸 메시지
		                }

		                newMessage.textContent = message.messageText;
		                chatBody.appendChild(newMessage);
		            });

		            chatBody.scrollTop = chatBody.scrollHeight; // 스크롤을 하단으로 이동
		        })
		        .catch(error => console.error('메시지 로드 실패:', error));
		}


		// 페이지 로드 시 메시지 초기화
		loadMessages();

		// 2초마다 메시지 갱신
		setInterval(loadMessages, 2000);


	
	</script>
	
	

    </body>
</html>
