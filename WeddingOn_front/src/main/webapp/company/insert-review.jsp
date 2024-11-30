<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %> <!-- BigDecimal import 추가 -->

<%@ page session="true"%>

<%
	request.setCharacterEncoding("UTF-8");

    // 데이터베이스 연결 정보
    String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    Connection conn = null;
    PreparedStatement pstmt = null;

    String userId = (String) session.getAttribute("userId");
    
    // 클라이언트에서 전달받은 파라미터 값 가져오기
    //String userId = request.getParameter("userId");
    String companyId = request.getParameter("companyId");
    String traffic = request.getParameter("traffic");
    String parking = request.getParameter("parking");
    String ambiance = request.getParameter("ambiance");
    String price = request.getParameter("price");
    String location = request.getParameter("location");
    String reviewText = request.getParameter("reviewText");

    System.out.println("Review for companyID: " + companyId);
    System.out.println("Review for txt: " + reviewText);

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // `overall_rating` 계산
        double trafficRating = Double.parseDouble(traffic);
        double parkingRating = Double.parseDouble(parking);
        double ambianceRating = Double.parseDouble(ambiance);
        double priceRating = Double.parseDouble(price);
        double locationRating = Double.parseDouble(location);

        double overallRating = (trafficRating + parkingRating + ambianceRating + priceRating + locationRating) / 5.0;

        // SQL 쿼리 작성
        String sql = "INSERT INTO reviews (user_id, company_id, overall_rating, traffic_rating, parking_rating, atmosphere_rating, price_rating, location_rating, review_text, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(sql);

        // SQL 파라미터 설정
        pstmt.setString(1, userId); // `user_id` 추가
        pstmt.setInt(2, Integer.parseInt(companyId)); // `company_id`
        pstmt.setBigDecimal(3, BigDecimal.valueOf(overallRating)); // `overall_rating`
        pstmt.setBigDecimal(4, BigDecimal.valueOf(trafficRating)); // `traffic_rating`
        pstmt.setBigDecimal(5, BigDecimal.valueOf(parkingRating)); // `parking_rating`
        pstmt.setBigDecimal(6, BigDecimal.valueOf(ambianceRating)); // `atmosphere_rating`
        pstmt.setBigDecimal(7, BigDecimal.valueOf(priceRating)); // `price_rating`
        pstmt.setBigDecimal(8, BigDecimal.valueOf(locationRating)); // `location_rating`
        pstmt.setString(9, reviewText); // `review_text`

        // 데이터 삽입 실행
        int result = pstmt.executeUpdate();

        if (result > 0) {
        	%>
	            <script>
	                alert("리뷰가 성공적으로 저장되었습니다!");
	                window.location.href = "companyClick.jsp?companyId=<%= companyId %>";
	            </script>
    		<%
        } else {
       	%>
            <script>
                alert("리뷰 저장에 실패했습니다. 다시 시도해주세요. ");
                window.location.href = "companyClick.jsp?companyId=<%= companyId %>";
            </script>
		<%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>오류가 발생했습니다: " + e.getMessage() + "</h3>");
    } finally {
        // 리소스 닫기
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>

