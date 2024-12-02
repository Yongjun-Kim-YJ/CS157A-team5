import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;

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
	
	public ArrayList<String> searchKeyword(String k) {
		Connection con = getConnection();		
		String sql = "SELECT * FROM courses WHERE courseID LIKE ? courseName LIKE ? OR description LIKE ?";
		String keyword = k;
		
		ArrayList<String> matches = new ArrayList<String>();
		
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, "%" + keyword + "%");
			ps.setString(2, "%" + keyword + "%");
			ps.setString(3, "%" + keyword + "%");
			ResultSet results = ps.executeQuery();
			while (results.next()) {
				String course = results.getString("courseName");
				matches.add(course);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
		
		return matches;
	}
	
	public boolean addCourse(String c, String id) {
		String added = c;
		int sid = Integer.parseInt(id);
		Connection con = getConnection();
		String sql = "INSERT INTO usercourses values(?, ?)";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, sid);
			ps.setString(2, added);
			ps.executeUpdate();
			System.out.println("Successfully Added!");
			return true;
		} catch (SQLIntegrityConstraintViolationException i) {
			System.out.println("Duplicate!");
			return false;
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("Failed");
			return false;
		}
	}
	
}
