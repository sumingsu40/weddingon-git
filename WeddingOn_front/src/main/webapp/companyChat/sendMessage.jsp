<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.simple.JSONObject" %>
<%@ page session="true" %>

<%
	response.setContentType("application/json; charset=UTF-8");
    // JSON 응답 객체
    JSONObject jsonResponse = new JSONObject();

    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

     
	
	Integer companyIdInteger = (Integer) session.getAttribute("companyId"); // 회사 ID (sender)
    Integer userDbIdInteger = (Integer) session.getAttribute("userDbId"); // 현재 DB에 저장된 user ID
    
    String companyId = companyIdInteger != null ? companyIdInteger.toString() : null;
    String senderId = userDbIdInteger != null ? userDbIdInteger.toString() : null;
	
	String receiverId = request.getParameter("receiverId"); // 받을 사용자 ID (파라미터로 전달) 
	String messageText = request.getParameter("messageText"); // 메시지 내용
	
	System.out.println("chatId: " + companyId);
	System.out.println("senderId: " + senderId);
	System.out.println("receiverId: " + receiverId);
	System.out.println("messageText: " + messageText);

	
	// 필수 파라미터 확인
	if (companyId == null || senderId == null || receiverId == null || messageText == null ||
	    companyId.isEmpty() || senderId.isEmpty() || receiverId.isEmpty() || messageText.isEmpty()) {
	    jsonResponse.put("status", "error");
	    jsonResponse.put("message", "Missing required parameters");
	    response.getWriter().write(jsonResponse.toJSONString());
	    return;
	}
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try {
	    // 데이터베이스 연결
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
	
	    // 메시지 저장 쿼리
	    String sql = "INSERT INTO messages (chat_id, sender_id, receiver_id, message_text, sender_type, sent_at) " +
	                 "VALUES (?, ?, ?, ?, ?, NOW())";
	
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setInt(1, Integer.parseInt(companyId)); // chat_id는 회사 ID
	    pstmt.setInt(2, Integer.parseInt(senderId));  // sender_id는 현재 DB의 user ID
	    pstmt.setInt(3, Integer.parseInt(receiverId)); // receiver_id는 사용자가 전달한 ID
	    pstmt.setString(4, messageText);             // 메시지 내용
	    pstmt.setInt(5, 1);                          // sender_type: 1 (기업)
	
	    int rowsInserted = pstmt.executeUpdate();
	
	    if (rowsInserted > 0) {
	        jsonResponse.put("status", "success");
	        jsonResponse.put("message", "Message sent successfully");
	    } else {
	        jsonResponse.put("status", "error");
	        jsonResponse.put("message", "Failed to send message");
	    }
	} catch (Exception e) {
	    e.printStackTrace();
	    jsonResponse.put("status", "error");
	    jsonResponse.put("message", "Server error occurred: " + e.getMessage());
	} finally {
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	}
	
	// 응답 반환
	response.setContentType("application/json; charset=UTF-8");
	response.getWriter().write(jsonResponse.toJSONString());
%>


	