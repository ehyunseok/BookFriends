package likey;

public class LikeyReviewDto {
	
	String userID;
	String reviewID;
	String userIP;
	
	public LikeyReviewDto() {}

	public LikeyReviewDto(String userID, String reviewID, String userIP) {
		super();
		this.userID = userID;
		this.reviewID = reviewID;
		this.userIP = userIP;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getReviewID() {
		return reviewID;
	}

	public void setReviewID(String reviewID) {
		this.reviewID = reviewID;
	}

	public String getUserIP() {
		return userIP;
	}

	public void setUserIP(String userIP) {
		this.userIP = userIP;
	}
	
	
	
	

}
