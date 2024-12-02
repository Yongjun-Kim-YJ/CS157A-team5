import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String password = request.getParameter("login-password");
        String studentID = request.getParameter("login-studentID");
        System.out.println("password: " + password + "\nstudent id: " + studentID);

        // Check credentials
        UserAuthDao rdao = new UserAuthDao();
        boolean result = rdao.validate(Integer.parseInt(studentID), password);
        
        if (result) {
            // Login and create session if successful
            HttpSession session = request.getSession();
            String[] userDetails = rdao.getUserDetails(Integer.parseInt(studentID));

            session.setAttribute("studentID", studentID);
            session.setAttribute("name", userDetails[0]);
            session.setAttribute("email", userDetails[1]);
            session.setAttribute("major", userDetails[2]);
            session.setAttribute("majorName", userDetails[3]);
            session.setAttribute("majorCredits", userDetails[4]);

            response.sendRedirect("homepage.jsp");
        } else {
            // Don't do anything if credentials are wrong
            response.sendRedirect("memberRegister.jsp");
        }
    }
}
