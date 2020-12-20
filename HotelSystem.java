import java.io.IOException;
import java.sql.*;
import java.util.Scanner;

public class HotelSystem {

    // JDBC driver name and database URL

    static final String DB_URL = "jdbc:mysql://localhost/hotel";
    static final String USER = "root";
    static final String PASS = "";
    
    private Connection connection;
    private Statement statement;
    private ResultSet result;
    private Scanner sc;
    
    public HotelSystem() {
        sc = new Scanner(System.in);
        
        System.out.println("Connecting to database...");
        try {
            connection = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public ResultSet executeQuery(String query) {
        try {
            statement = connection.createStatement();
            result = statement.executeQuery(query);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return result;
    }
    
    public void printResultSet() throws SQLException {
        ResultSetMetaData rsmd = result.getMetaData();
        int columnsNumber = rsmd.getColumnCount();
        
        for (int i = 1; i <= columnsNumber; i++) {
            System.out.print(rsmd.getColumnName(i) + " ");
        }
        
        System.out.println("");
        
        while (result.next()) {
            for (int i = 1; i <= columnsNumber; i++) {
                if (i > 1) System.out.print("  ");
                String columnValue = result.getString(i);
                System.out.print(columnValue);
            }
            System.out.println("");
        }
    }
    
    public void showOptions() throws SQLException {
        String[] options = new String[] {
                "Unavailable rooms",
                "Available rooms in x floor",
                "Available rooms",
                "Available type of room",
                "Room(s) booked by customer",
                "Rooms with more than one bed",
                "Cost of booking x room for y number of days",
                "Average price of rooms on x floor:",
                "Find out renters that did not put in a deposit.",
                "Find out the least amount of days a renter is staying.",
                "Find customers who have been to the hotel more than once.",
                "Find out VIP renters that rented a DELUXE PREMIUM room.",
                "Upgrade customer’s room(s) to next tier",
                "Unbook guest (CheckOut Trigger)",
                "Book guest into room (CheckIn Trigger)",
                "Choose room of specific floor and price",
                "Discount room types at chosen discount rate",
                "Archive",
                "Room",
                "RoomType",
                "Booking",
                "BookingRecord",
                "User"
        };
        
        boolean exit = false;
        
        while (exit == false) {
            for (int i = 0; i < options.length; i++) {
                System.out.println("(" + (i+1) + ") " + options[i]);
            }
            
            System.out.println("\nEnter an option: ");
            int option = sc.nextInt();
            
            String query = "";
            boolean specialQuery = false;
            
            switch(option) {
                case 1:
                    query = "select * from room where reserved = True;";
                    break;
                    
                case 2:
                    System.out.println("Select floor number: ");
                    int floor = sc.nextInt();
                    query = "SELECT * FROM Room WHERE reserved = false and floorNumber =" + floor;
                    break;
                    
                case 3:
                    query = "select * from room where reserved = false;";
                    break;
                    
                case 4: 
                    query = "select distinct room.typeName from room\r\n" + 
                            "INNER JOIN Booking\r\n" + 
                            "on room.rID = Booking.rID\r\n" + 
                            "WHERE room.reserved = False;\r\n" + 
                            "";
                    break;
                
                case 5:
                    System.out.println("Enter customer uID: ");
                    int uid = sc.nextInt();
                    query = "SELECT * FROM Room WHERE Room.rID IN (\r\n" + 
                            "SELECT Booking.rID\r\n" + 
                            "    FROM Booking\r\n" + 
                            "    WHERE Booking.uID = " + uid + "\r\n" + 
                            ");\r\n" + 
                            "";
                    break;
                    
                case 6:
                    query = "select rID from room,roomtype\r\n" + 
                            "where room.typeName = roomtype.typeName and numbeds > 1;\r\n" + 
                            "";
                    break;
                
                case 7:
                    System.out.println("Enter room rID: ");
                    int rid = sc.nextInt();
                    System.out.println("Enter number of days: ");
                    int days = sc.nextInt();
                    query = "SELECT DISTINCT ABS(price * " + days + ") as totalCost\r\n" + 
                            "FROM Room, RoomType, Booking\r\n" + 
                            "WHERE Room.rID = " + rid + " and Room.typeName = RoomType.typeName;\r\n" + 
                            "";
                    break;
                
                case 8:
                    System.out.println("Select floor number: ");
                    int num = sc.nextInt();
                    query = "Select avg(price) from RoomType where typeName in (select typeName from Room where floorNumber = " + num + ");";
                    break;
                    
                case 9:
                    query = "select firstname,lastname,phone,deposit from user \r\n" + 
                            "inner join booking \r\n" + 
                            "on user.uID = booking.uID \r\n" + 
                            "Where booking.deposit = False;\r\n" + 
                            "";
                    break;
                
                case 10:
                    query = "SELECT user.firstname,user.lastname,startDate,endDate,DATEDIFF(endDate, startDate) as length \r\n" + 
                            "FROM  booking,user\r\n" + 
                            "where user.uID = booking.uID\r\n" + 
                            "order BY length ASC\r\n" + 
                            "LIMIT 1;\r\n" + 
                            "";
                    break;
                case 11:
                    query = "SELECT *\r\n" + 
                            "FROM User\r\n" + 
                            "WHERE uID IN (\r\n" + 
                            "    SELECT uID FROM BookingRecord\r\n" + 
                            "    GROUP BY uID\r\n" + 
                            "    HAVING COUNT(*) > 1\r\n" + 
                            ");\r\n" + 
                            "";
                    break;
                
                case 12:
                    query = "SELECT user.uID,user.firstname,user.lastname FROM user,booking,room\r\n" + 
                            "WHERE user.uID = booking.uID and room.typeName = 'DELUXE PREMIUM';\r\n" + 
                            "";
                    break;
                
                case 13:
              
                    specialQuery = true;
                    sc.nextLine();
                    System.out.println("Enter customer uID: ");
                    uid = sc.nextInt();
                    System.out.println("Enter days to extend by: ");
                    days = sc.nextInt();
                    
                    query = "update booking set endDate = DATE_ADD(endDate, INTERVAL " + days + " DAY) where booking.uID = " + uid + ";";
                    Statement stmt3 = connection.createStatement();
                    stmt3.executeUpdate(query);
                    break;
                    
                case 14:
                    specialQuery = true;
                    
                    System.out.println("Enter customer uID: ");
                    uid = sc.nextInt();
                    query = "delete from booking where uID = " + uid + ";";
                    
                    Statement stmt4 = connection.createStatement();
                    stmt4.executeUpdate(query);
                    
                    break;
                  
                    
                case 15:
                	specialQuery = true;
                    sc.nextLine();
                	
                    System.out.println("Enter customer uID: ");
                    uid = sc.nextInt();
                    System.out.println("Enter room rID: ");
                    rid = sc.nextInt();
                    
                    sc.nextLine();
              
                    System.out.println("Enter start date: ");
                    String start = sc.nextLine();
                    System.out.println("Enter end date: ");
                    String end = sc.nextLine();
                    System.out.println("Customer paid a deposit (true/false): ");
                    String bool = sc.nextLine();
                    
                    query = "insert into booking values(" + uid + "," + rid + "," + start + "," + end + ", " + bool + ");";
                    Statement stmt5 = connection.createStatement();
                    stmt5.executeUpdate(query);
                    break;
                    
                case 16:
                    
                    System.out.println("Enter the floor number");
                    int floornum = sc.nextInt();
                    System.out.println("Enter the price limit");
                    int pricelim = sc.nextInt();
                    
                    query = "select room.typeName, room.floorNumber, roomtype.price from room left outer join roomType on room.typeName = roomtype.typeName where room.floorNumber = " + floornum + " and roomtype.price < " + pricelim +" ;" ;

                    break;
                    
                case 17: 
                    
                   specialQuery = true;
                   sc.nextLine();
                    
                    System.out.println("Enter the room types you would like to discount. Press enter after the first roomtype");
                    String roomtype1 = sc.nextLine();
                    System.out.println("And the second roomtype");
                    String roomtype2 = sc.nextLine();
                    System.out.println("Enter the discount percentage ");
                    int percent = sc.nextInt();
               
                    query = "update roomtype set price = price*." + percent + "where typeName = '" + roomtype1 + "' or typeName = '" + roomtype2 + "' ;";
                    Statement stmt2 = connection.createStatement();
                    stmt2.executeUpdate(query);
                    break; 
                    
                case 18:
                    specialQuery = true;
                    System.out.println("Enter year: ");
                    int year = sc.nextInt();
                    System.out.println("Enter month: ");
                    int month = sc.nextInt();
                    System.out.println("Enter day: ");
                    int day = sc.nextInt();
                    
                    String date = year + "-" + month + "-" + day;
                    query = "{call recordBooking(?)}";
                    CallableStatement stmt = connection.prepareCall(query);
                    stmt.setString(1, date);
                    stmt.execute();
                    stmt.close();
                    break;    
                
                case 19:
                    query = "select * from room;";
                    break;
                
                case 20:
                    query = "select * from roomtype;";
                    break;
                
                case 21:
                    query = "select * from booking;";
                    break;
                
                case 22:
                    query = "select * from bookingrecord;";
                    break;
                    
                case 23:
                    query = "select * from user;";
                    break;
                    
                default:
                    exit = true;
                    break;
            }
            
            if (specialQuery == false) {
                System.out.println(options[option - 1]);
                executeQuery(query);
                printResultSet();
            } else if (specialQuery == true) {
                specialQuery = false;
            }
            
            System.out.println("");
        }
    }
    
    
    public static void main(String[] args) throws SQLException, IOException {
        HotelSystem hotel = new HotelSystem();
        hotel.showOptions();
    }
}
