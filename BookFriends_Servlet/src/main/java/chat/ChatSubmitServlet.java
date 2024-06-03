package chat;

import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import user.UserDao;

@WebServlet("/ChatSubmitServlet")
public class ChatSubmitServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/plain; charset=UTF-8");
		String senderID = request.getParameter("senderID");
		String receiverID = URLDecoder.decode(request.getParameter("receiverID"), "UTF-8");
		String message = request.getParameter("message");

		if(senderID == null || senderID.isEmpty() 
			|| receiverID == null || receiverID.isEmpty() 
			|| message == null || message.isEmpty()) {
			response.getWriter().write("0");
			return;
		}

		System.out.println("Servlet-Processed receiverID: '" + receiverID + "'");
		if(!new UserDao().isValidUser(receiverID)) {
			response.getWriter().write("Invalid receiver ID");
			System.out.println("error-수신자 ID가 유효하지 않음");
			return;
		}

		int result = new ChatDao().submit(senderID, receiverID, message);
		response.getWriter().write(String.valueOf(result));
	}
	

	
}