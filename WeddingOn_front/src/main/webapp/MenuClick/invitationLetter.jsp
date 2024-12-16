<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*"%>

<%@ page session="true"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" href="../images/icon.png">
<title>Letter</title>
<link rel="stylesheet" type="text/css" href="hall.css">
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
	            String sql = "SELECT company_id, company_name, image_path FROM companies WHERE category = '청첩장'";
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
			<a href="../company/companyClick.jsp?companyId=<%= companyId %>" class="hall-link" target="_top"> 
				<img src="<%= imagePath != null ? imagePath : "../images/companytest.png" %>" alt="<%= companyName %>">
				<p><%= companyName %></p>
			</a>
		</div>
		
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
