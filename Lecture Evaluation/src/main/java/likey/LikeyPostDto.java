package likey;

public class LikeyPostDto {
	
	String userID;
	String postID;
	String userIP;
	
	public LikeyPostDto() {}

	public LikeyPostDto(String userID, String postID, String userIP) {
		super();
		this.userID = userID;
		this.postID = postID;
		this.userIP = userIP;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getPostID() {
		return postID;
	}

	public void setPostID(String postID) {
		this.postID = postID;
	}

	public String getUserIP() {
		return userIP;
	}

	public void setUserIP(String userIP) {
		this.userIP = userIP;
	}
	
	
	
	

}
