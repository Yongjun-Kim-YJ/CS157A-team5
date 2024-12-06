import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserCourseDao {
	
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
	
	public boolean completeCourse(String c, String id) {
		String completed = c;
		int sid = Integer.parseInt(id);
		Connection con = getConnection();
		// Change sql statement to however completed course is stored
		// For now, insert into a "completed courses" table
		String sql = "INSERT INTO completedcourses values(?, ?)";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, sid);
			ps.setString(2, completed);
			ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("Failed");
			return false;
		}
	}
	
	public boolean deleteCourse(String c, String id) {
		String deleted = c;
		String sid = id;
		Connection con = getConnection();
		String sql = "DELETE FROM usercourses WHERE studentID = ? AND courseID = ?";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, sid);
			ps.setString(2, deleted);
			ps.executeUpdate();
			sql = "DELETE FROM completedcourses WHERE studentID = ? AND courseID = ?";
			ps = con.prepareStatement(sql);
			ps.setString(1, sid);
			ps.setString(2, deleted);
			ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("Failed");
			return false;
		}
	}
}
