<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Selected Courses</title>
	<link rel="stylesheet" href="searchstyle.css">
</head>
<body>
	<form action="UserCourseList" method="post">
	<nav class="titlehead">
		<a href="homepage.jsp" class="homebutton">Course Prerequisite Guide Home</a>
	</nav>
	<div class="majorcredits">
		Required credits for your major
		<%String majorName = (String)session.getAttribute("majorName");
		String majorCredits = (String)session.getAttribute("majorCredits");
		out.print(" " + majorName + " is " + majorCredits + " credits");%>
	</div>
		<table>
			<%
			String dburl="jdbc:mysql://localhost:3306/cs157ateam5";
			String dbuname="root";
			String dbpassword="password";
			try {
				java.sql.Connection con = DriverManager.getConnection(dburl + "?autoReconnect=true&useSSL=false", dbuname, dbpassword);
				String sql = "SELECT courseID FROM usercourses WHERE studentID = ?";
				PreparedStatement ps = con.prepareStatement(sql);
				ps.setString(1, (String)session.getAttribute("studentID"));
				ResultSet results = ps.executeQuery();
				String userCourses = "";
				while (results.next()) {
					userCourses = userCourses + results.getString("courseID");
				}
				if (userCourses.isBlank()) {
					out.print("Please add courses first!");
				} else {
				sql = "SELECT courseID FROM completedcourses WHERE studentID = ?";
				ps = con.prepareStatement(sql);
				ps.setString(1, (String)session.getAttribute("studentID"));
				results = ps.executeQuery();
				String completedCourses = "";
				while (results.next()) {
					completedCourses = completedCourses + results.getString("courseID");
				}
				sql = "SELECT * FROM courses";
				ps = con.prepareStatement(sql);
				results = ps.executeQuery();
				%>
					<tr class="tablehead">
						<td>Course ID</td>
						<td>Course Name</td>
						<td>Credits</td>
						<td>Description</td>
						<td>Prerequisites</td>
					</tr>
				<%
				while (results.next()) {
					String[] nextCourse = {results.getString(1), results.getString(2), results.getInt(3) + "", results.getString(4)};
					String course = results.getString(1);
					if (userCourses.contains(course)) {
					out.print("<tr>" + "<td>" + course + "</td><td>" + results.getString(2) + "</td><td>"
						+ results.getInt(3) + "</td><td>" + results.getString(4) + "</td>");
					String courseID = (String)request.getAttribute("addedCourse");
					String addedNot = (String)request.getAttribute("studentID");
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
					if (completedCourses.contains(course)) {
						out.print("<td>Completed!</td>");
					} else {
					%>
						<td>
							<form action="UserCourseList" method="post">
							<input class="completebtn" type="submit" value="Complete!">
							<input type="hidden" name="completedCourse" value="<%=course%>">
							<input type="hidden" name="studentID" value="<%= session.getAttribute("studentID") %>">
							</form>
						</td>
						<%
					}
					%>
						<td>
							<form action="UserCourseList" method="post">
							<input class="deletebtn" type="submit" value="Delete!">
							<input type="hidden" name="deletedCourse" value="<%=course%>">
							<input type="hidden" name="studentID" value="<%= session.getAttribute("studentID") %>">
							</form>
						</td></tr>
						<%
				}
				}
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