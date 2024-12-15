<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page session="true" %>

<%
    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    String chatId = request.getParameter("chatId");
    JSONArray messages = new JSONArray();

    if (chatId == null || chatId.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", "chatId is required");
        out.print(errorResponse.toJSONString());
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 연결
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 메시지 조회 쿼리
        String sql = "SELECT sender_id, receiver_id, message_text, sender_type, sent_at " +
                     "FROM messages " +
                     "WHERE chat_id = ? " +
                     "ORDER BY sent_at ASC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(chatId));
        rs = pstmt.executeQuery();

        // 결과를 JSON으로 변환
        while (rs.next()) {
            JSONObject message = new JSONObject();
            message.put("senderId", rs.getInt("sender_id"));
            message.put("receiverId", rs.getInt("receiver_id"));
            message.put("messageText", rs.getString("message_text"));
            message.put("senderType", rs.getInt("sender_type"));
            message.put("sentAt", rs.getTimestamp("sent_at").toString());
            messages.add(message);
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", "Failed to fetch messages");
        out.print(errorResponse.toJSONString());
        return;
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    // JSON 응답
    out.print(messages.toJSONString());
%>
