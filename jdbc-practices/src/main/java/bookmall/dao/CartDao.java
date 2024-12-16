package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.CartVo;
import bookmall.vo.CategoryVo;
import bookmall.vo.OrderVo;

public class CartDao {

	public int insert(CartVo mockCartVo) {
		int count = 0;
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("insert into cart values (?, ?, ?)");
		) {
			pstmt.setLong(1, mockCartVo.getBookNo());
			pstmt.setLong(2, mockCartVo.getUserNo());
			pstmt.setInt(3, mockCartVo.getQuantity());

			count = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return count;
	}
	
	public List<CartVo> findByUserNo(Long no) {
		List<CartVo> result = new ArrayList<>();
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select  a.no, b.user_no, b.qty, a.title from book a join cart b on a.no = b.book_no where b.user_no = ?");
		) {
			pstmt.setLong(1,  no);
			ResultSet rs = pstmt.executeQuery();

			while(rs.next()) {
				Long book_no = rs.getLong(1);
				Long user_no = rs.getLong(2);
				int qty = rs.getInt(3);
				String title = rs.getString(4);
				CartVo vo = new CartVo();
				vo.setBookNo(book_no);
				vo.setUserNo(user_no);
				vo.setQuantity(qty);
				vo.setBookTitle(title);
				result.add(vo);
			}
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return result;
	}
	
	public int deleteByUserNoAndBookNo(Long userNo, Long no) {
		int count=0;
		try(
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from cart where user_no = ? and book_no = ?");
		){
			pstmt.setLong(1, userNo);
			pstmt.setLong(2, no);
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
