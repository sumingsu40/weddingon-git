<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    response.setContentType("application/json; charset=UTF-8");
    String userId = request.getParameter("userId");
    String companyId = request.getParameter("companyId");
    
    System.out.println("Received userId: " + userId);
    System.out.println("Received companyId: " + companyId);

    if (userId == null || userId.isEmpty() || companyId == null || companyId.isEmpty()) {
        response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid userId or companyId\"}");
        return;
    }

    String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
        // Check if the favorite already exists
        String checkSql = "SELECT * FROM favorites WHERE user_id = ? AND company_id = ?";
        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, Integer.parseInt(userId));
            checkStmt.setInt(2, Integer.parseInt(companyId));
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    // If exists, delete it (unfavorite)
                    String deleteSql = "DELETE FROM favorites WHERE user_id = ? AND company_id = ?";
                    try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                        deleteStmt.setInt(1, Integer.parseInt(userId));
                        deleteStmt.setInt(2, Integer.parseInt(companyId));
                        int rows = deleteStmt.executeUpdate();
                        if (rows > 0) {
                            response.getWriter().write("{\"status\": \"success\", \"message\": \"Favorite removed\"}");
                        } else {
                            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to remove favorite\"}");
                        }
                    }
                } else {
                    // If not exists, insert it (favorite)
                    String insertSql = "INSERT INTO favorites (user_id, company_id) VALUES (?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setInt(1, Integer.parseInt(userId));
                        insertStmt.setInt(2, Integer.parseInt(companyId));
                        int rows = insertStmt.executeUpdate();
                        if (rows > 0) {
                            response.getWriter().write("{\"status\": \"success\", \"message\": \"Favorite added\"}");
                        } else {
                            response.getWriter().write("{\"status\": \"error\", \"message\": \"Failed to add favorite\"}");
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().write("{\"status\": \"error\", \"message\": \"Database error\"}");
    }
%>
