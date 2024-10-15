<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Homepage</title>
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
</body>
</html>