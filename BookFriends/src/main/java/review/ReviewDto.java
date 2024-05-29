package review;

import java.sql.Timestamp;

public class ReviewDto {

	int reviewID;
	String userID;
	String bookName;
	String authorName;
	String publisher; 
	String category;
	String reviewTitle;
	String reviewContent;
	int reviewScore;
	Timestamp registDate;
	int likeCount;
	int viewCount;
	
	public ReviewDto() {}
	
	public ReviewDto(int reviewID, String userID, String bookName, String authorName, String publisher, String category,
			String reviewTitle, String reviewContent, int reviewScore, Timestamp registDate, int likeCount, int viewCount) {
		super();
		this.reviewID = reviewID;
		this.userID = userID;
		this.bookName = bookName;
		this.authorName = authorName;
		this.publisher = publisher;
		this.category = category;
		this.reviewTitle = reviewTitle;
		this.reviewContent = reviewContent;
		this.reviewScore = reviewScore;
		this.registDate = registDate;
		this.likeCount = likeCount;
		this.viewCount = viewCount;
	}
	
	public int getReviewID() {
		return reviewID;
	}
	public void setReviewID(int reviewID) {
		this.reviewID = reviewID;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getBookName() {
		return bookName;
	}
	public void setBookName(String bookName) {
		this.bookName = bookName;
	}
	public String getAuthorName() {
		return authorName;
	}
	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}
	public String getPublisher() {
		return publisher;
	}
	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getReviewTitle() {
		return reviewTitle;
	}
	public void setReviewTitle(String reviewTitle) {
		this.reviewTitle = reviewTitle;
	}
	public String getReviewContent() {
		return reviewContent;
	}
	public void setReviewContent(String reviewContent) {
		this.reviewContent = reviewContent;
	}
	public int getReviewScore() {
		return reviewScore;
	}
	public void setReviewScore(int reviewScore) {
		this.reviewScore = reviewScore;
	}
	public Timestamp getRegistDate() {
		return registDate;
	}
	public void setRegistDate(Timestamp registDate) {
		this.registDate = registDate;
	}
	public int getLikeCount() {
		return likeCount;
	}
	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}

	
	
}
