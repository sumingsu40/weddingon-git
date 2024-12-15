<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%
    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

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
            int userDbId = rs.getInt("userID");
            String username = rs.getString("name"); // 사용자 이름 가져오기
            int isCompany = rs.getInt("is_company"); // 회사 여부 확인 (0: 일반 사용자, 1: 회사)
            Integer companyId = rs.getObject("company_id") != null ? rs.getInt("company_id") : null; // 기업 ID 가져오기

            session.setAttribute("userDbId", userDbId);
            session.setAttribute("userId", userId); // 세션에 ID 저장
            session.setAttribute("userName", username); // 세션에 사용자 이름 저장
            session.setAttribute("isCompany", isCompany); // 세션에 회사 여부 저장
            session.setAttribute("companyId", companyId); // 기업 ID를 세션에 저장
            
            message = "로그인 성공! 환영합니다, " + username + "님!";

            System.out.println("userID: " + userDbId);
            System.out.println("userId: " + userId);
            System.out.println("username: " + username);
            System.out.println("isCompany: " + isCompany);
            System.out.println("companyId: " + companyId);

            // is_company 값에 따라 리다이렉트
            if (isCompany == 0) {
                response.sendRedirect("../Main-loadmap/loadmap.jsp"); // 일반 사용자 페이지로 이동
            } else if (isCompany == 1) {
                response.sendRedirect("../companyChat/chatList.jsp"); // 회사 페이지로 이동
            }
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
