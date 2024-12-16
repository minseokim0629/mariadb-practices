package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.CategoryVo;

public class CategoryDao {
	public int insert(CategoryVo mockCategoryVo) {
		int count = 0;
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt1 = conn.prepareStatement("insert into category values (null, ?)");
			PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from category");
		) {
			pstmt1.setString(1, mockCategoryVo.getName());
			count = pstmt1.executeUpdate();

			ResultSet rs = pstmt2.executeQuery();
			mockCategoryVo.setNo(rs.next() ? rs.getLong(1) : null);

		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return count;
	}

	public List<CategoryVo> findAll() {
		List<CategoryVo> result = new ArrayList<>();
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select no, name from category");
		) {
			ResultSet rs = pstmt.executeQuery();
			while(rs.next()) {
				Long no = rs.getLong(1);
				String name = rs.getString(2);
				CategoryVo vo = new CategoryVo();
				vo.setNo(no);
				vo.setName(name);
				result.add(vo);
			}
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return result;
	}

	public int deleteByNo(Long no) {
		int count=0;
		try(
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from category where no = ?");
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
