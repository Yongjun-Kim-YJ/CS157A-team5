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
            <form action="userCourses.jsp" method="get">
                <button class="text-white px-4 py-2 bg-blue-500 rounded hover:bg-blue-600">
                    View Added Courses
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
                <div class="flex items-center">
    <div class="flex-1 mr-2 mb-4">
        <button 
            id="ai-button" 
            onclick="genAISuggestions()"
            class="bg-gradient-to-r from-purple-600 to-blue-600 w-full text-white px-4 py-2 bg-green-500 rounded hover:bg-green-600">
            AI
        </button>
    </div>

    <div class="flex-8 w-full mb-4">
        <input 
            id="searchbar" 
            onkeyup="search_course()" 
            type="text" 
            name="search" 
            placeholder="Search Courses" 
            class="
                block 
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
    </div>
</div>
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
            <div class="w-3/4 border border-gray-300 p-4 rounded bg-white flex flex-col">
                <%
                    String selectedCourse = request.getParameter("selectedCourse");
                    if (selectedCourse != null) {
                        PreparedStatement detailPs = null;
                        ResultSet detailRs = null;
                        PreparedStatement preqPs = null;
                        ResultSet preqRs = null;
                        PreparedStatement semesterPs = null;
                        ResultSet semesterRs = null;
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
                           
                           String semesterQuery = "SELECT semester FROM semesters WHERE courseID=?";
                           semesterPs = con.prepareStatement(semesterQuery);
                           semesterPs.setString(1, selectedCourse);
                           semesterRs = semesterPs.executeQuery();
                           StringBuilder semesters = new StringBuilder();

                           while (semesterRs.next()) {
                               if (semesters.length() > 0) {
                                   semesters.append(", ");
                               }
                               semesters.append(semesterRs.getString("semester"));
                           }
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
                                <p><strong>Available Semesters:</strong> <%= semesters.length() > 0 ? semesters.toString() : "None" %></p>
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
            PreparedStatement userCoursesPs = null;
            ResultSet userCoursesRs = null;
            int xCoord = 0;
            int yCoord = 0;
            int step = 50; 
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(dburl, dbuname, dbpassword);
			
         	// Fetch user's completed courses
            String userCoursesQuery = "SELECT courseID FROM usercourses WHERE studentID = ?";
            userCoursesPs = con.prepareStatement(userCoursesQuery);
            userCoursesPs.setString(1, (String)session.getAttribute("studentID"));
            userCoursesRs = userCoursesPs.executeQuery();
            
            // Create a HashSet to store user's completed courses
            HashSet<String> userCourses = new HashSet<>();
            while (userCoursesRs.next()) {
                userCourses.add(userCoursesRs.getString("courseID"));
            }
            
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
        	    
        	    String nodeColor = userCourses.contains(courseId) ? "\"#009900\"" : "\"#ff0000\"";
        	    String preqColor = userCourses.contains(preqId) ? "\"#009900\"" : "\"#ff0000\"";

        	    if (found.add(courseId)) {
        	        int position = levelPositions.getOrDefault(courseLevel, 0);
        	        xCoord = position * xStep;
        	        yCoord = courseLevel * yStep;
        	        
        	        out.println("graph.addNode(\"" + courseId + "\", {");
        	        out.println("    label: \"" + courseId + "\",");
        	        out.println("    x: " + xCoord + ",");
        	        out.println("    y: " + yCoord + ",");
        	        out.println("    size: 10,");
        	        out.println("    color: " + nodeColor);
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
        	        out.println("    color: " + preqColor);
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
	  const sigmaInstance = new Sigma(graph, document.getElementById("container"),{
		  minCameraRatio: 1.1,
		  maxCameraRatio: 1.1,
		  allowWheel: false
	  });
  	
  	// Fix graph's position
  	const camera = sigmaInstance.getCamera();

 	const minX = 0.5;
 	const maxX = 0.5;
 	const minY = 0.5;
 	const maxY = 0.5;

	camera.on("updated", () => {
   		const state = camera.getState();
   		let { x, y, angle, ratio } = state;

   		if (x < minX) x = minX;
   		if (x > maxX) x = maxX;
   		if (y < minY) y = minY;
   		if (y > maxY) y = maxY;

   		if (x !== state.x || y !== state.y) {
     		camera.setState({ x, y, angle, ratio });
   		}
 	});

	  
	
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
      function genAISuggestions() {
    	    const input = document.getElementById("searchbar");
    	    const api_url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=";
			console.log(input.value);
    	    const payload = {
    	      contents: [
    	        {
    	          role: "user",
    	          parts: [
    	        	  {text: "Only give me a list of courseIDs from cs157ateam5.courses that responds to the natural language query:\n{"
    	        		  + input.value
    	        		  + "} in the format of \"courseID1, courseID2, ..\"\n\ncs157ateam5.courses data:\n```\ncourseID,courseName,credits,description\nAAS1,\"Introduction to Asian American Studies\",3,\"Introductory examination of Asian Pacific Islander Desi/Americans (APID/A) through U.S.-national and transnational frameworks, concerned with contests over the production of racial knowledge, power, and citizenship and belonging. Develops an account of racialization beyond the black-white binary in the context of US war and empire in Asia and the Pacific Islands, settler colonialism, globalization, migration, and popular culture. \"\nBIOL10,\"The Living World\",3,\"Provides students with an understanding of the most fundamental concepts of modern biology including ecology (the interaction between organisms and their environment), human inheritance, the structure and function of living organisms, evolution, strategies for survival and reproduction, and biotechnology.\"\nCCS30,\"Race and Ethnicity in Public Space\",3,\"This course focuses on race and ethnicity. Using readings, field trips, media images, and course discussion students learn about racialization in American society. We explore uses of racial and ethnic categories and their institutionalization in everyday life.\"\nCHEM1A,\"General Chemistry\",5,\"Topics including stoichiometry, reactions, atomic structure, periodicity, bonding, states of matter, energy changes, solutions using organic and inorganic examples. Lab program complements lecture. \"\nCOMM20,\"Public Speaking\",3,\"Principles of rhetoric applied to oral communication; selecting, analyzing, adapting, organizing and delivering ideas effectively.\"\nCOMM21,\"Performing Culture and Society\",3,\"Live performance is used as a method for exploring human behavior as it occurs within contemporary cultures and societies. Performance assignments will draw from among the following: performance of texts, street performance, personal narrative, oral history, everyday life, and social justice.\"\nCS100W,\"Technical Writing Workshop\",3,\"Advanced writing through preparation of technical reports and presentations. Improving skills for writing subject-related reports, project proposals and personal resumes through practice and evaluation. Course assignments will be related to issues concerning careers in computer science.\"\nCS116A,\"Introduction to Computer Graphics\",3,\"Vector geometry, geometric transformations and the graphics pipeline. Basic raster graphics algorithms for drawing discrete lines, clipping, visible surface determination and shading. Display of curves and surfaces. Graphics data structures.\"\nCS116B,\"Computer Graphics Algorithms\",3,\"In-depth discussion of algorithms and techniques used in computer graphics and their implementation. Topics include: animation, fractals, anti-aliasing, fill algorithms, visible surface algorithms, color and shading, ray tracing, radiosity and texture maps. Substantial programming required.\"\nCS122,\"Advanced Programming with Python\",3,\"Advanced features of the Python programming language with emphasis on programming practice. Course involves substantial programming projects in Python.\"\nCS123A,\"Bioinformatics I\",3,\"Introduction to algorithms, tools, and databases of Bioinformatics. Biological foundations: central dogma; sequence databases; pairwise alignment algorithms and tools; Blast; phylogenetics. Possible additional topics: protein structure, multiple sequence alignment, next-gen sequencing, epigenetics, CRISPR. Project applying these approaches to real-world problems.\"\nCS123B,\"Bioinformatics II\",3,\"Advanced Bioinformatics algorithms, tools, databases. Biological background; protein structure/function; sequencing technology; sequence identification; transcriptomics; metagenomics; CRISPR. Possible additional topics: functional genomics; protein networks; drug discovery; pathway analysis; immunoinformatics; analysis pipelines; machine learning applications. Project applying advanced approaches to real-world problems.\"\nCS131,\"Processing Big Data - Tools and Techniques\",3,\"In-depth study of essential tools and techniques for processing big data over the UNIX operating system and/or other operating systems. On UNIX, it includes using grep, sed, awk, join, and programming advanced shell scripts for manipulating big data.\"\nCS133,\"Introduction to Data Visualization\",3,\"Topics in data analysis and visualization. Covers tools and techniques to efficiently analyze and visualize large volumes of data in meaningful ways to help solve complex problems in fields such as life sciences, business, and social sciences.\"\nCS134,\"Computer Game Design and Programming\",3,\"Architectures and object-oriented patterns for computer game design. Animation, simulation, user interfaces, graphics, and intelligent behaviors. Team projects using an existing game engine framework.\"\nCS136,\"Introduction to Computer Vision\",3,\"Fundamental and advanced Computer Vision algorithms. Basic image processing techniques (image convolution, and region and edge detection). Complex vision algorithms for contour detection, depth perception, dynamic vision, and object recognition. Core topics (color processing, texture analysis, and visual geometry).\"\nCS144,\"Advanced C++ Programming\",3,\"Advanced features of C++, including operator overloading, memory management, templates, exceptions, multiple inheritance, RTTI, namespaces, tools.\"\nCS146,\"Data Structures and Algorithms\",3,\"Implementations of advanced tree structures, priority queues, heaps, directed and undirected graphs. Advanced searching and sorting techniques (radix sort, heapsort, mergesort, and quicksort). Design and analysis of data structures and algorithms. Divide-and-conquer, greedy, and dynamic programming algorithm design techniques.\"\nCS147,\"Computer Architecture\",3,\"Introduction to the basic concepts of computer hardware structure and design, including processors and arithmetic logic units, pipelining, and memory hierarchy.\"\nCS149,\"Operating Systems\",3,\"Fundamentals: Contiguous and non-contiguous memory management; processor scheduling and interrupts; concurrent, mutually exclusive, synchronized and deadlocked processes; parallel computing; files. Substantial programming project required.\"\nCS151,\"Object-Oriented Design\",3,\"Design of classes and interfaces. Object-oriented design methodologies and notations. Design patterns. Generics and reflection. Exception handling. Concurrent programming. Graphical user interface programming. Software engineering concepts and tools. Required team-based programming assignment.\"\nCS152,\"Programming Paradigms\",3,\"Programming language syntax and semantics. Data types and type checking. Scope, bindings, and environments. Functional and logic programming paradigms, and comparison to other paradigms. Extensive coverage of a functional language.\"\nCS153,\"Concepts of Compiler Design\",3,\"Theoretical aspects of compiler design, including parsing context free languages, lexical analysis, translation specification and machine-independent code generation. Programming projects to demonstrate design topics.\"\nCS154,\"Formal Languages and Computability\",3,\"Finite automata, context-free languages, Turing machines, computability.\"\nCS155,\"Introduction to the Design and Analysis of Algorithms\",3,\"Algorithm design techniques: dynamic programming, greedy algorithms, Euclidean and extended Euclidean algorithms, Discrete and Fast Fourier transforms. Analysis of algorithms, intractable problems and NP-completeness. Additional topics selected from: selection algorithms and adversary arguments, approximation algorithms, parallel algorithms, and randomized algorithms.\"\nCS156,\"Introduction to Artificial Intelligence\",3,\"Basic concepts and techniques of artificial intelligence: problem solving, search, deduction, intelligent agents, knowledge representation. Topics chosen from logic programming, game playing, planning, machine learning, natural language, neural nets, robotics.\"\nCS157A,\"Introduction to Database Management Systems\",3,\"Relational data model. Relational algebra. Standard SQL. Design theory. Conceptual data modeling. Integrity constraints and triggers. Views and indexes. Transactions. Distributed data management. Interactive and programmatic interfaces to database systems. Application programming project using a prominent database system.\"\nCS157B,\"Database Management Systems II\",3,\"Survey course. Object-oriented data model, definition language, query language. Object relational database systems. Database trends like active, temporal, multimedia, deductive databases. Web database topics, namely, architectures, introduction to interface languages. Team projects.\"\nCS157C,\"NoSQL Database Systems\",3,\"NoSQL Data Models: Key-Value, Wide Column, Document, and Graph Stores. CAP Theorem. Distribution Models. Current NoSQL Databases: Configuration and Deployment, CRUD operations, Indexing, Replication, and Sharding. Public Data Sets. API Coding and Application Development.  NoSQL in the Cloud. Team Project.\"\nCS158A,\"Computer Networks\",3,\"Introduction to computer networks, including network layered architectures, local and wide area networks, mobile wireless networks, Internet TCP/IP protocol suite, network resource management, network programming, network performance, network security, network applications.\"\nCS158B,\"Computer Network Management\",3,\"Principles and technologies of network management: reference models, functions (fault, configuration, performance, security and accounting management), management information, communication protocols, integration, and assessment. Network security and cyber defense: cryptography, key distribution, authentication protocols, network attacks, access control, and example systems.\"\nCS159,\"Introduction to Parallel Processing\",3,\"Major parallel architectures: shared memory, distributed memory, SIMD, MIMD. Parallel algorithms: techniques for scientific applications, measures of performance. Parallel programming: principles and implementations in various languages. Assignments on available parallel and vector computers.\"\nCS160,\"Software Engineering\",3,\"Software engineering principles, software process and process models, requirements elicitation and analysis, design, configuration management, quality control, project planning, social and ethical issues. Required team-based software development, including written requirements specification and design documentation, oral presentation, and tool use.\"\nCS161,\"Software Project\",3,\"A substantial project based on material from an advanced area of computer science. Includes lectures on the project topic and the design and testing of software systems. At least 50% of the course grade to be based on the project.\"\nCS166,\"Information Security\",3,\"Fundamental security topics including cryptography, authentication, access control, network security, security protocols, and software security. Networking basics are covered. Additional security topics selected from multilevel security, biometrics, blockchain, machine learning, information warfare, e-commerce, intrusion detection, system evaluation and assurance.\"\nCS168,\"Blockchain and Cryptocurrencies\",3,\"Cryptocurrencies and the blockchain. Centralized clearinghouse solutions vs. distributed consensus solutions. The blockchain and its validation approaches: proof-of-work, proof-of-stake, proof-of-storage, etc. Cryptocurrency wallets. Smart contracts.\"\nCS171,\"Introduction to Machine Learning\",3,\"Covers a selection of classic machine learning techniques including backpropagation and several currently popular neural networking and deep learning architectures. Hands-on lab exercises are a significant part of the course. A major project is required.\"\nCS174,\"Server-side Web Programming\",3,\"Development and deployment of multi-tier web-based applications. Introduction to HTML, XML, enterprise design patterns, web services and database access.\"\nCS175,\"Mobile Device Development\",3,\"Mobile Platform APIs including those for networking, touch, graphics, data, location, and camera. Testing and profiling on devices and emulators/simulators.\nMobile Platform APIs including those for networking, touch, graphics, data, location, and camera. Testing and profiling on devices and emulators/simulators.\"\nCS176,\"Introduction to Social Network Analysis\",3,\"The Web and social networks are complex networks. We study them by unifying tools from different disciplines: computer science, economics, and social sciences. Topics include graph theory, information networks, search, advertisement, auctions.\"\nCS46A,\"Introduction to Programming\",4,\"Introduction to programming for anyone new to the field or who needs a refresher with basic Java programming syntax, object-oriented paradigm, control structures, iteration, etc. Hands-on activities in writing, compiling, executing, and debugging programs for solving real-world problems. \"\nCS46B,\"Introduction to Data Structures\",4,\"Stacks and queues, recursion, lists, dynamic arrays, binary search trees. Iteration over collections. Hashing. Searching, elementary sorting. Big-O notation. Standard collection classes. Weekly hands-on activity.\"\nCS47,\"Introduction to Computer Systems\",3,\"Instruction sets, assembly language and assemblers, linkers and loaders, data representation and manipulation, interrupts, pointers, function calls, argument passing, and basic gate-level digital logic design.\"\nENGL2,\"Critical Thinking and Writing\",3,\"Focuses on the relationship between language and logic in composing arguments. Students learn various methods of effective reasoning and appropriate rhetorical strategies to help them invent, demonstrate, and express arguments clearly, logically, and persuasively. \"\nGEOL1,\"General Geology\",4,\"Examination of geologic processes and materials, including volcanoes, earthquakes, rock formation, oceans, streams, and plate tectonics and their importance to society.\"\nGEOL5,\"Sustainability, Human Development, and the Earth\",3,\"Introductory course examining the role and interaction of the natural world on the physiological, social, and psychological development of human beings within the context of the environmental, social, and academic community system.\"\nJS171,\"Human Rights and Justice\",3,\"Interdisciplinary exploration of human rights instruments, institutions, and notable human rights campaigns. The historical development of human rights and contemporary threats to the realization of fundamental dignity for humans and non-humans will also be explored. \"\nKIN37,\"Fitness Walking\",1,\"Fitness walking is a low-impact conditioning activity designed to develop cardiovascular fitness. \"\nLING21,\"Critical Thinking and Language\",3,\"Exploring systems of language and logic in oral and written discourse, with a focus on the role of shared cultural assumptions, language style and the media of presentation in shaping the form and content of argumentation.\"\nLSTP10,\"Chronicles of Education\",3,\"This course uses chronicles, or narratives, to expand traditional views about the sites where education takes place and to articulate the educational forces that shape individuals and societies.\"\nMATH12,\"Number Systems\",3,\"Structure of the real number system, numeration systems, elementary number theory, and problem-solving techniques; technology integrated throughout the course.  \"\nMATH142,\"Introduction to Combinatorics\",3,\"Sets, permutations, combinations, probability, mathematical induction, counting techniques, generating functions, partitions, recurrence relations, inclusion-exclusion. Polya’s theorem and applications to computer science, mathematics, engineering and physical sciences.\"\nMATH31,\"Calculus II\",4,\"Definite and indefinite integration with applications. Sequences and series. Graphical, algebraic and numerical methods of solving problems. \"\nMUSC10A,\"Music Appreciation\",3,\"General survey of Western music focusing on recorded and live performances.\"\nMUSC10C,\"Pop and Rock in the U.S.\",3,\"Examines the musical attributes, structures, and stylistic choices in American popular music, as well as the historical and cultural underpinnings of the originating forces and influences and how they affect or are affected by social/cultural norms and political and economic developments.\"\nPHIL12,\"Human Nature and the Meaning of Life\",3,\"Survey of philosophical discussions of various topics related to the definition and understanding of human nature and the meaning of life, including questions such as: In what ways or to what degree (if any) are human beings unique among other forms of life? What is the role of desire in human nature? What is the nature of and/or limitations on human freedom? In what ways are freedom and moral responsibility linked? What is the Meaning of Life? \"\nPHYS1,\"Elementary Physics\",3,\"Mechanics, energy, electricity, magnetism, optics, atomic and nuclear physics, properties of matter; emphasizes practical applications of physics principles to contemporary problems. \"\nPOLS16,\"Power and Ideas in American Politics\",3,\"Study of power, institutions, and creative ideas in American political thought. Engages work of intellect and imagination in political documents, essays, speeches, letters, short works of fiction, poems, and manifestos.  \"\nPSYC1,\"Introduction to Psychology\",3,\"Psychology is the scientific study of behavior and mental processes. The content focuses on the exploration of major psychological theories and concepts, methods, and research findings in psychology. Topics include the biological bases of behavior, perception, cognition and consciousness, learning, memory, emotion, motivation, development, personality, social psychology, psychological disorders and therapeutic approaches to treatment, and applied psychology.\"\nRECL10,\"Creating a Meaningful Life\",3,\"Study how a meaningful life relates to the freedom to pursue happiness. Examines personal, social, and cultural bases for a creative and successful lifestyle. Learn to recognize and foster creative potential for lifelong personal growth, meaningful rewards, and leisure enjoyment.\"\nSTAT95,\"Elementary Statistics\",3,\"Hypothesis testing and predictive techniques to facilitate decision-making; organization and classification of data, descriptive and inferential statistics, central tendency, variability, probability and sampling distributions, graphic representation, correlation and regression, chi-square, t-tests, and analysis of variance. Computer use in analysis and interpretation.\"\n```\nEnsure that the query always returns something that is not null"},    	          ]
    	        },
    	      ],
    	      generationConfig: {
    	        temperature: 0,
    	        topK: 40,
    	        topP: 0.95,
    	        maxOutputTokens: 8192,
    	        responseMimeType: "text/plain"
    	      }
    	    };

    	    fetch(api_url, {
    	      method: "POST",
    	      headers: {
    	        "Content-Type": "application/json"
    	      },
    	      body: JSON.stringify(payload)
    	    })
    	      .then(response => {
    	        if (!response.ok) {
    	          throw new Error(`HTTP error! status: ${response.status}`);
    	        }
    	        return response.json();
    	      })
    	      .then(data => {
    	    	console.log(data["candidates"][0]["content"]["parts"][0]["text"]);
    	    	  const terms = new Set(
    	    			    data["candidates"][0]["content"]["parts"][0]["text"]
    	    			        .split(",")
    	    			        .map(item => item.trim().toLowerCase())
    	    			);
    	    	  terms.forEach(element => {
    	    		  console.log("set" + element);
    	    		});

    	    			document.querySelectorAll(".course").forEach(course => {
    	    			    try {
    	    			        const button = course.querySelector("button");
    	    			        if (!button) return;

    	    			        const buttonText = button.textContent.split(":")[0].toLowerCase().trim();
    	    			        console.log(buttonText);
    	    			        console.log(terms.has(buttonText));
    	    			        course.style.display = terms.has(buttonText) ? "" : "none";
    	    			    } catch (error) {
    	    			        console.error(`Error processing course:`, course, error);
    	    			    }
    	    			});
    	        
    	      })
    	      .catch(error => {
    	        console.error("Error:", error);
    	      });
			
    	}
      
      //Scroll to the bottom when click the course
      window.addEventListener("load", function() {
    	    window.scrollTo(0, document.body.scrollHeight);
    	  });
    </script>
</body>
</html>