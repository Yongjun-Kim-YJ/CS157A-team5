import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class UserAuthDao {
	private String dburl = "jdbc:mysql://localhost:3306/CS157a-team5";
	private String dbuname = "root";    private String dbpassword = "password";
    private String dbdriver = "com.mysql.cj.jdbc.Driver";

    public void loadDriver(String dbDriver) {
        try {
            // Load the MySQL JDBC driver
            Class.forName(dbDriver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        Connection con = null;
        try {
            con = DriverManager.getConnection(dburl, dbuname, dbpassword);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }

    public boolean insert(Member member) {
        loadDriver(dbdriver);
        Connection con = getConnection();
        String sql = "INSERT INTO Users (studentID, name, email, password, major_id) VALUES (?, ?, ?, ?, '')";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setLong(1, member.getStudentID());
            ps.setString(2, member.getName());
            ps.setString(3, member.getEmail());
            ps.setString(4, member.getPassword());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }
    
    public String[] getUserDetails(int studentID) {
        String[] userDetails = new String[2];
        String sql = "SELECT name, email FROM Users WHERE studentID=?";
        
        try (Connection con = DriverManager.getConnection(dburl, dbuname, dbpassword);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                userDetails[0] = rs.getString("name");
                userDetails[1] = rs.getString("email");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return userDetails;
    }

    public boolean validate(int studentID, String password) {
        boolean status = false;
        String sql = "SELECT * FROM Users WHERE studentID=? AND password=?";
        try (Connection con = DriverManager.getConnection(dburl, dbuname, dbpassword);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentID);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            status = rs.next(); // Returns true if it matches one of the login credentials
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}
