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
@WebServlet("/SearchList")
public class SearchList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SearchList() {
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
		
		String allCourses = request.getParameter("allAddedCourses");
		if (allCourses != null)
			request.setAttribute("allAddedCourses", allCourses);
		
		String keyword = request.getParameter("keyword");
		if (request.getParameter("goBack") != null) {
			RequestDispatcher rd = request.getRequestDispatcher("courseSearch.jsp");
			rd.forward(request, response);
		} else if (keyword != null && !keyword.isBlank()) {
			keyword = keyword.trim();
			request.setAttribute("keyword", keyword);
			RequestDispatcher rd = request.getRequestDispatcher("searchResults.jsp");
			rd.forward(request, response);
		} else {
			String addCourse = request.getParameter("addedCourse");
			String addCourseID = request.getParameter("studentID");
			boolean updateAdd = sDao.addCourse(addCourse, addCourseID);
			request.setAttribute("addedCourse", addCourse);
			request.setAttribute("studentID", updateAdd + "");
			request.setAttribute("keyword", request.getParameter("prevSearch"));
			RequestDispatcher rd = request.getRequestDispatcher("searchResults.jsp");
			rd.forward(request, response);
		}
	}

}
