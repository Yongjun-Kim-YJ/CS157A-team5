<%@ page language="java" contentType="text/html; charset=ISO-8859-1" session="true"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
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
            <form action="gradProgress.jsp" method="get">
                <button class="text-white px-4 py-2 bg-blue-500 rounded hover:bg-blue-600">
                    Graduation Progress
                </button>
            </form>
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
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-8 lg:py-10">
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
    
    <div class="bg-gray-100 h-screen py-8">
        <div class="max-w-7xl h-full px-4 sm:px-6 lg:px-8 flex space-x-4">
            <!-- Course List -->
            <div class="w-1/4 h-80vh overflow-y-auto border border-gray-300 p-4 rounded bg-white">
                <h2 class="block w-full text-xl font-bold mb-4">Available Courses</h2>
                <input 
				    id="searchbar" 
				    onkeyup="search_course()" 
				    type="text" 
				    name="search" 
				    placeholder="Search Courses" 
				    class="
				        block 
				        mb-4 
				        px-4 
				        py-2 
				        w-full
				        border  
				        border-gray-300  
				        rounded-lg  
				        focus:outline-none  
				        focus:ring-2  
				        focus:ring-blue-500  
				        focus:border-blue-500  
				        text-gray-700  
				        placeholder-gray-400  
				        shadow-sm
				    ">
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
                                <input type="hidden" name="selectedCourse" value="<%= courseID %>">
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
            <div class="w-3/4 h-full overflow-y-auto border border-gray-300 p-4 rounded bg-white">
                <%
                    String selectedCourse = request.getParameter("selectedCourse");
                    if (selectedCourse != null) {
                        PreparedStatement detailPs = null;
                        ResultSet detailRs = null;
                        PreparedStatement preqPs = null;
                        ResultSet preqRs = null;
                        try {
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs157ateam5", "root", "password");

                            String detailQuery = "SELECT description FROM courses WHERE courseId=?";
                            detailPs = con.prepareStatement(detailQuery);
                            detailPs.setString(1, selectedCourse);
                            detailRs = detailPs.executeQuery();
                            System.out.println("selectedCourse" + selectedCourse);
                            String preqQuery = 
                            	    "WITH RECURSIVE CourseGraph AS ( " +
                            	    "    SELECT courseId, prerequisiteID " +
                            	    "    FROM cs157ateam5.prerequisites " +
                            	    "    WHERE courseId = '" + selectedCourse + "' " +
                            	    "    UNION ALL " +
                            	    "    SELECT c.courseId, c.prerequisiteID " +
                            	    "    FROM cs157ateam5.prerequisites c " +
                            	    "    INNER JOIN CourseGraph cg " +
                            	    "    ON c.courseId = cg.prerequisiteID " +
                            	    ") " +
                            	    "SELECT courseId, prerequisiteID " +
                            	    "FROM CourseGraph;";
                           preqPs = con.prepareStatement(preqQuery);
                           
                           ArrayList<ArrayList<String>> adjList = new ArrayList<>();
                           preqRs = preqPs.executeQuery();
                           while (preqRs.next()) {
                        	   ArrayList<String> temp = new ArrayList<>();
                        	   String courseId = preqRs.getString("courseId");
                        	   String preqId = preqRs.getString("prerequisiteID");
                        	   temp.add(courseId);
                        	   temp.add(preqId);
                        	   adjList.add(temp);
                           }
                           
                            if (detailRs.next()) {
                                String courseDescription = detailRs.getString("description");
                %>
                                <h2 class="text-xl font-bold mb-4"><%= selectedCourse %></h2>
                                <p><%= courseDescription %></p>
                                <div id="container" style="width: 100%; height: 74vh; background: white"></div>
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


    <!-- Script to generate the graph -->
    <script>
    
      const graph = new graphology.Graph();
      const url = new URL(window.location.href);
      const params = new URLSearchParams(url.search);
      const selectedCourse = params.get('selectedCourse');
      <% 
        // Fetch courses from the database

        try {
            String dburl = "jdbc:mysql://localhost:3306/cs157ateam5";
            String dbuname = "root";
            String dbpassword = "password";
            PreparedStatement preqPs = null;
            ResultSet preqRs = null;
            int xCoord = 0;
            int yCoord = 0;
            int step = 50; 
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(dburl, dbuname, dbpassword);

            System.out.println("selectedCourse" + selectedCourse);
            String preqQuery = 
            		
            	    "WITH RECURSIVE CourseGraph AS ( " +
            	    "    SELECT courseId, prerequisiteID " +
            	    "    FROM cs157ateam5.prerequisites " +
            	    "    WHERE courseId = '" + selectedCourse + "' " +
            	    "    UNION ALL " +
            	    "    SELECT c.courseId, c.prerequisiteID " +
            	    "    FROM cs157ateam5.prerequisites c " +
            	    "    INNER JOIN CourseGraph cg " +
            	    "    ON c.courseId = cg.prerequisiteID " +
            	    ") " +
            	    "SELECT courseId, prerequisiteID " +
            	    "FROM CourseGraph;";
           preqPs = con.prepareStatement(preqQuery);
           
           preqRs = preqPs.executeQuery();
           HashSet<String> found = new HashSet<>();
           HashMap<String, Integer> nodeLevels = new HashMap<>();
           HashMap<Integer, Integer> levelPositions = new HashMap<>();
           HashMap<String, HashSet<String>> edges = new HashMap<>();
           int xStep = 50;
           int yStep = 50;
           while (preqRs.next()) {
        	    String courseId = preqRs.getString("courseId");
        	    String preqId = preqRs.getString("prerequisiteID");

        	    int courseLevel = nodeLevels.getOrDefault(courseId, 0);
        	    int preqLevel = courseLevel + 1;

        	    if (found.add(courseId)) {
        	        int position = levelPositions.getOrDefault(courseLevel, 0);
        	        xCoord = position * xStep;
        	        yCoord = courseLevel * yStep;
        	        
        	        out.println("graph.addNode(\"" + courseId + "\", {");
        	        out.println("    label: \"" + courseId + "\",");
        	        out.println("    x: " + xCoord + ",");
        	        out.println("    y: " + yCoord + ",");
        	        out.println("    size: 10,");
        	        out.println("    color: \"#ff0000\"");
        	        out.println("});");
        	        
        	        levelPositions.put(courseLevel, position + 1);
        	    }

        	    if (found.add(preqId)) {
        	        int position = levelPositions.getOrDefault(preqLevel, 0);
        	        xCoord = position * xStep;
        	        yCoord = preqLevel * yStep;

        	        out.println("graph.addNode(\"" + preqId + "\", {");
        	        out.println("    label: \"" + preqId + "\",");
        	        out.println("    x: " + xCoord + ",");
        	        out.println("    y: " + yCoord + ",");
        	        out.println("    size: 10,");
        	        out.println("    color: \"#009900\"");
        	        out.println("});");
        	        
        	        nodeLevels.put(preqId, preqLevel);
        	        levelPositions.put(preqLevel, position + 1);
        	    }

        	    edges.putIfAbsent(courseId, new HashSet<>());
        	    if (!edges.get(courseId).contains(preqId)) {
        	        edges.get(courseId).add(preqId);

        	        out.println("graph.addEdge(\"" + courseId + "\", \"" + preqId + "\", {");
        	        out.println("    size: 5,");
        	        out.println("    color: \"purple\"");
        	        out.println("});");
        	    }
        	}
            
           
            // Variables for positioning
            // int nodeCount = 0;
            // int totalNodes = 0;
            // First, count the total number of nodes
            // while (rs.next()) {
                // totalNodes++;
            // }
            // Reset the cursor to the beginning
            // rs.beforeFirst();

            // double angleIncrement = (2 * Math.PI) / totalNodes;
            // double radius = 100;

             // while (rs.next()) {
                 //String courseID = rs.getString("courseID");

                // Calculate positions
                 //double angle = nodeCount * angleIncrement;
                 //double x = radius * Math.cos(angle);
                 //double y = radius * Math.sin(angle);
                //nodeCount++;
            //}
            
         	
        } catch (Exception e) {
            e.printStackTrace();
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
/*       const edges = [
  	    { from: "CS116A", to: "CS146" },
  	    { from: "CS116B", to: "CS116A" },
  	    { from: "CS122", to: "CS146" },
  	    { from: "CS123A", to: "CS46B" },
  	    { from: "CS123B", to: "CS123A" },
  	    { from: "CS131", to: "CS46B" },
  	    { from: "CS133", to: "CS146" },
  	    { from: "CS134", to: "CS146" },
  	    { from: "CS134", to: "CS151" },
  	    { from: "CS136", to: "CS146" },
  	    { from: "CS144", to: "CS46B" },
  	    { from: "CS146", to: "CS46B" },
  	    { from: "CS147", to: "CS47" },
  	    { from: "CS149", to: "CS146" },
  	    { from: "CS149", to: "CS47" },
  	    { from: "CS151", to: "CS46B" },
  	    { from: "CS152", to: "CS151" },
  	    { from: "CS153", to: "CS146" },
  	    { from: "CS153", to: "CS154" },
  	    { from: "CS153", to: "CS47" },
  	    { from: "CS154", to: "CS46B" },
  	    { from: "CS155", to: "CS146" },
  	    { from: "CS156", to: "CS146" },
  	    { from: "CS157A", to: "CS146" },
  	    { from: "CS157B", to: "CS157A" },
  	    { from: "CS157C", to: "CS157A" },
  	    { from: "CS158A", to: "CS146" },
  	    { from: "CS158A", to: "CS47" },
  	    { from: "CS158B", to: "CS158A" },
  	    { from: "CS159", to: "CS146" },
  	    { from: "CS160", to: "CS146" },
  	    { from: "CS160", to: "CS151" },
  	    { from: "CS161", to: "CS160" },
  	    { from: "CS166", to: "CS146" },
  	    { from: "CS166", to: "CS47" },
  	    { from: "CS168", to: "CS166" },
  	    { from: "CS171", to: "CS146" },
  	    { from: "CS174", to: "CS46B" },
  	    { from: "CS175", to: "CS46A" },
  	    { from: "CS175", to: "CS47" },
  	    { from: "CS176", to: "CS146" },
  	    { from: "CS46B", to: "CS46A" },
  	    { from: "CS47", to: "CS46B" }
  	]; */
      
   // Add edges to the graph dynamically
	  const sigmaInstance = new Sigma(graph, document.getElementById("container"));
	  
      sigmaInstance.on("clickNode", (event) => {
    	  const nodeId = event.node;
    	  console.log(nodeId);
    	  window.location.href = "homepage.jsp?selectedCourse="+ nodeId;
    	});
      
      function search_course() {
    	    const input = document.getElementById("searchbar");
    	    const filter = input.value.toLowerCase();

    	    const courses = document.querySelectorAll(".course");

    	    courses.forEach(course => {
    	        const buttonText = course.querySelector("button").textContent.toLowerCase();
    	        if (buttonText.includes(filter)) {
    	            course.style.display = "";
    	        } else {
    	            course.style.display = "none";
    	        }
    	    });
    	}
    </script>
</body>
</html>