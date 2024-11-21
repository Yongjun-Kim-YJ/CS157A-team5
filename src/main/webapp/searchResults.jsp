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
		<nav class="searchbar" style="width: 100%">
			<table>
				<tr>
					<td>Search for course:</td>
					<td><input type="text" name="keyword" placeholder="keyword"></td>
					<input type="hidden" name="prevSearch" value="<%=(String)request.getAttribute("keyword")%>">
					<input type="hidden" name="allAddedCourses" value="<%String addedCourse = (String)request.getAttribute("allAddedCourses");%>">
					<td><input type="submit" value="&#128269"></td>
				</tr>
			</table>
		</nav>
		<table>
			<%
			String dburl="jdbc:mysql://localhost:3306/cs157ateam5";
			String dbuname="root";
			String dbpassword="password";
			try {
				String keyword = (String)request.getAttribute("keyword");
				java.sql.Connection con = DriverManager.getConnection(dburl + "?autoReconnect=true&useSSL=false", dbuname, dbpassword);
				String sql = "SELECT * FROM courses WHERE courseID LIKE ? OR courseName LIKE ? OR description LIKE ?";
				PreparedStatement ps = con.prepareStatement(sql);
				ps.setString(1, "%" + keyword + "%");
				ps.setString(2, "%" + keyword + "%");
				ps.setString(3, "%" + keyword + "%");
				ResultSet results = ps.executeQuery();
				if (results.isBeforeFirst()) {
					out.print("<tr class=\"tablehead\"><td>Course ID</td><td>Course Name</td><td>Credits</td><td>Description</td><td>Prerequisites</td></tr>");
				} else {
					//Temporary formatting, fix later
					out.print("<tr><td></td><td></td><td></td><td>No courses found!" + "</td><td>General Kenobi. Years ago you served my father in the Clone Wars. Now he begs you to help him in his struggle against the Empire. I regret that I am unable to present my father's request to you in person, but my ship has fallen under attack, and I'm afraid my mission to bring you to Alderaan has failed. I have placed information vital to the survival of the Rebellion into the memory systems of this R2 unit. My father will know how to retrieve it. You must see this droid safely delivered to him on Alderaan. This is our most desperate hour. Help me, Obi-Wan Kenobi. You're my only hope.</td></tr>");
				}
				while (results.next()) {
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
							<form action="SearchList" method="post">
							<input type="submit" value="Add course!">
							<input type="hidden" name="addedCourse" value="<%=course%>">
							<input type="hidden" name="studentID" value="<%= session.getAttribute("studentID") %>">
							<input type="hidden" name="prevSearch" value="<%=keyword%>">
							<input type="hidden" name="allAddedCourses" value="<%=addedCourse%>">
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
		<form action="SearchList" method="post">
			<input type="submit" name="goBack" value="New search in all courses">
			<input type="hidden" name="prevSearch" value="<%=(String)request.getAttribute("keyword")%>">
			<input type="hidden" name="allAddedCourses" value="<%=(String)request.getAttribute("allAddedCourses")%>">		
		</form>
	</form>
</body>
</html>