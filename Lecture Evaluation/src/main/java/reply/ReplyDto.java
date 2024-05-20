package reply;

import java.sql.Timestamp;

public class ReplyDto {

	int replyID;
	String userID;
	int postID;
	String replyContent;
	int likeCount;
	Timestamp replyDate;
	
	public ReplyDto() {}

	public ReplyDto(int replyID, String userID, int postID, String replyContent, int likeCount, Timestamp replyDate) {
		super();
		this.replyID = replyID;
		this.userID = userID;
		this.postID = postID;
		this.replyContent = replyContent;
		this.likeCount = likeCount;
		this.replyDate = replyDate;
	}

	public int getReplyID() {
		return replyID;
	}

	public void setReplyID(int replyID) {
		this.replyID = replyID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public int getPostID() {
		return postID;
	}

	public void setPostID(int postID) {
		this.postID = postID;
	}

	public String getReplyContent() {
		return replyContent;
	}

	public void setReplyContent(String replyContent) {
		this.replyContent = replyContent;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}

	public Timestamp getReplyDate() {
		return replyDate;
	}

	public void setReplyDate(Timestamp replyDate) {
		this.replyDate = replyDate;
	}
	
	
	
}
