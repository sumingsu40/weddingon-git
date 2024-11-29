<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%@ page session="true" %>

<%
    String chatId = request.getParameter("chat_id");
    String messageText = request.getParameter("message_text");

    // 파라미터 검증
    if (chatId == null || chatId.trim().isEmpty() || messageText == null || messageText.trim().isEmpty()) {
        out.print("Invalid parameters");
        return;
    }

    int chatIdInt;
    try {
        chatIdInt = Integer.parseInt(chatId);
    } catch (NumberFormatException e) {
        out.print("Invalid chat_id format");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // 데이터베이스 연결
        String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
	    String dbUser = "admin";
	    String dbPassword = "solution";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 메시지 저장 쿼리
        String sql = "INSERT INTO messages (chat_id, sender_id, message_text, sent_at) VALUES (?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, chatIdInt);
        pstmt.setInt(2, 1); // sender_id는 예시로 1로 고정
        pstmt.setString(3, messageText);

        int rows = pstmt.executeUpdate();
        if (rows > 0) {
            out.print("Message sent successfully");
        } else {
            out.print("Failed to send message");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("Error occurred");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
