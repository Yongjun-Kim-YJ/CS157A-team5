import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
public class UserAuthDao {
	private String dburl = "jdbc:mysql://localhost:3306/cs157ateam5";
	private String dbuname = "root";
	private String dbpassword = "password";
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
        String sql = "INSERT INTO users (studentID, name, email, password, major_id) VALUES (?, ?, ?, ?, '')";
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
    
    public boolean changePassword(int studentID, String currentPassword, String newPassword) {
    	loadDriver(dbdriver);
    	Connection con = getConnection();
        String update_sql = "UPDATE users SET password=? WHERE studentID=?";
        String select_sql = "SELECT password FROM users WHERE studentID=?";
        try {
        	PreparedStatement ps = con.prepareStatement(select_sql);
        	ps.setInt(1, studentID);
        	ResultSet rs = ps.executeQuery();
        	if (rs.next()) {
        		String cur = rs.getString("password");
        		if (!cur.equals(currentPassword)) {
        			return false;
        		}
        	}
        	else {
        		return false;
        	}
        	ps = con.prepareStatement(update_sql);
        	ps.setInt(2, studentID);
        	ps.setString(1, newPassword);
        	int rowsUpdated = ps.executeUpdate();
        	if (rowsUpdated == 0) {
        		return false;
        	}
        	
        }
        catch(SQLException e) {
        	e.printStackTrace();
        	return false;
        }
    	
    	return true;
   
    }
    
    public String[] getUserDetails(int studentID) {
        String[] userDetails = new String[5];
        String sql = "SELECT name, email, major_id FROM users WHERE studentID=?";
        
        try (Connection con = DriverManager.getConnection(dburl, dbuname, dbpassword);
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                userDetails[0] = rs.getString("name");
                userDetails[1] = rs.getString("email");
                userDetails[2] = rs.getString("major_id");
            }
            
            // Added getting major from users table
            // Gets the total number of required credits for major and unabbreviated form of major 
            sql = "SELECT majorName, requiredCredits FROM majors WHERE majorID=?";
            PreparedStatement p = con.prepareStatement(sql);
            p.setString(1, userDetails[2]);
            rs = p.executeQuery();
            
            if (rs.next()) {
            	userDetails[3] = rs.getString("majorName");
            	userDetails[4] = rs.getInt("requiredCredits") + "";
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return userDetails;
    }

    public boolean validate(int studentID, String password) {
        boolean status = false;
        String sql = "SELECT * FROM users WHERE studentID=? AND password=?";
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
