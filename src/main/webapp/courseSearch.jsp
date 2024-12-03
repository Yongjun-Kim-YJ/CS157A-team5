<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Course Search</title>
	<link rel="stylesheet" href="searchstyle.css">
</head>
<body>
	<form action="CourseList" method="post">
		<nav class="searchbar">
			Search for course:
			<input type="text" name="keyword" placeholder="keyword">
			<input type="submit" value="&#128269">
		</nav>
		<table>
			<%
			String dburl="jdbc:mysql://localhost:3306/cs157ateam5";
			String dbuname="root";
			String dbpassword="password";
			try {
				java.sql.Connection con = DriverManager.getConnection(dburl + "?autoReconnect=true&useSSL=false", dbuname, dbpassword);
				String sql = "SELECT * FROM courses";
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet results = ps.executeQuery();
				String prevCourse = ".";
				String addedCourse = "";
				while (results.next()) {
					String[] nextCourse = {results.getString(1), results.getString(2), results.getInt(3) + "", results.getString(4)};
					if (prevCourse.charAt(0) != nextCourse[0].charAt(0)) {
						out.println("<tr><td></td></tr><tr><td><tr><td></td></tr><tr><th>" + nextCourse[0].charAt(0) + "</th></tr>");
						%>
							<tr class="tablehead">
								<td>Course ID</td>
								<td>Course Name</td>
								<td>Credits</td>
								<td>Description</td>
								<td>Prerequisites</td>
							</tr>
						<%
					}
					String course = results.getString(1);
					out.print("<tr>" + "<td>" + course + "</td><td>" + results.getString(2) + "</td><td>"
						+ results.getInt(3) + "</td><td>" + results.getString(4) + "</td>");
					String courseID = (String)request.getAttribute("addedCourse");
					String addedNot = (String)request.getAttribute("studentID");
					addedCourse = (String)request.getAttribute("allAddedCourses");
					String prereqSQL = "SELECT prerequisiteID FROM prerequisites WHERE courseID LIKE ?";
					PreparedStatement pre = con.prepareStatement(prereqSQL);
					pre.setString(1, "%" + course + "%");
					ResultSet preResults = pre.executeQuery();
					if (!preResults.isBeforeFirst()) {
						out.print("<td>None</td>");
					} else {
						out.print("<td>");
						while (preResults.next()) {
							out.print(preResults.getString(1) + " ");
						}
						out.print("</td>");
					}
					
					if ((courseID != null && courseID.equals(course)) || (addedCourse != null && addedCourse.contains(course))) {
						out.print("<td>Added!</td></tr>");
					} else {
						addedCourse = addedCourse + courseID;
					%>
						<td>
							<form action="CourseList" method="post">
							<input type="submit" value="Add course!">
							<input type="hidden" name="addedCourse" value="<%=course%>">
							<input type="hidden" name="studentID" value="<%= session.getAttribute("studentID") %>">
							<input type="hidden" name="allAddedCourses" value="<%=addedCourse%>">
							</form>
						</td></tr>
						<%
					}
					prevCourse = nextCourse[0];
				}
				results.close();
				ps.close();
				con.close();
			} catch (SQLException e) {
				out.println("Search failed. SQLException caught: " + e.getMessage());
			}
			%>
		</table>
	</form>
</body>
</html>
