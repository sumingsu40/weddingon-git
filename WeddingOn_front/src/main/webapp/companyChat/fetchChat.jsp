<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, org.json.simple.*"%>
<%@ page session="true"%>

<%
    System.out.println("fetchChat.jsp 호출됨");

    // JSON 응답 준비
    response.setContentType("application/json; charset=UTF-8");

    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    // 클라이언트에서 전달받은 파라미터
    String chatId = request.getParameter("chatId");
    String userId = request.getParameter("userId");

    // JSON 배열 준비
    JSONArray messages = new JSONArray();

    // 필수 파라미터 누락 확인
    if (chatId == null || chatId.isEmpty() || userId == null || userId.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", "chatId and userId are required");
        out.print(errorResponse.toJSONString());
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 드라이버 로드 및 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // SQL 쿼리 작성 및 실행
        String sql = "SELECT message_id, sender_id, receiver_id, message_text, sender_type, sent_at " +
                     "FROM messages WHERE chat_id = ? AND (sender_id = ? OR receiver_id = ?) " +
                     "ORDER BY sent_at ASC";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(chatId));
        pstmt.setInt(2, Integer.parseInt(userId));
        pstmt.setInt(3, Integer.parseInt(userId));

        rs = pstmt.executeQuery();

        // 결과를 JSON으로 변환
        while (rs.next()) {
            JSONObject message = new JSONObject();
            message.put("messageId", rs.getInt("message_id"));
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
        errorResponse.put("error", "Database error occurred");
        out.print(errorResponse.toJSONString());
        return;
    } finally {
        // 자원 해제
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // JSON 데이터를 클라이언트에 반환
    out.print(messages.toJSONString());
%>
