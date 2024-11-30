<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>

<%
	//데이터베이스 연결 정보
	String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";
	
    request.setCharacterEncoding("UTF-8");
	String name = request.getParameter("name");
	String id = request.getParameter("username");
	String pwd = request.getParameter("password");
	String phoneNum = request.getParameter("phone");
	String email = request.getParameter("email");
	String birthDate = request.getParameter("birthdate");
	String weddingDate = request.getParameter("weddingDate");
	
	Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
    	Class.forName("com.mysql.cj.jdbc.Driver");
    	conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    	
    	String sql = "INSERT INTO users (name, id, password, phone_num, email, birth_date, wedding_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
    	pstmt = conn.prepareStatement(sql);		// SQL 쿼리를 실행하기 위해 PreparedStatement 객체를 생성
    	
    	pstmt.setString(1, name);
        pstmt.setString(2, id);
        pstmt.setString(3, pwd); // 비밀번호는 테스트용으로 평문 사용 (해싱 권장)
        pstmt.setString(4, phoneNum);
        pstmt.setString(5, email);
        pstmt.setString(6, birthDate.isEmpty() ? null : birthDate);
        pstmt.setString(7, weddingDate.isEmpty() ? null : weddingDate);
        
        // SQL 실행
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // 성공적으로 저장됨
            out.println("<script>alert('회원가입이 완료되었습니다.'); location.href='login.jsp';</script>");
        } else {
            // 저장 실패
            out.println("<script>alert('회원가입에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
        }
        
	    } catch (SQLIntegrityConstraintViolationException e) {
	    	// ID나 이메일 중복 처리
	        out.println("<script>alert('이미 사용 중인 아이디 또는 이메일입니다. 다시 시도해주세요.'); history.back();</script>");
	    } catch (Exception e) {
	        e.printStackTrace();
	        out.println("<script>alert('시스템 오류가 발생했습니다. 관리자에게 문의하세요.'); history.back();</script>");
	    } finally {
	        // 자원 해제
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }
	    
    
	
%>