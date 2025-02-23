package example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// PreparedStatement 예제
public class SelectEx02 {

	public static void main(String[] args) {
		List<DepartmentVo> result = search("팀");
		for(DepartmentVo vo : result) {
			System.out.println(vo);
		}
	}

	public static List<DepartmentVo> search(String keyword) {
		List<DepartmentVo> result = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// 1. JDBC Driver 로딩
			Class.forName("org.mariadb.jdbc.Driver");

			// 2. 연결하기
			String url = "jdbc:mariadb://192.168.0.12:3306/webdb";
			conn = DriverManager.getConnection(url, "webdb", "webdb");

			// 3. Statement 준비하기
			String sql = "select id, name from department where name like ?";
			pstmt = conn.prepareStatement(sql);

			// 4. Parameter Binding
			pstmt.setString(1, "%" + keyword + "%");

			// 5. SQL 실행
			// binding하여 jdbc로 보냈기 때문에 jdbc에서 보내도록 해야한다
			rs = pstmt.executeQuery();

			// 6. 결과 처리
			while(rs.next()) {
				Long id = rs.getLong(1);
				String name = rs.getString(2);
				DepartmentVo vo = new DepartmentVo(id, name);
				result.add(vo);
			}
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패:" + e);
		} catch (SQLException e) {
			System.out.println("error:" + e);
		} finally {
			try {
				// 자원정리
				if (rs != null) {
					rs.close();
				}
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
