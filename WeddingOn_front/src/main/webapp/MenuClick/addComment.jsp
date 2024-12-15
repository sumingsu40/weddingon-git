<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>

<%@ page session="true" %>

<%
	request.setCharacterEncoding("UTF-8");

String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    String postId = request.getParameter("postId");
    String content = request.getParameter("content");
    
    String id = (String) session.getAttribute("userId");
    
    Object userDbIdObj = session.getAttribute("userDbId");
    String userId = userDbIdObj != null ? userDbIdObj.toString() : null;

    response.setContentType("application/json");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "INSERT INTO comments (post_id, user_id, content, created_at) VALUES (?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(postId));
        pstmt.setString(2, userId);
        pstmt.setString(3, content);

        int rows = pstmt.executeUpdate();
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formattedDate = sdf.format(new java.util.Date());
        
        if (rows > 0) {
            out.print("{\"status\":\"success\",\"userId\":\"" + id + "\",\"content\":\"" + content + "\",\"createdAt\":\"" + formattedDate + "\"}");
        } else {
            out.write("{\"status\":\"error\", \"message\":\"Failed to add comment.\"}");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.write("{\"status\":\"error\", \"message\":\"Database error.\"}");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>