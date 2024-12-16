package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import bookmall.vo.BookVo;

public class BookDao {

	public int insert(BookVo mockBookVo) {
		int count = 0;
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt1 = conn.prepareStatement("insert into book values (null, ?, ?, ?)");
			PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from book");
		) {
			pstmt1.setString(1, mockBookVo.getTitle());
			pstmt1.setInt(2, mockBookVo.getPrice());
			pstmt1.setLong(3, mockBookVo.getCategoryNo());
			count = pstmt1.executeUpdate();

			ResultSet rs = pstmt2.executeQuery();
			mockBookVo.setNo(rs.next() ? rs.getLong(1) : null);

		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return count;
	}
	
	public int deleteByNo(Long no) {
		int count=0;
		try(
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from book where no = ?");
		){
			pstmt.setLong(1, no);
			count = pstmt.executeUpdate();
		} catch(SQLException e) {
			System.out.println("error:" + e);
		}
		return count;
	}
	
	private Connection getConnection() throws SQLException {
		Connection conn = null;
		try {
			Class.forName("org.mariadb.jdbc.Driver");

			String url = "jdbc:mariadb://192.168.0.12:3306/bookmall";
			conn = DriverManager.getConnection(url, "bookmall", "bookmall");
		} catch (ClassNotFoundException e) {
			System.out.println("드라이버 로딩 실패:" + e);
		}
		return conn;
	}
}
