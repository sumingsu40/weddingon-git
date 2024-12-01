<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    // 입력 데이터 처리
    String senderId = request.getParameter("senderId"); // data-user-id
    String companyId = request.getParameter("companyId"); // data-company-id
    String messageText = request.getParameter("messageText"); // 입력 메시지

    System.out.println("sender : " + senderId);
    System.out.println("company : " + companyId);
    System.out.println("text  : " + messageText);

    // 초기화
    Connection conn = null;
    PreparedStatement pstmt = null;
    String responseMessage = "failure"; // 기본 응답 상태

    try {
        // 데이터베이스 연결 설정
        String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String dbUser = "admin";
        String dbPassword = "solution";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // receiver_id를 구하기 위한 쿼리 실행
        String receiverQuery = "SELECT userID FROM users WHERE is_company = 1 AND company_id = ?";
        pstmt = conn.prepareStatement(receiverQuery);
        pstmt.setString(1, companyId);
        ResultSet rs = pstmt.executeQuery();

        int receiverId = -1; // 초기값
        if (rs.next()) {
            receiverId = rs.getInt("userID");
        }
        rs.close();
        pstmt.close();

        if (receiverId != -1) {
            // 메시지 저장 쿼리
            String insertQuery = "INSERT INTO messages (chat_id, sender_id, sender_type, receiver_id, message_text, sent_at) VALUES (?, ?, ?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(insertQuery);

            // 여기서 chat_id는 companyId와 동일하게 사용
            pstmt.setInt(1, Integer.parseInt(companyId)); // chat_id
            pstmt.setInt(2, Integer.parseInt(senderId)); // sender_id
            pstmt.setInt(3, 0); // sender_type = 0 (유저를 나타냄)
            pstmt.setInt(4, receiverId); // receiver_id
            pstmt.setString(5, messageText); // message_text

            int rowsInserted = pstmt.executeUpdate();

            System.out.println(rowsInserted);

            if (rowsInserted > 0) {
                responseMessage = "success";
            }
        } else {
            responseMessage = "company_not_found";
        }
    } catch (Exception e) {
        e.printStackTrace();
        responseMessage = "error: " + e.getMessage();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // 응답 반환
    response.setContentType("text/plain");
    response.getWriter().write(responseMessage);
%>
