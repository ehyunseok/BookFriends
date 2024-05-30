package chat;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ChatListServlet")
public class ChatListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/plain; charset=UTF-8");
		String senderID = request.getParameter("senderID");
		String receiverID = request.getParameter("receiverID");
		String listType = request.getParameter("listType");	// 특정 id값으로 대화 정보를 가져옴
		if(senderID == null || senderID.equals("") 
			|| receiverID == null || receiverID.equals("") 
			|| listType == null || listType.equals("")) {
			response.getWriter().write("0");
			System.out.println("error-메시지를 서버로 전송하지 못함");
		} else if(listType.equals("ten")) {
			response.getWriter().write(getTen(URLDecoder.decode(senderID,"UTF-8"), URLDecoder.decode(receiverID,"UTF-8")));
		} else {
			try {
				response.getWriter().write(getID(URLDecoder.decode(senderID,"UTF-8"), URLDecoder.decode(receiverID,"UTF-8"), listType));
			} catch (IOException e) {
				response.getWriter().write("0");
			}
		}
	}
	
	public String getTen(String senderID, String receiverID) {
	    StringBuffer result = new StringBuffer("");
	    
	    result.append("{\"result\":[");
	    ChatDao chatDao = new ChatDao();
	    ArrayList<ChatDto> chatList = chatDao.getChatListByRecent(senderID, receiverID, 10);
	    if(chatList.size() == 0) return "{}"; // 변경: 빈 배열 대신 빈 객체 반환
	    Iterator<ChatDto> iterator = chatList.iterator();
	    while(iterator.hasNext()) {
	        ChatDto chat = iterator.next();
	        String message = escapeJson(chat.getMessage());
	        result.append("[{\"value\": \"" + escapeJson(chat.getSenderID()) + "\"},");
	        result.append("{\"value\": \"" + escapeJson(chat.getReceiverID()) + "\"},");
	        result.append("{\"value\": \"" + message + "\"},");
	        result.append("{\"value\": \"" + chat.getChatTime() + "\"}]");
	        if (iterator.hasNext()) {
	            result.append(",");
	        }
	    }
	    result.append("], \"last\":\"" + chatList.get(chatList.size()-1).getChatID() + "\"}");
	    return result.toString();
	}

	// JSON 문자열에서 특수 문자를 이스케이프하는 메소드
	private String escapeJson(String x) {
	    return x.replace("\\", "\\\\")
	            .replace("\"", "\\\"")
	            .replace("\n", "\\n")
	            .replace("\r", "\\r")
	            .replace("\t", "\\t");
	}
	
	
	public String getID(String senderID, String receiverID, String chatID) {
		StringBuffer result = new StringBuffer("");
		
		result.append("{\"result\":[");
		ChatDao chatDao = new ChatDao();
		ArrayList<ChatDto> chatList = chatDao.getChatListByID(senderID, receiverID, chatID);
		if(chatList.size() == 0) return "";
		Iterator<ChatDto> iterator = chatList.iterator();
		while(iterator.hasNext()) {
			ChatDto chat = iterator.next();
			result.append("[{\"value\": \"" + chat.getSenderID() + "\"},");
			result.append("{\"value\": \"" + chat.getReceiverID() + "\"},");
			result.append("{\"value\": \"" + chat.getMessage() + "\"},");
			result.append("{\"value\": \"" + chat.getChatTime() + "\"}]");
			if (iterator.hasNext()) {
				result.append(",");
			}
		}
		result.append("], \"last\":\"" + chatList.get(chatList.size()-1).getChatID() + "\"}");
		return result.toString();
	}
	

}
