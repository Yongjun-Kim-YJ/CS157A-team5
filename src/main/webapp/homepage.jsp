<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page session="true" %>
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
    <div class="bg-gradient-to-r from-purple-600 to-blue-600 text-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16 lg:py-20">
        <div class="text-center">
          <h1 class="text-4xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight mb-4">
            Welcome 
            <%
		        String username = (String) session.getAttribute("username");
		        out.println("<h3>Hello, " + username + "!</h3>");
			%>
          </h1>
          <form action="Logout" method="post">
	        <input type="submit" value="Logout" class="mt-4 px-4 py-2 bg-blue-500 text-white font-bold rounded hover:bg-blue-600">
	    </form>
        </div>
      </div>
    </div>
    <div id="container" style="width: 100%; height: 400px; background: white"></div>
    <script>
      // Create a graphology graph
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