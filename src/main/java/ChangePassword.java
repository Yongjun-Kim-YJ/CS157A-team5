import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class ChangePassword
 */
@WebServlet("/ChangePassword")
public class ChangePassword extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangePassword() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		HttpSession session = request.getSession();
		int studentID = 0;
		if (session.getAttribute("studentID") != null) {
			studentID = Integer.parseInt((String) session.getAttribute("studentID"));
		}
		else {
			response.sendRedirect("memberRegister.jsp");
			return;
		}
		UserAuthDao passdao=new UserAuthDao();
		boolean result = passdao.changePassword(studentID, currentPassword, newPassword);
		if (!result) {
			response.sendRedirect("memberRegister.jsp");
		}
		response.sendRedirect("homepage.jsp");
	}

}
