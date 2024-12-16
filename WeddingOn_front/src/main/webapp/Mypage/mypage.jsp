<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%@ page session="true" %>

<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../login/login.jsp");
        return;
    } else {
    	System.out.println("mypage userId: " + userId);
    }
%>

<%
    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";
    
    String weddingDate = null; // 결혼 예정일 저장 변수
    String dDayMessage = ""; // D-Day 메시지

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String sql = "SELECT wedding_date FROM users WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);

        rs = pstmt.executeQuery();
        if (rs.next()) {
			weddingDate = rs.getString("wedding_date");

            // 현재 날짜와 예정일 비교
            LocalDate today = LocalDate.now();
            LocalDate weddingLocalDate = LocalDate.parse(weddingDate);

            long daysLeft = ChronoUnit.DAYS.between(today, weddingLocalDate);

            if (daysLeft > 0) {
                dDayMessage = "D-" + daysLeft; // 예정일까지 남은 날짜
            } else if (daysLeft == 0) {
                dDayMessage = "D-Day"; // 오늘이 예정일
            } else {
                dDayMessage = "D+" + Math.abs(daysLeft); // 예정일이 지남
            }
        } else {
            dDayMessage = "결혼 예정일이 설정되지 않았습니다.";
        }
    } catch (Exception e) {
        e.printStackTrace();
        dDayMessage = "오류가 발생했습니다.";
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

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="../images/icon.png">
    <title>My Page</title>
    <link rel="stylesheet" type="text/css" href="mypage.css">
    <script src="mypage.js" defer></script>
</head>
<body>
<!-- 가장 메인 -->
    <div class="top_bar">
        <a href="../Main-loadmap/index.jsp">
            <img class="logo" src="../images/weddingon-logo.png">
        </a>
        <div class="d_day"><%=dDayMessage %></div>
        <a href="logout.jsp">
        	<img class="logout" src="images/logout-icon.png">
        </a>
    </div>
    <div class="sidebar">
        <div class="menu_item selected" data-target="like.jsp">관심 업체</div>
        <div class="menu_item" data-target="../chat/chat.jsp">채팅방</div>
        <div class="menu_item" data-target="calendar.html">캘린더</div>
        <div class="menu_item" data-target="mywriting.jsp">내가 쓴 글</div>
        <div class="menu_item" data-target="setting.jsp">개인정보</div> <!-- 개인정보 메뉴 추가 -->
    </div>
    <div class="content">
        <iframe id="contentFrame" src="./like.jsp" frameborder="0" style="width:100%; height:calc(100vh - 96px);"></iframe>
    </div>
    <script>
    document.addEventListener("DOMContentLoaded", () => {
        const menuItems = document.querySelectorAll(".menu_item");
        const iframe = document.getElementById("contentFrame");

        // 기본 로드 메뉴 설정
        const defaultMenu = document.querySelector(".menu_item.selected");
        if (defaultMenu) {
            iframe.src = defaultMenu.getAttribute("data-target");
        }

        menuItems.forEach((menuItem) => {
            menuItem.addEventListener("click", () => {
                menuItems.forEach((item) => item.classList.remove("selected"));
                menuItem.classList.add("selected");
                const targetPage = menuItem.getAttribute("data-target");
                iframe.src = targetPage;
            });
        });
    });
</script>
</body>
</html>
