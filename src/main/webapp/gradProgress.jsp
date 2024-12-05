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
                        String dburl = "jdbc:mysql://localhost:3306/cs157ateam5";
                        String dbuname = "root";
                        String dbpassword = "password";

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection(dburl, dbuname, dbpassword);

                        
                        // Completed courses
                        String query = "SELECT c.courseID, c.courseName, c.credits " +
                                "FROM `usercourses` u " +
                                "JOIN `Courses` c ON u.courseID = c.courseID " +
                                "WHERE u.studentID = ?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, userID);
                        rs = ps.executeQuery();

                        if (rs.next()) {
                            do {
                                String courseID = rs.getString("courseID");
                                String courseName = rs.getString("courseName");
                                int credits = rs.getInt("credits");
								totalCredits += credits;
                                out.println("<li class='mb-2'>" + courseID + " (" + courseName + ", " + credits + " credits)</li>");
                            } while (rs.next());
                        } else {
                            out.println("<p>No courses marked as completed.</p>");
                        }
/*                         // Interested Courses
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
                        } */

                        // Major courses
                        String query3 = "SELECT c.courseID, c.courseName, " +
                                "CASE WHEN u.courseID IS NOT NULL THEN 1 ELSE 0 END AS isCompleted " +
                                "FROM `Courses` c " +
                                "LEFT JOIN `usercourses` u ON c.courseID = u.courseID AND u.studentID = ? " +
                                "WHERE c.courseID LIKE 'CS%'";
                        ps = con.prepareStatement(query3);
                        ps.setString(1, userID);
                        rs = ps.executeQuery();

                        out.println("<h2 class='text-2xl font-bold mt-8 mb-4'>Major Related Courses</h2>");
                        out.println("<div class='grid grid-cols-3 gap-4'>");
                        if (rs.next()) {
                            do {
                                String courseID = rs.getString("courseID");
                                String courseName = rs.getString("courseName");
                                boolean isCompleted = rs.getInt("isCompleted") > 0;

                                String colorClass = isCompleted ? "text-green-500" : "text-red-500";
                                out.println("<ul class='list-disc ml-4'>");
                                out.println("<li class='" + colorClass + "'>" + courseID + " (" + courseName + ")</li>");
                                out.println("</ul>");
                            } while (rs.next());
                        } else {
                            out.println("<p class='col-span-5 text-center'>No major courses found.</p>");
                        }
                        out.println("</div>");

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