import java.sql.*;
import java.util.List;
import java.util.Scanner;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
//import java.util.ArrayList;
//import java.util.Map;
//import java.util.HashMap;
//import java.util.Set;
//import java.util.HashSet;
public class Assignment2 extends JDBCSubmission {

    public Assignment2() throws ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
    }

    @Override
    public boolean connectDB(String url, String username, String password) {
        // Implement this method!
        String fullUrl = "jdbc:postgresql://" + url + ":5432/CSC343";
        try {
            connection = DriverManager.getConnection(fullUrl, username, password);
            System.out.println("Connection successful");
        } catch (SQLException e){
            System.out.println("Failed to estabilish connection");
            e.printStackTrace();
        }
        return true;
    }

    @Override
    public boolean disconnectDB() {
        // Implement this method!
        try {
            connection.close();
        } catch (SQLException e) {
            System.out.println("Failed to close connection");
            e.printStackTrace();
        }
        return true;
    }

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
        // Implement this method!
        return null;
    }

    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
        // Implement this method!
        return null;
    }

    public static void main(String[] args) {
        // You can put testing code in here. It will not affect our autotester.
        System.out.println("Hello");
        // test connection to databse
        Scanner userInput = new Scanner(System.in);
        System.out.println("Please enter database IP:");
        String ip = userInput.next();

        System.out.println("Please enter username:");
        String username = userInput.next();

        System.out.println("Please enter password");
        String password = userInput.next();

        Assignment2 frame = new Assignment2();
        frame.connectDB(ip, username, password);
    }

}

