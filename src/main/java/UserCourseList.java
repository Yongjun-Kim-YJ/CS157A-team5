import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Register
 */
@WebServlet("/UserCourseList")
public class UserCourseList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserCourseList() {
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UserCourseDao uDao = new UserCourseDao();
		
		String complete = request.getParameter("completedCourse");
		String delete = request.getParameter("deletedCourse");
		String student = request.getParameter("studentID");
				
		if (complete != null && !complete.isBlank()) {
			uDao.completeCourse(complete, student);
			RequestDispatcher rd = request.getRequestDispatcher("userCourses.jsp");
			rd.forward(request, response);
		} else {
			uDao.deleteCourse(delete, student);
			RequestDispatcher rd = request.getRequestDispatcher("userCourses.jsp");
			rd.forward(request, response);
		}
	}

}
