<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>

<%@ page session="true"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" href="../images/icon.png">
<title>Hall</title>
    <link rel="stylesheet" type="text/css" href="hall.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>
   <div class="hall-container">
      <%
           // 데이터베이스 연결 정보
           String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
           String dbUser = "admin";
           String dbPassword = "solution";
   
           try {
               // 데이터베이스 연결
               Class.forName("com.mysql.cj.jdbc.Driver");
               Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
   
               // SQL 쿼리 실행
               String sql = "SELECT company_id, company_name, image_path FROM companies WHERE category = '웨딩홀'";
               PreparedStatement pstmt = conn.prepareStatement(sql);
               ResultSet rs = pstmt.executeQuery();
   
               // 결과 출력
               while (rs.next()) {
                   int companyId = rs.getInt("company_id"); // company_id를 받아와야 클릭한 기업을 식별 가능
                   String companyName = rs.getString("company_name");
                   String imagePath = rs.getString("image_path"); // DB에 저장된 이미지 경로
   					
                   // HTML 카드 생성
       %>
       <div class="hall-card">
    <a href="../company/companyClick.jsp?companyId=<%= companyId %>" 
       class="hall-link" 
       onclick="navigateToCompanyClick(event, this)"> 
        <img src="<%= imagePath != null ? imagePath : "../images/companytest.png" %>" alt="<%= companyName %>">
        <p><%= companyName %></p>
    </a>
</div>

<script>
    function navigateToCompanyClick(event, link) {
        event.preventDefault(); // 기본 링크 동작 방지

        const iframe = parent.document.getElementById('contentFrame');
        const url = link.href; // 링크에서 URL 가져오기

        if (iframe) {
            iframe.src = url; // iframe에 URL 로드
            const parentUrl = new URL(parent.window.location.href);
            parentUrl.searchParams.set('iframeSrc', url); // iframeSrc 동기화
            parent.window.history.replaceState(null, '', parentUrl); // URL 변경
        } else {
            // iframe이 없는 경우 전체 페이지 이동
            window.location.href = url;
        }
    }
</script>


      <%
            }

            // 자원 해제
               rs.close();
               pstmt.close();
               conn.close();
           } catch (Exception e) {
                  e.printStackTrace();
           }
       %>
   </div>

</body>
</html>