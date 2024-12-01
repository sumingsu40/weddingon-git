<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
	response.setContentType("application/json; charset=UTF-8");
	request.setCharacterEncoding("UTF-8");

	String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
	String dbUser = "admin";
	String dbPassword = "solution";

    Connection conn = null;
    PreparedStatement pstmt = null;

    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String hashtags = request.getParameter("hashtags");
    
    Object userDbIdObj = session.getAttribute("userDbId");
    String id = userDbIdObj != null ? userDbIdObj.toString() : null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        //String sql = "INSERT INTO posts (title, user_id, content, hashtags, created_at) VALUES (?, ?, ?, NOW())";
        String sql = "INSERT INTO posts (title, user_id, content, created_at) VALUES (?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, id);
        pstmt.setString(3, content);
        //pstmt.setString(4, hashtags);

        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"failure\"}");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
