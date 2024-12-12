package example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

// PreparedStatement 예제
public class InsertEx02 {

	public static void main(String[] args) {
		System.out.println(insert(new DepartmentVo("영업1팀")));
		System.out.println(insert(new DepartmentVo("영업2팀")));
	}

	public static boolean insert(DepartmentVo vo) {
		boolean result = false;
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			// 1. JDBC Driver 로딩
			Class.forName("org.mariadb.jdbc.Driver");

			// 2. 연결하기
			String url = "jdbc:mariadb://192.168.0.12:3306/webdb";
			conn = DriverManager.getConnection(url, "webdb", "webdb");

			// 3. Statement 준비하기
			String sql = "insert into department values(null, ?)";
			pstmt = conn.prepareStatement(sql);
			
			// 4. Parameter Binding
			pstmt.setString(1, vo.getName());

			// 5. SQL 실행
			// binding하여 jdbc로 보냈기 때문에 jdbc에서 보내도록 해야한다
			int count = pstmt.executeUpdate();

			result = count == 1;
			//System.out.println(result);
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패:" + e);
		} catch (SQLException e) {
			System.out.println("error:" + e);
		} finally {
			try {
				if (pstmt != null) {
					pstmt.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

}
