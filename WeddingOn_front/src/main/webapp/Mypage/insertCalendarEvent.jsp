<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%@ page session="true" %>

<%
    // 세션에서 userID 가져오기
    Object userIdObject = session.getAttribute("userDbId");
    if (userIdObject == null) {
        out.print("오류: 세션이 만료되었습니다. 다시 로그인해주세요.");
        return;
    }
    String userId = userIdObject.toString(); // 올바르게 String으로 변환

    // 클라이언트에서 전달된 데이터 가져오기
    String eventDate = request.getParameter("date");
    String eventTime = request.getParameter("time");
    String eventTitle = request.getParameter("title");

    // 값 확인 로그 출력
    System.out.println("userID: " + userId);
    System.out.println("eventDate: " + eventDate);
    System.out.println("eventTitle: " + eventTitle);

    if (eventDate == null || eventTitle == null) {
        out.print("오류: 필요한 데이터가 누락되었습니다.");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // 데이터베이스 연결
        String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String dbUser = "admin";
        String dbPassword = "solution";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // SQL 쿼리 실행
        String sql = "INSERT INTO user_calendar (user_id, event_title, event_date, event_time) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(userId)); // userId를 Integer로 변환
        pstmt.setString(2, eventTitle);
        pstmt.setString(3, eventDate);
        pstmt.setString(4, eventTime);

        int rows = pstmt.executeUpdate();
        if (rows > 0) {
            out.print("일정이 성공적으로 추가되었습니다!");
        } else {
            out.print("일정 추가에 실패했습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("오류 발생: " + e.getMessage());
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
