package likey;

public class LikeyDto {
	
	String userID;
	String evaluationID;
	String userIP;
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getEvaluationID() {
		return evaluationID;
	}
	public void setEvaluationID(String evaluationID) {
		this.evaluationID = evaluationID;
	}
	public String getUserIP() {
		return userIP;
	}
	public void setUserIP(String userIP) {
		this.userIP = userIP;
	}
	
	public LikeyDto() {}
	
	public LikeyDto(String userID, String evaluationID, String userIP) {
		super();
		this.userID = userID;
		this.evaluationID = evaluationID;
		this.userIP = userIP;
	}
	
	

}
