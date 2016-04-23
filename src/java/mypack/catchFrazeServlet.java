/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mypack;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author CodeFletcher
 */
public class catchFrazeServlet extends HttpServlet {
    
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
           
         //get a random phrase
         sql = "SELECT id, phrase,hint,first,first_time,second,second_time,third,third_time FROM catchfraze order by rand() limit 1";
                  
         ResultSet rs = stmt.executeQuery(sql);

         // Extract data from result set
         while(rs.next()){
            //Retrieve by column name
            int id2=rs.getInt("id");
            String phrase = rs.getString("phrase");
            String hint = rs.getString("hint");
                   
            request.setAttribute("id", id2);
                      
            request.setAttribute("phrase", phrase);
            request.setAttribute("hint", hint);
       
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
        
         request.getRequestDispatcher("/home").forward(request,response);
                
                
    }
    
    //update highscores    
    public void doPost(HttpServletRequest request,HttpServletResponse response) 
            throws ServletException, IOException
    {
        
        String name=request.getParameter("name");
        String id=request.getParameter("id");
        String place=request.getParameter("place");
        String time=request.getParameter("time");
        
           try{
         // Register JDBC driver
         Class.forName("com.mysql.jdbc.Driver");

         // Open a connection
         Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);

         // Execute SQL query
         Statement stmt = conn.createStatement();
         String sql;
         
         
         if(place.equals("second")){
             
             sql="UPDATE catchfraze SET third=second where id="+id+";";
             stmt.executeUpdate(sql);
             
              sql="UPDATE catchfraze SET third_time=second_time where id="+id+";";
             stmt.executeUpdate(sql);
         }
         
         if(place.equals("first")){
             
             sql="UPDATE catchfraze SET third=second where id="+id+";";
             stmt.executeUpdate(sql);
             
             sql="UPDATE catchfraze SET third_time=second_time where id="+id+";";
             stmt.executeUpdate(sql);
             
             
             
              sql="UPDATE catchfraze SET second=first where id="+id+";";
             stmt.executeUpdate(sql);
             
              sql="UPDATE catchfraze SET second_time=first_time where id="+id+";";
             stmt.executeUpdate(sql);
             
                         
         }
         
         sql = "UPDATE catchfraze SET "+place+"=\""+name+"\" where id="+id+";";
         stmt.executeUpdate(sql);
         sql = "UPDATE catchfraze SET "+place+"_time="+time+" where id="+id+";";
         stmt.executeUpdate(sql);
          
         // Clean-up environment
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
