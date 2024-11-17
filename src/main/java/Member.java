public class Member {
	private String name, email, password;
	private int studentID, majorID;

	public Member() {
		super();
	}

	public Member(int studentID, String name, String email, String password) {
		super();
		this.studentID = studentID;
		this.name = name;
		this.email = email;
		this.password = password;
	}
	
	public int getStudentID() {
		return studentID;
	}

	public void setStudentID(int studentID) {
		this.studentID = studentID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	
	public int getMajorID() {
		return majorID;
	}

	public void setMajorID(int majorID) {
		this.majorID = majorID;
	}

}