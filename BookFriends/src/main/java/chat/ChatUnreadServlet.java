package chat;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class ChatUnreadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
        
		
        String userID = request.getParameter("userID");
		System.out.println("CFLS-Received GET request for userID: " + userID);
		if(userID == null) {
			response.sendRedirect("/user/userLogin.jsp");
			response.getWriter().write("0");
			return;
		} else {
			userID = URLDecoder.decode(userID, "UTF-8");
			response.getWriter().write(new ChatDao().countUnreadChat(userID) + "");
		}
		
		
	}


}
