<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String chatId = request.getParameter("chatId");
    String senderId = request.getParameter("senderId");
    String companyName = request.getParameter("companyName");
    String messageText = request.getParameter("messageText");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    response.setContentType("application/json");
    try {
        String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String dbUser = "admin";
        String dbPassword = "solution";

        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 1. company_id 찾기
        String companyIdQuery = "SELECT userID FROM users WHERE company_id = ?";
        pstmt = conn.prepareStatement(companyIdQuery);
        pstmt.setInt(1, Integer.parseInt(chatId));
        rs = pstmt.executeQuery();

        int receiverId = -1;
        if (rs.next()) {
            receiverId = rs.getInt("userID");
        }
        rs.close();
        pstmt.close();

        if (receiverId == -1) {
            throw new Exception("Receiver ID를 찾을 수 없습니다.");
        }

        // 2. 메시지 저장
        String insertMessageQuery = "INSERT INTO messages (chat_id, sender_id, receiver_id, message_text, sender_type, sent_at) VALUES (?, ?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(insertMessageQuery);
        pstmt.setInt(1, Integer.parseInt(chatId));
        pstmt.setInt(2, Integer.parseInt(senderId));
        pstmt.setInt(3, receiverId);
        pstmt.setString(4, messageText);
        pstmt.setInt(5, 0); // sender_type: 0은 사용자
        int rowCount = pstmt.executeUpdate();

        pstmt.close();

        if (rowCount > 0) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"error\", \"message\":\"메시지 저장 실패\"}");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
