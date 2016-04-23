package mypack;
import com.google.gson.Gson;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;




public class getData extends HttpServlet{

    // JDBC driver name and database URL
         static final String JDBC_DRIVER="com.mysql.jdbc.Driver";  
         static final String DB_URL="jdbc:mysql://localhost/phrases";

    // Database credentials
         static final String USER = "user";
         static final String PASS = "youwish"; 
       
         
         public void doGet(HttpServletRequest request,HttpServletResponse response) 
            throws ServletException, IOException
    {
   try{
         // Register JDBC driver
         Class.forName("com.mysql.jdbc.Driver");

         // Open a connection
         Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);

         // Execute SQL query
         Statement stmt = conn.createStatement();
         String sql;
         
         String id=request.getParameter("id");
         sql = "SELECT id,phrase,hint,first,first_time,second,second_time,third,third_time FROM catchfraze where id="+id+";";
         System.out.println(sql);
       
         
         ResultSet rs = stmt.executeQuery(sql);

         // Extract data from result set
         while(rs.next()){
            //Retrieve by column name
            int id2=rs.getInt("id");
            String phrase = rs.getString("phrase");
            String hint = rs.getString("hint");
            String first=rs.getString("first");
            String first_time=rs.getString("first_time");
            String second=rs.getString("second");
            String second_time=rs.getString("second_time");
            String third=rs.getString("third");
            String third_time=rs.getString("third_time");
            
            Map<String, String> data = new LinkedHashMap<String, String>();
            data.put("id", id);
            data.put("phrase", phrase);
            data.put("hint", hint);
            data.put("first",first);
            data.put("first_time",first_time);
            data.put("second",second);
            data.put("second_time",second_time);
            data.put("third",third);
            data.put("third_time",third_time);
            
            String json = new Gson().toJson(data);


             response.setContentType("application/json");
             response.setCharacterEncoding("UTF-8");
             response.getWriter().write(json);
       
         }
    
         // Clean-up environment
         rs.close();
         stmt.close();
         conn.close();
      }catch(SQLException se){
         //Handle errors for JDBC
         se.printStackTrace();
      }catch(Exception e){
         //Handle errors for Class.forName
         e.printStackTrace();
      }
        
        
                
                
    }

}