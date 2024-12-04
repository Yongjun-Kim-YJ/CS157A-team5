<<<<<<< HEAD
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
    <!-- 	    <input  -->
<!-- 					    id="searchbar"  -->
<!-- 					    onkeyup="search_course()"  -->
<!-- 					    type="text"  -->
<!-- 					    name="search"  -->
<!-- 					    placeholder="Search Courses"  -->
<!-- 					    class=" -->
<!-- 					    	block -->
<!-- 					        mb-4 -->
<!-- 					        px-4 -->
<!-- 					        py-2 -->
<!-- 					        w-1/4 -->
<!-- 					        border  -->
<!-- 					        border-gray-300  -->
<!-- 					        rounded-lg  -->
<!-- 					        focus:outline-none  -->
<!-- 					        focus:ring-2  -->
<!-- 					        focus:ring-blue-500  -->
<!-- 					        focus:border-blue-500  -->
<!-- 					        text-gray-700  -->
<!-- 					        placeholder-gray-400  -->
<!-- 					        shadow-sm -->
<!-- 					    "> -->
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
                            <form class="course" action="homepage.jsp" method="get">
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

    <!-- Graph Container -->
    <div id="container" style="width: 100%; height: 400px; background: white"></div>

    <!-- Script to generate the graph -->
    <script>
      const graph = new graphology.Graph();

      <% 
        // Fetch courses from the database

        try {
            String dburl = "jdbc:mysql://localhost:3306/cs157a-team5";
            String dbuname = "root";
            String dbpassword = "password";

            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(dburl, dbuname, dbpassword);

            String query = "SELECT courseID FROM Courses";
            ps = con.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = ps.executeQuery();

            // Variables for positioning
            int nodeCount = 0;
            int totalNodes = 0;
            // First, count the total number of nodes
            while (rs.next()) {
                totalNodes++;
            }
            // Reset the cursor to the beginning
            rs.beforeFirst();

            double angleIncrement = (2 * Math.PI) / totalNodes;
            double radius = 100;

            while (rs.next()) {
                String courseID = rs.getString("courseID");

                // Calculate positions
                double angle = nodeCount * angleIncrement;
                double x = radius * Math.cos(angle);
                double y = radius * Math.sin(angle);
      %>
                // Add nodes to the graph
                graph.addNode("<%= courseID %>", { 
                    label: "<%= courseID %>", 
                    x: <%= x %>, 
                    y: <%= y %>, 
                    size: 20, 
                    color: "lightgray" 
                });
      <%
                nodeCount++;
            }
            
         	
        } catch (Exception e) {
            e.printStackTrace();
      %>
            // Handle errors if any
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
      graph.addEdge("CS116A", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS116B", "CS116A", { size: 5, color: "purple" });
      graph.addEdge("CS122", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS123A", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS123B", "CS123A", { size: 5, color: "purple" });
      graph.addEdge("CS131", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS133", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS134", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS134", "CS151", { size: 5, color: "purple" });
      graph.addEdge("CS136", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS144", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS146", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS147", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS149", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS149", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS151", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS152", "CS151", { size: 5, color: "purple" });
      graph.addEdge("CS153", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS153", "CS154", { size: 5, color: "purple" });
      graph.addEdge("CS153", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS154", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS155", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS156", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS157A", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS157B", "CS157A", { size: 5, color: "purple" });
      graph.addEdge("CS157C", "CS157A", { size: 5, color: "purple" });
      graph.addEdge("CS158A", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS158A", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS158B", "CS158A", { size: 5, color: "purple" });
      graph.addEdge("CS159", "CS146", { size: 5, color: "purple" });
      //Error occurs if include this line
      //graph.addEdge("CS160", "CS100W", { size: 5, color: "purple" });
      graph.addEdge("CS160", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS160", "CS151", { size: 5, color: "purple" });
      graph.addEdge("CS161", "CS160", { size: 5, color: "purple" });
      graph.addEdge("CS166", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS166", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS168", "CS166", { size: 5, color: "purple" });
      graph.addEdge("CS171", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS174", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS175", "CS46A", { size: 5, color: "purple" });
      graph.addEdge("CS175", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS176", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS46B", "CS46A", { size: 5, color: "purple" });
      graph.addEdge("CS47", "CS46B", { size: 5, color: "purple" });

      // Instantiate sigma.js and render the graph
      const sigmaInstance = new Sigma(graph, document.getElementById("container"));
    </script>
</body>
</html>
=======
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
            <form action="courseSearch.jsp" method="get">
                <button class="text-white px-4 py-2 bg-blue-500 rounded hover:bg-blue-600">
                    Search and Add
                </button>
            </form>
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
                        String dburl = "jdbc:mysql://localhost:3306/cs157ateam5";
                        String dbuname = "root";
                        String dbpassword = "password";

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        con = DriverManager.getConnection(dburl, dbuname, dbpassword);

                        String query = "SELECT courseID, courseName FROM courses";
                        ps = con.prepareStatement(query);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            String courseName = rs.getString("courseName");
                            String courseID = rs.getString("courseID");
                %>
                            <form class="course" action="homepage.jsp" method="get">
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
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs157ateam5", "root", "password");

                            String detailQuery = "SELECT description FROM courses WHERE courseName=?";
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

    <!-- Graph Container -->
    <div id="container" style="width: 100%; height: 400px; background: white"></div>

    <!-- Script to generate the graph -->
    <script>
      const graph = new graphology.Graph();

      <% 
        // Fetch courses from the database

        try {
            String dburl = "jdbc:mysql://localhost:3306/cs157ateam5";
            String dbuname = "root";
            String dbpassword = "password";

            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(dburl, dbuname, dbpassword);

            String query = "SELECT courseID FROM courses";
            ps = con.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs = ps.executeQuery();

            // Variables for positioning
            int nodeCount = 0;
            int totalNodes = 0;
            // First, count the total number of nodes
            while (rs.next()) {
                totalNodes++;
            }
            // Reset the cursor to the beginning
            rs.beforeFirst();

            double angleIncrement = (2 * Math.PI) / totalNodes;
            double radius = 100;

            while (rs.next()) {
                String courseID = rs.getString("courseID");

                // Calculate positions
                double angle = nodeCount * angleIncrement;
                double x = radius * Math.cos(angle);
                double y = radius * Math.sin(angle);
      %>
                // Add nodes to the graph
                graph.addNode("<%= courseID %>", { 
                    label: "<%= courseID %>", 
                    x: <%= x %>, 
                    y: <%= y %>, 
                    size: 20, 
                    color: "lightgray" 
                });
      <%
                nodeCount++;
            }
            
         	
        } catch (Exception e) {
            e.printStackTrace();
      %>
            // Handle errors if any
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
      graph.addEdge("CS116A", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS116B", "CS116A", { size: 5, color: "purple" });
      graph.addEdge("CS122", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS123A", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS123B", "CS123A", { size: 5, color: "purple" });
      graph.addEdge("CS131", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS133", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS134", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS134", "CS151", { size: 5, color: "purple" });
      graph.addEdge("CS136", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS144", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS146", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS147", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS149", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS149", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS151", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS152", "CS151", { size: 5, color: "purple" });
      graph.addEdge("CS153", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS153", "CS154", { size: 5, color: "purple" });
      graph.addEdge("CS153", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS154", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS155", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS156", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS157A", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS157B", "CS157A", { size: 5, color: "purple" });
      graph.addEdge("CS157C", "CS157A", { size: 5, color: "purple" });
      graph.addEdge("CS158A", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS158A", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS158B", "CS158A", { size: 5, color: "purple" });
      graph.addEdge("CS159", "CS146", { size: 5, color: "purple" });
      //Error occurs if include this line
      //graph.addEdge("CS160", "CS100W", { size: 5, color: "purple" });
      graph.addEdge("CS160", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS160", "CS151", { size: 5, color: "purple" });
      graph.addEdge("CS161", "CS160", { size: 5, color: "purple" });
      graph.addEdge("CS166", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS166", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS168", "CS166", { size: 5, color: "purple" });
      graph.addEdge("CS171", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS174", "CS46B", { size: 5, color: "purple" });
      graph.addEdge("CS175", "CS46A", { size: 5, color: "purple" });
      graph.addEdge("CS175", "CS47", { size: 5, color: "purple" });
      graph.addEdge("CS176", "CS146", { size: 5, color: "purple" });
      graph.addEdge("CS46B", "CS46A", { size: 5, color: "purple" });
      graph.addEdge("CS47", "CS46B", { size: 5, color: "purple" });

      // Instantiate sigma.js and render the graph
      const sigmaInstance = new Sigma(graph, document.getElementById("container"));
    </script>
</body>
</html>
>>>>>>> main
