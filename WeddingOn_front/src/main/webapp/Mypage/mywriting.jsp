<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page session="true" %>

<%
    // DB 연결 설정
    String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String dbUser = "admin";
    String dbPassword = "solution";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 세션에서 userDbId 가져오기
    Integer userDbId = (Integer) session.getAttribute("userDbId");

    if (userDbId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> posts = new ArrayList<>();
    int totalPosts = 0;

    try {
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 총 게시글 수 가져오기
        String countQuery = "SELECT COUNT(*) FROM posts WHERE user_id = ?";
        pstmt = conn.prepareStatement(countQuery);
        pstmt.setInt(1, userDbId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            totalPosts = rs.getInt(1);
        }

        rs.close();
        pstmt.close();

        // 게시글 목록 가져오기
        String query = "SELECT post_id, title, content, created_at FROM posts WHERE user_id = ? ORDER BY created_at DESC";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, userDbId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> post = new HashMap<>();
            post.put("postId", rs.getInt("post_id"));
            post.put("title", rs.getString("title"));
            post.put("content", rs.getString("content"));
            post.put("createdAt", rs.getTimestamp("created_at"));
            posts.add(post);
        }

        rs.close();
        pstmt.close();
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
    <link rel="icon" href="../images/icon.png">
    <title>My Writing</title>
    <link rel="stylesheet" type="text/css" href="mywriting.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>
    <div class="my_writing_container">
        <div class="my_writing_list">
            <h2>내가 쓴 글 총 <%= totalPosts %>개</h2>
            <p>※ 비속어나 부적절한 내용이 포함된 게시물은 삭제될 수 있습니다.</p>

            <% for (Map<String, Object> post : posts) { %>
                <div class="writing">
                    <h3><%= post.get("title") %></h3>
                    <p><%= post.get("content") %></p>
                    <p class="created_at">작성일: <%= post.get("createdAt") %></p>
                </div>
            <% } %>
        </div>
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            console.log("My Writing page loaded successfully!");

            // 모든 댓글을 펼치거나 접는 기능
            const writings = document.querySelectorAll(".writing");

            writings.forEach((writing) => {
                writing.addEventListener("click", () => {
                    const comments = writing.querySelector(".comments");
                    if (comments) {
                        // 댓글 토글 (펼치기/접기)
                        if (comments.style.display === "none") {
                            comments.style.display = "block";
                        } else {
                            comments.style.display = "none";
                        }
                    }
                });
            });
        });
    </script>
</body>
</html>
