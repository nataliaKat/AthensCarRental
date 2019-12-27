import java.util.InputMismatchException;
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Dao dao = new Dao();
		System.out.print("Enter customer id");
		Scanner in = new Scanner(System.in);
		int id;
		try {
			id = in.nextInt();
		} catch (InputMismatchException e) {
			System.out.println("I expected a number");
			return;
		}
		dao.printRentalsPerCustomer(id);
	}

}
