package board;

import java.sql.Timestamp;

public class BoardDto {
	
	int postID;
	String userID;
	String postCategory;
	String postTitle;
	String postContent;
	int viewCount;
	int likeCount;
	Timestamp postDate;
	
	public int getPostID() {
		return postID;
	}
	public void setPostID(int postID) {
		this.postID = postID;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getPostCategory() {
		return postCategory;
	}
	public void setPostCategory(String postCategory) {
		this.postCategory = postCategory;
	}
	public String getPostTitle() {
		return postTitle;
	}
	public void setPostTitle(String postTitle) {
		this.postTitle = postTitle;
	}
	public String getPostContent() {
		return postContent;
	}
	public void setPostContent(String postContent) {
		this.postContent = postContent;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public int getLikeCount() {
		return likeCount;
	}
	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	public Timestamp getPostDate() {
		return postDate;
	}
	public void setPostDate(Timestamp postDate) {
		this.postDate = postDate;
	}
	
	public BoardDto() {}
	
	public BoardDto(int postID, String userID, String postCategory, String postTitle, String postContent, int viewCount,
			int likeCount, Timestamp postDate) {
		super();
		this.postID = postID;
		this.userID = userID;
		this.postCategory = postCategory;
		this.postTitle = postTitle;
		this.postContent = postContent;
		this.viewCount = viewCount;
		this.likeCount = likeCount;
		this.postDate = postDate;
	}
	
	
	
}
