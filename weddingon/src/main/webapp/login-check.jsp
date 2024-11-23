<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
   
<%
    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://localhost:3306/weddingondb"; // 데이터베이스 URL
    String dbUser = "root"; // MySQL 사용자 이름
    String dbPassword = "0000"; // MySQL 비밀번호

    // 로그인 폼에서 전달받은 값
    String userId = request.getParameter("id");
    String userPassword = request.getParameter("password");

    // 결과 메시지 초기화
    String message = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // MySQL JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 데이터베이스 연결
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 사용자 ID와 비밀번호를 확인하는 SQL 쿼리
        String sql = "SELECT * FROM users WHERE id = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, userPassword);

        // 쿼리 실행
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 로그인 성공
            message = "로그인 성공! 환영합니다, " + rs.getString("id") + "님!";
            session.setAttribute("user", rs.getString("id")); // 세션에 사용자 정보 저장
            response.sendRedirect("index.jsp"); // 메인 페이지로 이동
        } else {
            // 로그인 실패
            message = "로그인 실패: 아이디 또는 비밀번호가 일치하지 않습니다.";
            out.println("<script>alert('" + message + "'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        message = "데이터베이스 연결 오류: " + e.getMessage();
        out.println("<script>alert('" + message + "'); history.back();</script>");
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
%>
