package bookmall.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import bookmall.vo.CartVo;
import bookmall.vo.OrderBookVo;
import bookmall.vo.OrderVo;
import bookmall.vo.UserVo;

public class OrderDao {

	public int insert(OrderVo mockOrderVo) {
		int count = 0;
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt1 = conn.prepareStatement("insert into orders values (null, ?, ?, ?, ?, ?, ?)");
			PreparedStatement pstmt2 = conn.prepareStatement("select last_insert_id() from orders");
			PreparedStatement pstmt3 = conn.prepareStatement("select name from user where no = ?")
		) {
			pstmt3.setLong(1, mockOrderVo.getUserNo());
			ResultSet rs = pstmt3.executeQuery();
			mockOrderVo.setOrderer(rs.next() ? rs.getString(1) : null);
			
			pstmt1.setString(1, mockOrderVo.getNumber());
			pstmt1.setString(2, mockOrderVo.getOrderer());
			pstmt1.setString(3, mockOrderVo.getStatus());
			pstmt1.setInt(4, mockOrderVo.getPayment());
			pstmt1.setString(5, mockOrderVo.getShipping());
			pstmt1.setLong(6, mockOrderVo.getUserNo());

			count = pstmt1.executeUpdate();

			ResultSet rs2 = pstmt2.executeQuery();
			mockOrderVo.setNo(rs2.next() ? rs2.getLong(1) : null);

		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return count;
	}

	public int insertBook(OrderBookVo mockOrderBookVo) {
		int count = 0;
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("insert into order_book values (?, ?, ?, ?)");
		) {
			
			pstmt.setLong(1, mockOrderBookVo.getBookNo());
			pstmt.setLong(2, mockOrderBookVo.getOrderNo());
			pstmt.setInt(3, mockOrderBookVo.getQuantity());
			pstmt.setInt(4, mockOrderBookVo.getPrice());
			count = pstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return count;
	}
	
	public OrderVo findByNoAndUserNo(Long no, Long userNo) {
		OrderVo vo = null;
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select no, number, orderer, status, payment, shipping, user_no from orders where no = ? and user_no = ?");
		) {
			pstmt.setLong(1,  no);
			pstmt.setLong(2,  userNo);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) {
				Long resultNo = rs.getLong(1);
				String resultNumber = rs.getString(2);
				String resultOrderer = rs.getString(3);
				String resultstatus = rs.getString(4);
				int resultPayment = rs.getInt(5);
				String shipping = rs.getString(6);
				Long resultuserNo = rs.getLong(7);
				
				vo = new OrderVo();
				vo.setNo(resultNo);
				vo.setNumber(resultNumber);
				vo.setOrderer(resultOrderer);
				vo.setStatus(resultstatus);
				vo.setPayment(resultPayment);
				vo.setShipping(shipping);
				vo.setUserNo(resultuserNo);
			}
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return vo;
	}

	public List<OrderBookVo> findBooksByNoAndUserNo(Long orderNo, Long userNo) {
		List<OrderBookVo> result = new ArrayList<>();
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("select b.book_no, b.order_no, b.qty, b.price, a.title from book a join order_book b on a.no = b.book_no join orders c on b.order_no = c.no where b.order_no = ? and c.user_no = ?");
		) {
			pstmt.setLong(1, orderNo);
			pstmt.setLong(2, userNo);
			ResultSet rs = pstmt.executeQuery();

			while(rs.next()) {
				Long book_no = rs.getLong(1);
				Long order_no = rs.getLong(2);
				int qty = rs.getInt(3);
				int price = rs.getInt(4);
				String title = rs.getString(5);
				OrderBookVo vo = new OrderBookVo();
				vo.setBookNo(book_no);
				vo.setOrderNo(order_no);
				vo.setQuantity(qty);
				vo.setPrice(price);
				vo.setBookTitle(title);
				result.add(vo);
			}
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return result;
	}
	
	public int deleteByNo(Long no) {
		int count = 0;
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from orders where no = ?");) {
			pstmt.setLong(1, no);
			count = pstmt.executeUpdate();
		} catch (SQLException e) {
			System.out.println("error:" + e);
		}
		return count;
	}

	public int deleteBooksByNo(Long orderNo) {
		int count = 0;
		try (
			Connection conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement("delete from order_book where order_no = ?");) {
			pstmt.setLong(1, orderNo);
			count = pstmt.executeUpdate();
		} catch (SQLException e) {
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
