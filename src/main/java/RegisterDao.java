import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class RegisterDao {
	private String dburl = "jdbc:mysql://localhost:3306/CS157a-team5";
	private String dbuname = "root";
	private String dbpassword = "password";
	private String dbdriver = "com.mysql.jdbc.Driver";
	public void loadDriver(String dbDriver)
	{
		try {
			Class.forName(dbDriver);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public Connection getConnection() {
		Connection con = null;
		try {
			con = DriverManager.getConnection(dburl, dbuname, dbpassword);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return con;
	}
	public String insert(Member member) {
		loadDriver(dbdriver);
		Connection con = getConnection();
		String sql = "insert into member values(?,?,?)";
		String result="Data Entered Successfully";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, member.getUname());
			ps.setString(2, member.getPassword());
			ps.setString(3, member.getEmail());
			ps.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			result="Data Not Entered Successfully";
			e.printStackTrace();
		}
		return result;
	}
	   public boolean validate(String username, String password) {
	        boolean status = false;
	        String sql = "SELECT * FROM member WHERE uname=? AND password=?";

	        try (Connection con = DriverManager.getConnection(dburl, dbuname, dbpassword);
	             PreparedStatement ps = con.prepareStatement(sql)) {
	            ps.setString(1, username);
	            ps.setString(2, password);
	            ResultSet rs = ps.executeQuery();
	            status = rs.next(); // Returns true if a record is found
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return status;
	    }
}