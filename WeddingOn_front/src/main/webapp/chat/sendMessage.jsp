<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    response.setContentType("application/json; charset=UTF-8");

    Connection conn = null;
    PreparedStatement pstmt = null;

    String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    try {
        Integer userIdInteger = (Integer) session.getAttribute("userDbId");
        if (userIdInteger == null) {
            response.getWriter().println("{\"status\":\"error\", \"message\":\"User not authenticated\"}");
            return;
        }
        String userId = userIdInteger.toString();
        String companyId = request.getParameter("companyId");
        String messageText = request.getParameter("messageText");
        String receiverId = request.getParameter("receiverId");

        if (receiverId == null || receiverId.trim().isEmpty()) {
            receiverId = "1"; // 기본값 설정
        }

        if (userId == null || companyId == null || messageText == null || messageText.trim().isEmpty()) {
            response.getWriter().println("{\"status\":\"error\", \"message\":\"Invalid input data\"}");
            return;
        }

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "INSERT INTO messages (chat_id, sender_id, receiver_id, message_text, sent_at) VALUES (?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sql);

        pstmt.setInt(1, Integer.parseInt(companyId));
        pstmt.setInt(2, Integer.parseInt(userId));
        pstmt.setInt(3, Integer.parseInt(receiverId));
        pstmt.setString(4, messageText);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            response.getWriter().println("{\"status\":\"success\", \"message\":\"Message sent successfully\"}");
        } else {
            response.getWriter().println("{\"status\":\"error\", \"message\":\"Message sending failed\"}");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.getWriter().println("{\"status\":\"error\", \"message\":\"Database error occurred. Please try again later.\"}");
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().println("{\"status\":\"error\", \"message\":\"Unexpected error occurred.\"}");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
