<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="icon" href="../images/icon.png">
    <title>My Writing</title>
    <link rel="stylesheet" type="text/css" href="mywriting.css">
</head>
<body>
    <div class="my_writing_container">
        <div class="my_writing_list">
            <%
                // DB 연결 설정
                String dbURL = "jdbc:mysql://weddingon.cjoaqemis3i5.ap-northeast-2.rds.amazonaws.com:3306/weddingon?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
                String dbUser = "admin";
                String dbPassword = "solution";

                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                // 페이지네이션 변수
                int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int itemsPerPage = 5;
                int offset = (currentPage - 1) * itemsPerPage;

                // 세션에서 userDbId 가져오기
                Integer userDbId = (Integer) session.getAttribute("userDbId");

                if (userDbId == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                try {
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                    // 총 게시글 수 가져오기
                    String countQuery = "SELECT COUNT(*) FROM posts WHERE user_id = ?";
                    pstmt = conn.prepareStatement(countQuery);
                    pstmt.setInt(1, userDbId);
                    rs = pstmt.executeQuery();

                    int totalPosts = 0;
                    if (rs.next()) {
                        totalPosts = rs.getInt(1);
                    }

                    rs.close();
                    pstmt.close();

                    // 게시글 목록 가져오기
                    String query = "SELECT post_id, title, content, created_at FROM posts WHERE user_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setInt(1, userDbId);
                    pstmt.setInt(2, itemsPerPage);
                    pstmt.setInt(3, offset);
                    rs = pstmt.executeQuery();

                    out.println("<h2>내가 쓴 글 총 " + totalPosts + "개</h2>");
                    out.println("<p>※ 비속어나 부적절한 내용이 포함된 게시물은 삭제될 수 있습니다.</p>");

                    while (rs.next()) {
                        int postId = rs.getInt("post_id");
                        String title = rs.getString("title");
                        String content = rs.getString("content");
                        Timestamp createdAt = rs.getTimestamp("created_at");

                        out.println("<div class='writing'>");
                        out.println("<h3>" + title + "</h3>");
                        out.println("<p>" + content + "</p>");
                        out.println("<p class='created_at'>작성일: " + createdAt + "</p>");
                        out.println("<div class='comments'>");
                        out.println("<p>댓글 기능 추가 예정</p>");
                        out.println("</div>");
                        out.println("</div>");
                    }

                    rs.close();
                    pstmt.close();

                    // 페이지네이션 버튼 생성
                    int totalPages = (int) Math.ceil((double) totalPosts / itemsPerPage);

                    out.println("<div class='pagination'>");
                    for (int i = 1; i <= totalPages; i++) {
                        if (i == currentPage) {
                            out.println("<button class='page-btn active'>" + i + "</button>");
                        } else {
                            out.println("<button class='page-btn' onclick=\"location.href='mywriting.jsp?page=" + i + "'\">" + i + "</button>");
                        }
                    }
                    out.println("</div>");
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p>게시글을 불러오는 중 오류가 발생했습니다.</p>");
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
        </div>
    </div>
</body>
</html>
