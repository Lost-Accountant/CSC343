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
            this.connection = DriverManager.getConnection(fullUrl, username, password);
            System.out.println("Connection successful");
        } catch (SQLException e){
            System.out.println("Failed to establish connection");
            e.printStackTrace();
            return false;
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
            return false;
        }
        return true;
    }

    @Override
    public ElectionCabinetResult electionSequence(String countryName) {
        // Implement this method!
        String query = "SELECT t1.id AS election_id, DATE_PART('year', t1.e_date) AS year,\n" +
                "t3.id AS current_cabinet, t3.previous_cabinet_id AS previous_cabinet\n" +
                "FROM election AS t1, country AS t2, cabinet AS t3\n" +
                "WHERE t1.country_id = t2.id AND t1.id = t3.election_id\n" +
                "AND t2.name = ? \n" +
                "ORDER BY t1.e_date DESC;\n";
        try {
            PreparedStatement execstat = connection.prepareStatement(query);
            execstat.setString(1, countryName);
            // get result, rs iterable
            ResultSet rs = execstat.executeQuery();
            System.out.println(rs);
        }
        catch(SQLException e) {
            System.out.println("Failed to get cabinet result." + e.getMessage());
            return null;
        }
        return null;
    }

    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
        // Implement this method!
        try {
            PreparedStatement execstat = connection.prepareStatement("SELECT * FROM country");
            execstat.executeQuery();
        }
        catch(SQLException e) {
            System.out.println("Failed to get cabinet result." + e.getMessage());
            return null;
        }
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

        try {
            Assignment2 frame = new Assignment2();
            frame.connectDB(ip, username, password);
        }
        catch(ClassNotFoundException e){
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        }
    }
