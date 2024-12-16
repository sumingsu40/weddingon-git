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
    <title>기업용 팝업</title>
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
     	data-user-id="<%= userId %>" 
     	data-company-id="<%= companyId != null ? companyId : "" %>">
	</div>


	<script src="chatPopup.js"></script>
	
	

    </body>
</html>
