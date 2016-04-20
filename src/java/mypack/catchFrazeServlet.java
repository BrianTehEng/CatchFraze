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
         static final String USER = "phrase_user";
         static final String PASS = "elvemage"; 
    
    
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
         sql = "SELECT id, phrase,hint FROM catchfraze order by rand() limit 1";
         ResultSet rs = stmt.executeQuery(sql);

         // Extract data from result set
         while(rs.next()){
            //Retrieve by column name
            String phrase = rs.getString("phrase");
            String hint = rs.getString("hint");
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
    
           
    
}
