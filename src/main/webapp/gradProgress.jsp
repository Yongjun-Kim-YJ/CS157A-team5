<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Graduation Progress</title>
    <link href="https://unpkg.com/tailwindcss@^1.0/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-blue-500 min-h-screen">
    <!-- Top navigation bar -->
    <nav class="bg-gray-800 p-4 shadow-md">
        <div class="max-w-7xl mx-auto flex justify-between items-center">
            <span class="text-white text-lg font-bold">Course Prerequisite Guide</span>
            <div class="flex space-x-4">
                <form action="homepage.jsp" method="get">
                    <button class="text-white px-4 py-2 bg-blue-600 rounded hover:bg-blue-700">
                        Home Page
                    </button>
                </form>
                <form action="profile.jsp" method="get">
                    <button class="text-white px-4 py-2 bg-blue-600 rounded hover:bg-blue-700">
                        Profile
                    </button>
                </form>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-6 py-12">
        <h1 class="text-4xl font-extrabold text-center text-white mb-8">Graduation Progress</h1>

        <div class="bg-white p-8 rounded-lg shadow-md">
            <h2 class="text-2xl font-bold mb-6">Completed Courses</h2>
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                int totalCredits = 0;
                String userID = (String) session.getAttribute("studentID");

                if (userID == null) {
                    out.println("<p class='text-red-500'>User not logged in.</p>");
                } else {
                    try {
                        String dburl = "jdbc:mysql://localhost:3306/cs157a-team5";
                        String dbuname = "root";
                        String dbpassword = "password";

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection(dburl, dbuname, dbpassword);

                        String query = "SELECT c.courseID, c.credits FROM `User Courses` u " +
                                       "JOIN `Courses` c ON u.courseID = c.courseID WHERE u.studentID = ?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, userID);
                        rs = ps.executeQuery();

                        if (rs.next()) {
                            out.println("<ul class='list-disc ml-8'>");
                            do {
                                String courseID = rs.getString("courseID");
                                int credits = rs.getInt("credits");
                                out.println("<li class='mb-2'>Course: " + courseID + " | Credits: " + credits + "</li>");
                                totalCredits += credits;
                            } while (rs.next());
                            out.println("</ul>");
                        } else {
                            out.println("<p>No courses marked as completed.</p>");
                        }

                        String query2 = "SELECT c.courseID, c.credits FROM `Interested Courses` i " +
                                        "JOIN `Courses` c ON i.courseID = c.courseID WHERE i.studentID = ?";
                        ps = con.prepareStatement(query2);
                        ps.setString(1, userID);
                        rs = ps.executeQuery();

                        out.println("<h2 class='text-2xl font-bold mt-8 mb-4'>Interested Courses</h2>");
                        if (rs.next()) {
                            out.println("<ul class='list-disc ml-8'>");
                            do {
                                String courseID = rs.getString("courseID");
                                int credits = rs.getInt("credits");
                                out.println("<li class='mb-2'>Course: " + courseID + " | Credits: " + credits + "</li>");
                            } while (rs.next());
                            out.println("</ul>");
                        } else {
                            out.println("<p>No courses marked as interested.</p>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p class='text-red-500'>Error loading courses: " + e.getMessage() + "</p>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (con != null) con.close();
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        }
                    }
                }
            %>

            <!-- Display Total Credits and Progress Bar -->
            <div class="mt-8">
                <h3 class="text-xl font-semibold">Total Credits: <%= totalCredits %> credits completed of 120</h3>
                <div class="w-full bg-gray-300 rounded-full h-4 mt-2">
                    <div class="bg-green-500 h-4 rounded-full" style="width: <%= (totalCredits * 100) / 120 %>%;"></div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
