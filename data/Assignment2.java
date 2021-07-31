import java.sql.*;
import java.util.List;
import java.util.Scanner;

// If you are looking for Java data structures, these are highly useful.
// Remember that an important part of your mark is for doing as much in SQL (not Java) as you can.
// Solutions that use only or mostly Java will not receive a high mark.
import java.util.ArrayList;
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
        String query = "SELECT t1.id AS election_id,\n" +
                "t3.id AS current_cabinet\n" +
                "FROM parlgov.election AS t1, parlgov.country AS t2, parlgov.cabinet AS t3\n" +
                "WHERE t1.country_id = t2.id AND t1.id = t3.election_id\n" +
                "AND t2.name = ? \n" +
                "ORDER BY t1.e_date DESC;";
                // in descending order of years.
        try {
            PreparedStatement execstat = connection.prepareStatement(query);
            execstat.setString(1, countryName);
            // get result, rs iterable
            ResultSet resultSet = execstat.executeQuery();
            // iterate the result set

            List<Integer> elections = new ArrayList<>();
            List<Integer> cabinets = new ArrayList<>();

            while (resultSet.next()) {
                elections.add(resultSet.getInt(1));
                cabinets.add(resultSet.getInt(2));
           }

           return new ElectionCabinetResult(elections,cabinets);
        }
        catch(SQLException e) {
            System.out.println("Failed to get cabinet result." + e.getMessage());
            return null;
        }
    }

    @Override
    public List<Integer> findSimilarPoliticians(Integer politicianName, Float threshold) {
        // put selected president in the query
        String userQuery = "SELECT t1.id, t1.description, t1.comment\n" +
                "FROM parlgov.politician_president as t1\n" +
                "WHERE id = ? ;";

        try {
            PreparedStatement basePolitician = connection.prepareStatement(userQuery);
            basePolitician.setInt(1, politicianName);
            // get the selected president and its description and comment
            ResultSet baseResult = basePolitician.executeQuery();
            // get the base comment
            if (baseResult.next()){
                String baseDescript = baseResult.getString(2);
                String baseComment = baseResult.getString(3);
            } else {
                String baseDescript = "";
                String baseComment = "";
            }

            // get all president and their description and comment
            String comparisonQuery = "SELECT t1.id, t1.description, t1.comment\n" +
                    "FROM parlgov.politician_president as t1;";
            PreparedStatement otherPolitician = connection.prepareStatement(comparisonQuery);
            ResultSet comparisonResult = otherPolitician.executeQuery();

            // prepare list for storing similar politicians
            List<Integer> similarPolitican = new ArrayList<>();

            // check each if similarity over threshold through loop
            while (comparisonResult.next()){
                // include if either one passes threshold
                // check description
                System.out.println("lol");
                // check comment

                // if so add them to a list

            }

            // return the list
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
            Assignment2 test = new Assignment2();
            test.connectDB(ip, username, password);

            System.out.println("Country name");
            String country = userInput.next();
            test.electionSequence(country);
            test.disconnectDB();
        }
        catch(ClassNotFoundException e){
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        }
    }
