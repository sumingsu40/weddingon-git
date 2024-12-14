<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    // 사용자 세션 확인
    Integer userDbId = (Integer) session.getAttribute("userDbId");
    if (userDbId == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    }

    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    // 사용자 정보 변수
    String userAccountId = ""; // id 컬럼 값
    String name = "";
    String birthDate = "";
    String email = "";
    String phone = "";
    String isCompany = "";
    String companyId = null;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "SELECT id, name, birth_date, email, phone_num, is_company, company_id FROM users WHERE userID = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userDbId);

        rs = pstmt.executeQuery();
        if (rs.next()) {
            userAccountId = rs.getString("id"); // 사용자 계정 ID
            name = rs.getString("name");
            birthDate = rs.getString("birth_date") != null ? rs.getString("birth_date") : "등록되지 않음";
            email = rs.getString("email");
            phone = rs.getString("phone_num");
            isCompany = rs.getInt("is_company") == 1 ? "기업 계정" : "일반 사용자";
            companyId = rs.getString("company_id") != null ? rs.getString("company_id") : "N/A";
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
    <title>회원 정보</title>
    <link rel="stylesheet" type="text/css" href="setting.css">
</head>
<body>
    <div class="profile-container">
        <!-- 제목 -->
        <div class="profile-header">회원 정보</div>
        
        <!-- 회원 정보 표 -->
        <div class="profile-info">
            <table class="profile-table">
                <tr>
                    <th>사용자 계정 ID</th>
                    <td><%=userAccountId %></td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td><%=name %></td>
                </tr>
                <tr>
                    <th>생년월일</th>
                    <td><%=birthDate %></td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td><%=email %></td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td><%=phone %></td>
                </tr>
                <tr>
                    <th>계정 유형</th>
                    <td><%=isCompany %></td>
                </tr>
                <% if (isCompany.equals("기업 계정")) { %>
                <tr>
                    <th>회사 ID</th>
                    <td><%=companyId %></td>
                </tr>
                <% } %>
            </table>
        </div>

        <!-- 로그인 관리 표 -->
        <div class="login-info">
            <h3>로그인 관리</h3>
            <table class="login-table">
                <tr>
                    <th>사용자 계정 ID</th>
                    <td><%=userAccountId %></td>
                </tr>
                <tr>
                    <th>비밀번호</th>
                    <td>********</td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>
