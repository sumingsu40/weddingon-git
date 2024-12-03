<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String chatId = request.getParameter("chatId");
    String senderId = request.getParameter("senderId");
    String messageText = request.getParameter("messageText");
    
    System.out.println("sendmessage chatId : "+chatId);
    System.out.println("sendmessage senderId : "+senderId);
    System.out.println("sendmessage messageText : "+messageText);

    // 요청 파라미터 검증
    if (chatId == null || senderId == null || messageText == null ||
        chatId.isEmpty() || senderId.isEmpty() || messageText.isEmpty()) {
        response.setContentType("application/json");
        response.getWriter().print("{\"status\":\"error\", \"message\":\"Missing parameters\"}");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    response.setContentType("application/json");
    try {
        String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String dbUser = "admin";
        String dbPassword = "solution";

        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Step 1: Receiver ID 가져오기
        String receiverQuery = "SELECT userID FROM users WHERE company_id = ?";
        pstmt = conn.prepareStatement(receiverQuery);
        pstmt.setInt(1, Integer.parseInt(chatId)); // chat_id를 기준으로 company_id와 매칭
        rs = pstmt.executeQuery();

        int receiverId = -1; // Receiver ID 초기화
        if (rs.next()) {
            receiverId = rs.getInt("userID");
        }

        rs.close();
        pstmt.close();

        if (receiverId == -1) {
            throw new Exception("Receiver ID를 찾을 수 없습니다.");
        }

        // Step 2: 메시지 저장
        String insertMessageQuery = "INSERT INTO messages (chat_id, sender_id, receiver_id, message_text, sender_type, sent_at) VALUES (?, ?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(insertMessageQuery);
        pstmt.setInt(1, Integer.parseInt(chatId)); // chat_id
        pstmt.setInt(2, Integer.parseInt(senderId)); // sender_id
        pstmt.setInt(3, receiverId); // receiver_id
        pstmt.setString(4, messageText); // message_text
        pstmt.setInt(5, 0); // sender_type: 0은 사용자
        int rowCount = pstmt.executeUpdate();
        

        pstmt.close();

        // 성공 여부 반환
        if (rowCount > 0) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"error\", \"message\":\"메시지 저장 실패\"}");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
