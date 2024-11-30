
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // 세션에서 userID 가져오기
    Integer userDbId = (Integer) session.getAttribute("userID"); // userID는 Integer로 저장됨
    if (userDbId == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    StringBuilder likeList = new StringBuilder();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // userID를 기반으로 찜 목록 가져오기
        String sql = "SELECT f.company_id, c.company_name FROM favorites f INNER JOIN companies c ON f.company_id = c.company_id WHERE f.user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userDbId); // userID를 사용

        rs = pstmt.executeQuery();
        while (rs.next()) {
            String companyName = rs.getString("company_name");

            likeList.append("<div class='company'>")
                    .append("<div class='profile'>프로필</div>")
                    .append("<div class='name'>").append(companyName).append("</div>")
                    .append("<div class='like'><img src='images/like-icon.png'></div>")
                    .append("</div>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관심 업체</title>
    <link rel="stylesheet" type="text/css" href="Like.css">
</head>
<body>
    <div id="likeSection">
        <%= likeList.toString() %>
    </div>
</body>
</html>
