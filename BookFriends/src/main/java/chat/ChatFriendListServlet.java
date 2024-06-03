package chat;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import user.UserDto;

@WebServlet("/ChatFriendListServlet")
public class ChatFriendListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
        
        HttpSession session = request.getSession();
		
        String userID = (String) session.getAttribute("userID");
		System.out.println("CFLS-Received GET request for userID: " + userID);
		if(userID == null) {
			response.sendRedirect("/user/userLogin.jsp");
			return;
		}
		
		
		ChatDao  chatDao = new ChatDao();
		ArrayList<UserDto> chatFriends = chatDao.getChatFriends(userID);
		
		request.setAttribute("chatFriends", chatFriends);
		
		RequestDispatcher rp = request.getRequestDispatcher("/chat/chat2.jsp");
		rp.forward(request, response);
		System.out.println("CFLS-GET request processed successfully");
		
	}


}
