import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
public class RegisterDao {
 private String dburl = "jdbc:mysql://localhost:3310/lin";
 private String dbuname = "root";
 private String dbpassword = "password";
 private String dbdriver = "com.mysql.cj.jdbc.Driver";
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
 String sql = "insert into lin.member values(?,?,?,?)";
 String result="Data Entered Successfully";
 try {
 PreparedStatement ps = con.prepareStatement(sql);
 ps.setString(1, member.getUname());
 ps.setString(2, member.getPassword());
 ps.setString(3, member.getEmail());
 ps.setNString(4, member.getPhone());
 ps.executeUpdate();
 } catch (SQLException e) {
 // TODO Auto-generated catch block
 result="Data Not Entered Successfully";
 e.printStackTrace();
 }
 return result;
 }
}