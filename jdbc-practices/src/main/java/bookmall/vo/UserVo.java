package bookmall.vo;

public class UserVo {
	private Long no;
	private String name;
	private String email;
	private String phonenumber;
	private String password;

	public UserVo() {
		
	}
	
	public UserVo(String name, String email, String password, String phonenumber) {
		this.name = name;
		this.email = email;
		this.password = password;
		this.phonenumber = phonenumber;
	}

	public Long getNo() {
		return no;
	}

	public void setNo(Long no) {
		this.no = no;
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

	public String getPhonenumber() {
		return phonenumber;
	}

	public void setPhonenumber(String phonenumber) {
		this.phonenumber = phonenumber;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
