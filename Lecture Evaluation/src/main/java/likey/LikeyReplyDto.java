package likey;

public class LikeyReplyDto {
	
	String userID;
	String replyID;
	String userIP;
	
	
	public LikeyReplyDto() {}


	public LikeyReplyDto(String userID, String replyID, String userIP) {
		super();
		this.userID = userID;
		this.replyID = replyID;
		this.userIP = userIP;
	}


	public String getUserID() {
		return userID;
	}


	public void setUserID(String userID) {
		this.userID = userID;
	}


	public String getReplyID() {
		return replyID;
	}


	public void setReplyID(String replyID) {
		this.replyID = replyID;
	}


	public String getUserIP() {
		return userIP;
	}


	public void setUserIP(String userIP) {
		this.userIP = userIP;
	}
	
	

}
