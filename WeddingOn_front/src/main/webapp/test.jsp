<%@ page import="java.sql.*" %>
<%
    String dbURL = "jdbc:mysql://weddingondb.cni2gssosrpi.ap-southeast-2.rds.amazonaws.com:3306/weddingonDB?useSSL=false&serverTimezone=UTC";
    String dbUser = "admin";
    String dbPassword = "solution";

    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        if (conn != null) {
            out.println("<h1>Database connected successfully!</h1>");
        } else {
            out.println("<h1>Failed to connect to the database.</h1>");
        }
    } catch (Exception e) {
        out.println(out);
    } finally {
        if (conn != null) conn.close();
    }
%>
