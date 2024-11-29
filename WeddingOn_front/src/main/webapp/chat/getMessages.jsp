<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.sql.*, org.json.JSONArray, org.json.JSONObject" %>

<%
    // 파라미터 가져오기
    String chatIdParam = request.getParameter("chat_id");
    JSONArray messages = new JSONArray();

    // 파라미터 검증
    if (chatIdParam == null || chatIdParam.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"error\":\"Missing or invalid chat_id parameter\"}");
        return;
    }

    int chatId;
    try {
        chatId = Integer.parseInt(chatIdParam);
    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"error\":\"Invalid chat_id format\"}");
        return;
    }

    // 데이터베이스 변수
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 연결
        String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
	    String dbUser = "admin";
	    String dbPassword = "solution";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 메시지 가져오기 쿼리
        String sql = "SELECT sender_id, receiver_id, message_text, sent_at FROM messages WHERE chat_id = ? ORDER BY sent_at ASC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, chatId);
        rs = pstmt.executeQuery();

        // 결과를 JSON 배열에 추가
        while (rs.next()) {
            JSONObject message = new JSONObject();
            message.put("sender_id", rs.getInt("sender_id"));
            message.put("receiver_id", rs.getInt("receiver_id"));
            message.put("message_text", rs.getString("message_text"));
            message.put("sent_at", rs.getString("sent_at"));
            messages.put(message);
        }

        // JSON 데이터 반환
        response.setContentType("application/json; charset=UTF-8");
        out.print(messages.toString());
    } catch (Exception e) {
        // 에러 출력
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", "An error occurred while retrieving messages");
        errorResponse.put("details", e.getMessage());
        out.print(errorResponse.toString());
        e.printStackTrace();
    } finally {
        // 데이터베이스 리소스 정리
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
