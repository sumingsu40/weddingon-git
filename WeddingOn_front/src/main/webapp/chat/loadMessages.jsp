<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, org.json.simple.*"%>
<%@ page session="true"%>

<%
    //System.out.println("loadMessages.jsp 호출됨");

    // JSON 응답 준비
    response.setContentType("application/json; charset=UTF-8");

    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    // 클라이언트에서 전달받은 companyId 및 senderId 가져오기
    String companyId = request.getParameter("companyId");
    String currentUserId = request.getParameter("senderId"); // 현재 로그인한 사용자 ID

    // JSON 배열 준비
    JSONArray messages = new JSONArray();

    // 입력 값 검증
    if (companyId == null || companyId.isEmpty() || currentUserId == null || currentUserId.isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        JSONObject errorResponse = new JSONObject();
        errorResponse.put("error", "companyId and senderId are required");
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

        // 현재 사용자와 관련된 메시지 가져오기
        String sql = "SELECT * FROM messages " +
                     "WHERE chat_id = ? AND (sender_id = ? OR receiver_id = ?) " +
                     "ORDER BY sent_at ASC";

        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(companyId)); // chat_id
        pstmt.setInt(2, Integer.parseInt(currentUserId)); // sender_id
        pstmt.setInt(3, Integer.parseInt(currentUserId)); // receiver_id

        rs = pstmt.executeQuery();

        // 결과를 JSON으로 변환
        while (rs.next()) {
            JSONObject message = new JSONObject();
            message.put("messageId", rs.getInt("message_id"));
            message.put("senderId", rs.getInt("sender_id"));
            message.put("receiverId", rs.getInt("receiver_id"));
            message.put("messageText", rs.getString("message_text"));
            message.put("senderType", rs.getInt("sender_type")); // sender_type 추가
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
