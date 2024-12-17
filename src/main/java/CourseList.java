import java.io.IOException;
import java.sql.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Register
 */
@WebServlet("/CourseList")
public class CourseList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CourseList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	private String dburl = "jdbc:mysql://localhost:3306/cs157ateam5";
    private String dbuname = "root";
    private String dbpassword = "password";
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		SearchDao sDao = new SearchDao();
		
		String keyword = request.getParameter("keyword");
		String area = request.getParameter("area");
		
		if (keyword != null && !keyword.isBlank()) {
			keyword = keyword.trim();
			request.setAttribute("keyword", keyword);
			RequestDispatcher rd = request.getRequestDispatcher("searchResults.jsp");
			rd.forward(request, response);
		} else if (area != null && !area.isBlank()) {
			request.setAttribute("area", area);
			RequestDispatcher rd = request.getRequestDispatcher("categoryResults.jsp");
			rd.forward(request, response);
		} else {
			String addCourse = request.getParameter("addedCourse");
			String student = request.getParameter("studentID");
			sDao.addCourse(addCourse, student);
			
			Connection con = null;
            PreparedStatement ps = null;
            PreparedStatement ps2 = null;
            PreparedStatement ps3 = null;
            PreparedStatement ps4 = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(dburl, dbuname, dbpassword);

                // update earnedCredits, remainingCredits
                String getCourseCredits = "SELECT credits FROM courses WHERE courseID = ?";
                ps = con.prepareStatement(getCourseCredits);
                ps.setString(1, addCourse);
                rs = ps.executeQuery();

                int courseCredits = 0;
                if (rs.next()) {
                    courseCredits = rs.getInt("credits");
                }
                rs.close();
                ps.close();

                String selectProgress = "SELECT earnedCredits, remainingCredits FROM progressTracking WHERE studentID = ?";
                ps2 = con.prepareStatement(selectProgress);
                ps2.setString(1, student);
                rs = ps2.executeQuery();

                int earnedCredits = 0;
                int remainingCredits = 0;
                boolean hasRow = false;
                if (rs.next()) {
                    hasRow = true;
                    earnedCredits = rs.getInt("earnedCredits");
                    remainingCredits = rs.getInt("remainingCredits");
                }
                rs.close();
                ps2.close();

               
                earnedCredits += courseCredits;
                if (remainingCredits > 0) {
                    remainingCredits = remainingCredits - courseCredits;
                    if (remainingCredits < 0) {
                        remainingCredits = 0;
                    }
                }

                String updateProgress =
                    "INSERT INTO progressTracking (studentID, earnedCredits, remainingCredits) VALUES (?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE earnedCredits = VALUES(earnedCredits), remainingCredits = VALUES(remainingCredits)";

                ps3 = con.prepareStatement(updateProgress);
                ps3.setString(1, student);
                ps3.setInt(2, earnedCredits);
                ps3.setInt(3, remainingCredits);
                ps3.executeUpdate();
                ps3.close();

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch(SQLException e){}
                try { if (ps != null) ps.close(); } catch(SQLException e){}
                try { if (ps2 != null) ps2.close(); } catch(SQLException e){}
                try { if (ps3 != null) ps3.close(); } catch(SQLException e){}
                try { if (ps4 != null) ps4.close(); } catch(SQLException e){}
                try { if (con != null) con.close(); } catch(SQLException e){}
            }
			
			RequestDispatcher rd = request.getRequestDispatcher("courseSearch.jsp");
			rd.forward(request, response);
		}
	}

}
