<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page session="true" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Homepage</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sigma.js/2.4.0/sigma.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/graphology/0.25.4/graphology.umd.min.js"></script>
    <link href=
"https://unpkg.com/tailwindcss@^1.0/dist/tailwind.min.css"
          rel="stylesheet">
</head>
<body>
    <!-- Top navigation bar -->
    <nav class="bg-gray-800 p-4">
        <div class="max-w-7xl mx-auto flex justify-between items-center">
            <span class="text-white text-lg font-bold">Course Prerequisite Guide</span>
            <form action="profile.jsp" method="get">
                <button class="text-white px-4 py-2 bg-blue-500 rounded hover:bg-blue-600">
                    Profile
                </button>
            </form>
        </div>
    </nav>

    <!-- Welcome Section -->
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16 lg:py-20">
            <div class="text-center">
                <h1 class="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight mb-4">
                   Welcome 
                    <%
                        String name = (String) session.getAttribute("name");
                        out.println(name + "!");
                    %>
                </h1>
            </div>
        </div>
    </div>

    <div class="bg-gray-100 py-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 flex space-x-4">
            <!-- Course List -->
            <div class="w-1/4 h-96 overflow-y-auto border border-gray-300 p-4 rounded bg-white">
                <h2 class="text-xl font-bold mb-4">Available Courses</h2>
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        String dburl = "jdbc:mysql://localhost:3306/cs157a-team5";
                        String dbuname = "root";
                        String dbpassword = "password";

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection(dburl, dbuname, dbpassword);

                        String query = "SELECT courseID, courseName FROM Courses";
                        ps = con.prepareStatement(query);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            String courseName = rs.getString("courseName");
                            String courseID = rs.getString("courseID");
                %>
                            <form action="homepage.jsp" method="get">
                                <input type="hidden" name="selectedCourse" value="<%= courseName %>">
                                <button 
                                    type="submit" 
                                    class="block w-full text-left px-4 py-2 bg-gray-100 hover:bg-blue-200 rounded mb-2 shadow">
                                    <%= courseID %>: <%= courseName %>
                                </button>
                            </form>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                        <p>Error loading courses.</p>
                <%
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (con != null) con.close();
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        }
                    }
                %>
            </div>

            <!-- Description and Graph -->
            <div class="w-3/4 border border-gray-300 p-4 rounded bg-white">
                <%
                    String selectedCourse = request.getParameter("selectedCourse");
                    if (selectedCourse != null) {
                        PreparedStatement detailPs = null;
                        ResultSet detailRs = null;
                        try {
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs157a-team5", "root", "password");

                            String detailQuery = "SELECT description FROM Courses WHERE courseName=?";
                            detailPs = con.prepareStatement(detailQuery);
                            detailPs.setString(1, selectedCourse);
                            detailRs = detailPs.executeQuery();

                            if (detailRs.next()) {
                                String courseDescription = detailRs.getString("description");
                %>
                                <h2 class="text-xl font-bold mb-4"><%= selectedCourse %></h2>
                                <p><%= courseDescription %></p>
                <%
                            } else {
                %>
                                <p>Course details not found.</p>
                <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                %>
                            <p>Error fetching course details.</p>
                <%
                        } finally {
                            try {
                                if (detailRs != null) detailRs.close();
                                if (detailPs != null) detailPs.close();
                                if (con != null) con.close();
                            } catch (SQLException ex) {
                                ex.printStackTrace();
                            }
                        }
                    } else {
                %>
                        <h2 class="text-xl font-bold mb-4">Course Details</h2>
                        <p>Select a course on the left.</p>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    <div id="container" style="width: 100%; height: 400px; background: white"></div>
    <script>
      // Test node graph
      const graph = new graphology.Graph();
      graph.addNode("1", { label: "Node 1", x: 0, y:0, size: 20, color: "blue" });
      graph.addNode("2", { label: "Node 2", x: 1, y:2, size: 20, color: "red" });
      graph.addNode("3", { label: "Node 3", x: 2, y:1, size: 20, color: "green" });
      graph.addNode("4", { label: "Node 4", x: 2, y:0, size: 20, color: "grey" });
      graph.addNode("5", { label: "Node 5", x: 3, y:3, size: 20, color: "grey" });
      graph.addEdge("1", "2", { size: 5, color: "purple" });
      graph.addEdge("2", "3", { size: 5, color: "purple" });
      graph.addEdge("3", "4", { size: 5, color: "purple" });
      graph.addEdge("3", "5", { size: 5, color: "purple" });

      // Instantiate sigma.js and render the graph
      const sigmaInstance = new Sigma(graph, document.getElementById("container"));
    </script>
</body>
</html>
