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
			
			RequestDispatcher rd = request.getRequestDispatcher("courseSearch.jsp");
			rd.forward(request, response);
		}
	}

}
