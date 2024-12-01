<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<%@ page session="true" %>

<%
    response.setContentType("application/json; charset=UTF-8");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    // 페이지 파라미터 처리
    // pageParam을 currentPage에 올바르게 반영
	String pageParam = request.getParameter("page");
    System.out.println("page : "+pageParam);
    
	int currentPage = 1; // 기본값
	if (pageParam != null) {
	    try {
	        currentPage = Integer.parseInt(pageParam); // 페이지 번호 파싱
	    } catch (NumberFormatException e) {
	        currentPage = 1; // 잘못된 값이 들어오면 기본값 유지
	    }
	}
	
	System.out.println("Current Page: " + currentPage);


    int postsPerPage = 6; // 페이지당 게시글 수
    int offset = (currentPage - 1) * postsPerPage; // OFFSET 계산

    JSONArray postsArray = new JSONArray(); // JSON 배열 생성

    try {
        // JDBC 드라이버 로드 및 DB 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // SQL 쿼리 작성
        String sql = "SELECT post_id, title, content, user_id, DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') AS created_at " +
                     "FROM posts ORDER BY created_at DESC LIMIT ? OFFSET ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, postsPerPage); // LIMIT 값 설정
        pstmt.setInt(2, offset); // OFFSET 값 설정

        rs = pstmt.executeQuery();

        // ResultSet에서 데이터를 가져와 JSON 배열로 변환
        while (rs.next()) {
            JSONObject post = new JSONObject();
            post.put("post_id", rs.getInt("post_id"));
            post.put("title", rs.getString("title"));
            post.put("content", rs.getString("content"));
            post.put("user_id", rs.getInt("user_id"));
            post.put("created_at", rs.getString("created_at"));

            postsArray.put(post);
        }

        // JSON 배열 출력
        response.getWriter().write(postsArray.toString());

    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().write("{\"status\":\"error\", \"message\":\"Database error occurred.\"}");
    } finally {
        // 리소스 정리
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>