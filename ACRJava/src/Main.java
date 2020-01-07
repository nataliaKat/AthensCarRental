import java.util.InputMismatchException;
import java.util.Scanner;

public class Main {

	public static void main(String[] args) {
		Dao dao = new Dao();
		System.out.print("Enter customer id: ");
		Scanner in = new Scanner(System.in);
		long id;
		try {
			id = in.nextLong();
		} catch (InputMismatchException e) {
			System.out.println("I expected a number");
			return;
		}
		dao.printRentalsPerCustomer(id);
		System.out.print("Enter rental id: ");
        try {
			id = in.nextLong();
        } catch (InputMismatchException e) {
			System.out.println("I expected a number");
		    return;
		}
        System.out.println("Do you want to delete the corresponding payment if found?(y/n)?");
        String answer = in.next();
        if (answer.toLowerCase().charAt(0) == 'y') {
			checkAndDeletePayment(id); 
        } else if (answer.toLowerCase().charAt(0) != 'n') {
        	System.out.println("Cannot understand you");
        	return;
        }        	
		dao.deleteRental(id);

        
	}
	
	private static void checkAndDeletePayment(long rentId) {
		Dao dao = new Dao();
		long paymId = dao.getVerificationNumber(rentId);
		if (paymId != -1) {
			dao.deletePayment(paymId);
		} else {
			System.out.println("Payment not found");
		}
	}

}
