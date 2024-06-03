package chat;

import java.sql.Timestamp;

public class ChatDto {
    private int chatID;
    private String senderID;
    private String receiverID;
    private String message;
    private Timestamp chatTime;

    // Default constructor
    public ChatDto() {
    }

    // Parameterized constructor
    public ChatDto(int chatID, String senderID, String receiverID, String message, Timestamp chatTime) {
        this.chatID = chatID;
        this.senderID = senderID;
        this.receiverID = receiverID;
        this.message = message;
        this.chatTime = chatTime;
    }

    // Getters and setters
    public int getChatID() {
        return chatID;
    }

    public void setChatID(int chatID) {
        this.chatID = chatID;
    }

    public String getSenderID() {
        return senderID;
    }

    public void setSenderID(String senderID) {
        this.senderID = senderID;
    }

    public String getReceiverID() {
        return receiverID;
    }

    public void setReceiverID(String receiverID) {
        this.receiverID = receiverID;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getChatTime() {
        return chatTime;
    }

    public void setChatTime(Timestamp chatTime) {
        this.chatTime = chatTime;
    }
    

    // 디버깅을 쉽게하기 위한 메소드
    @Override
    public String toString() {
        return "ChatDTO{" +
                "chatID=" + chatID +
                ", senderID='" + senderID + '\'' +
                ", receiverID='" + receiverID + '\'' +
                ", message='" + message + '\'' +
                ", chatTime=" + chatTime +
                '}';
    }

}
