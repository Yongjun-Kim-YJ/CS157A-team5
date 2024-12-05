<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Search Results</title>
	<link rel="stylesheet" href="searchstyle.css">
</head>
<body>
	<form action="SearchList" method="post">
	<nav class="titlehead">
		<a href="homepage.jsp" class="homebutton">Course Prerequisite Guide Home</a>
	</nav>
	<div class="majorcredits">
		Required credits for your major
		<%String majorName = (String)session.getAttribute("majorName");
		String majorCredits = (String)session.getAttribute("majorCredits");
		out.print(" " + majorName + " is " + majorCredits + " credits");%>
	</div>
	<nav class="searchbar">
		<p>
			Search for course:
			<input type="text" name="keyword" placeholder="keyword">
			<input type="hidden" name="prevSearch" value="<%=(String)request.getAttribute("area")%>">
			<input type="submit" value="&#128269">
		</p>
		<p>
			Search by GE Core area:
			<select id="area" name="area">
				<option value="">Select area</option>
				<option value="A">A</option>
				<option value="B">B</option>
				<option value="C">C</option>
				<option value="D">D</option>
				<option value="E">E</option>
				<option value="F">F</option>
			</select>
			<input type="submit" value="&#128269">
		</p>
	</nav>
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
				String area = (String)request.getAttribute("area");
				con = DriverManager.getConnection(dburl + "?autoReconnect=true&useSSL=false", dbuname, dbpassword);
				sql = "SELECT * FROM ge WHERE geArea LIKE ?";
				ps = con.prepareStatement(sql);
				ps.setString(1, "%" + area + "%");
				results = ps.executeQuery();
				out.print("<p class=\"searchline\">Courses in GE core category " + area + "</p>");
				if (results.isBeforeFirst()) {
					out.print("<tr class=\"tablehead\"><td>Course ID</td><td>Course Name</td><td>Credits</td><td>Description</td><td>Prerequisites</td><td>GE Area</td></tr>");
				} else {
					out.print("<p class=\"searchline\">No courses found for \"" + area + "\"</p>");
				}
				while (results.next()) {
					String course = results.getString(1);
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
					out.print("<td>" + results.getString(5) + "</td>");
					if (userCourses.contains(course)) {
						out.print("<td>Added!</td></tr>");
					} else {
					%>
						<td>
							<form action="SearchList" method="post">
							<input class="addbtn" type="submit" value="Add course!">
							<input type="hidden" name="addedCourse" value="<%=course%>">
							<input type="hidden" name="studentID" value="<%=(String)session.getAttribute("studentID") %>">
							<input type="hidden" name="prevSearch" value="<%=area%>">
							</form>
						</td></tr>
						<%
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
		<div class="backbtndiv">
		<form action="SearchList" method="post">
			<input class="backbtn" type="submit" name="goBack" value="New search in all courses">
			<input type="hidden" name="prevSearch" value="<%=(String)request.getAttribute("area")%>">
		</form>
		</div>
	</form>
</body>
</html>