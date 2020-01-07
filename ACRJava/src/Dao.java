import java.sql.*;

public class Dao {

	private static Connection conn;

	private Connection getConnection() {
		if (conn == null) {
			try {
				String url = "";
				conn = DriverManager.getConnection(url);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return conn;
	}

	private void closeStatementAndResultSet(ResultSet rs, Statement st) {
		try {
			if (rs != null) {
				rs.close();
			}
			if (st != null) {
				st.close();
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
		}
	}

	private void closeStatement(Statement st) {
        try {
            if (st != null) {
                st.close();
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

	public void printRentalsPerCustomer(long customerId) {
		String query = "SELECT rental_id, start_date, end_date, starts_loc, ends_loc, cost FROM Rental, Payment WHERE Rental.verification_number = Payment.verification_number AND year(start_date) <= 2005 AND year(end_date) >= 2005 AND customer_id = "
				+ customerId;
		Statement st = null;
		ResultSet rs = null;
		try {
			st = getConnection().createStatement();
			rs = st.executeQuery(query);
			if (rs.next()) {
				System.out.println("Rentals of customer " + customerId);
				do {
					System.out.println("~ Rental Id: " + rs.getLong("rental_id"));
					System.out.println("~ Start Date: " + rs.getDate("start_date"));
					System.out.println("~ End Date: " + rs.getDate("end_date"));
					System.out.println("~ Start Location: " + rs.getInt("starts_loc"));
					System.out.println("~ End Location: " + rs.getInt("ends_loc"));
					System.out.println("~ Total Cost: " + rs.getDouble("cost"));
					System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
				} while (rs.next());
			} else {
				System.out.println("No rentals where found");
				return;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			closeStatementAndResultSet(rs, st);
		}
	}

	public void deleteRental(int rentalId) {
        String query = "DELETE FROM Rental WHERE rental_id=" + rentalId;
        Statement st = null;
        try {
            st = getConnection().createStatement();
            st.executeUpdate(query);
            closeStatement(st);
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public void deletePayment(int paymentId) {
	String query = "DELETE FROM Payment WHERE verification_number=" + paymentId;
	Statement st = null;
	try {
	st = getConnection().createStatement();
	st.executeUpdate(query);
	closeStatement(st);
	} catch (SQLException e) {
	e.printStackTrace();
	}

}

}
