import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

public class SearchDao {
	
	private String dburl="jdbc:mysql://localhost:3306/cs157ateam5";
	private String dbuname="root";
	private String dbpassword="password";
	
	
	public void loadDriver(String dbDriver) {
		try {
			Class.forName(dbDriver);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public Connection getConnection() {
		
		Connection con=null;
		
		try {
			con=DriverManager.getConnection(dburl, dbuname, dbpassword);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return con;
	}
	
	public boolean addCourse(String c, String id) {
		String added = c;
//		int sid = Integer.parseInt(id);
		Connection con = getConnection();
		String sql = "INSERT INTO usercourses values(?, ?)";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
//			ps.setInt(1, sid);
			ps.setInt(1, 777); // change to student ID as soon as code can be connected to profile and get session id
			ps.setString(2, added);
			ps.executeUpdate();
			System.out.println("Successfully Added!");
			return true;
		} catch (SQLIntegrityConstraintViolationException i) {
			i.printStackTrace();
			System.out.println("Duplicate!");
			return false;
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("Failed");
			return false;
		}
	}
	
}
