<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, org.json.simple.*"%>
<%@ page session="true"%>

<%
	response.setContentType("application/json; charset=UTF-8");

    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    // 클라이언트에서 전달받은 chatId 가져오기
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
		Class.forName("com.mysql.cj.jdbc.Driver");

         // 데이터베이스 연결
		conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        // SQL 쿼리 작성 및 실행
        
        
       	String sql = "SELECT * FROM messages WHERE chat_id = ? ORDER BY sent_at ASC";
       	
       	pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(chatId));
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            JSONObject message = new JSONObject();
            message.put("messageId", rs.getInt("message_id"));
            message.put("senderId", rs.getInt("sender_id"));
            message.put("receiverId", rs.getInt("receiver_id"));
            message.put("messageText", rs.getString("message_text"));
            message.put("sentAt", rs.getTimestamp("sent_at").toString());

            messages.add(message);
        }
           
        
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", "Database error occurred");
        out.print(errorResponse.toJSONString());
        
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

    // JSON 데이터 반환
    response.setContentType("application/json; charset=UTF-8");
    out.print(messages.toJSONString());
%>
