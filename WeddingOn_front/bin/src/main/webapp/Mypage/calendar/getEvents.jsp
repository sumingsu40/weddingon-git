
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%@ page session="true" %>

<%
    // 클라이언트에서 전달된 연도와 월
    String year = request.getParameter("year");
    String month = request.getParameter("month");

    response.setContentType("application/json; charset=UTF-8");

    if (year == null || month == null) {
        response.getWriter().write("[]"); // 연도와 월이 없으면 빈 배열 반환
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        // DB 연결 정보
        String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String dbUser = "admin";
        String dbPassword = "solution";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 특정 월의 일정 가져오기
        String sql = "SELECT event_date, event_title FROM user_calendar WHERE YEAR(event_date) = ? AND MONTH(event_date) = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, year);
        pstmt.setString(2, month);

        rs = pstmt.executeQuery();

        // 결과를 JSON 형식으로 변환
        StringBuilder jsonBuilder = new StringBuilder("[");
        while (rs.next()) {
            if (jsonBuilder.length() > 1) {
                jsonBuilder.append(",");
            }
            jsonBuilder.append("{\"date\":\"").append(rs.getString("event_date"))
                        .append("\",\"title\":\"").append(rs.getString("event_title"))
                        .append("\"}");
        }
        jsonBuilder.append("]");
        response.getWriter().write(jsonBuilder.toString());
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().write("[]"); // 오류가 발생하면 빈 배열 반환
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
