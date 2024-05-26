package recruit;

import java.sql.Timestamp;

public class RecruitDto {

	int recruitID;
	String userID;
	String recruitStatus;
	String recruitTitle;
	String recruitContent;
	Timestamp registDate;
	int viewCount;
	
	public RecruitDto() {}
	
	public RecruitDto(int recruitID, String userID, String recruitStatus, String recruitTitle, String recruitContent,
			Timestamp registDate, int viewCount) {
		super();
		this.recruitID = recruitID;
		this.userID = userID;
		this.recruitStatus = recruitStatus;
		this.recruitTitle = recruitTitle;
		this.recruitContent = recruitContent;
		this.registDate = registDate;
		this.viewCount = viewCount;
	}

	public int getRecruitID() {
		return recruitID;
	}

	public void setRecruitID(int recruitID) {
		this.recruitID = recruitID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getRecruitStatus() {
		return recruitStatus;
	}

	public void setRecruitStatus(String recruitStatus) {
		this.recruitStatus = recruitStatus;
	}

	public String getRecruitTitle() {
		return recruitTitle;
	}

	public void setRecruitTitle(String recruitTitle) {
		this.recruitTitle = recruitTitle;
	}

	public String getRecruitContent() {
		return recruitContent;
	}

	public void setRecruitContent(String recruitContent) {
		this.recruitContent = recruitContent;
	}

	public Timestamp getRegistDate() {
		return registDate;
	}

	public void setRegistDate(Timestamp registDate) {
		this.registDate = registDate;
	}

	public int getViewCount() {
		return viewCount;
	}

	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	
	
	
	
	
}
