package file;

public class FileDto {
    private int fileID;
    private String fileName;
    private String fileOriginName;
    private String filePath;
    private Integer recruitID;  // Integer로 설정하여 null을 허용
    private Integer postID;     // Integer로 설정하여 null을 허용

    // Getters and Setters
    public int getFileID() {
        return fileID;
    }

    public FileDto(String fileName, String fileOriginName, String filePath) {
		super();
		this.fileName = fileName;
		this.fileOriginName = fileOriginName;
		this.filePath = filePath;
	}

	public void setFileID(int fileID) {
        this.fileID = fileID;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileOriginName() {
        return fileOriginName;
    }

    public void setFileOriginName(String fileOriginName) {
        this.fileOriginName = fileOriginName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public Integer getRecruitID() {
        return recruitID;
    }

    public FileDto(int fileID, String fileName, String fileOriginName, String filePath, Integer recruitID,
			Integer postID) {
		super();
		this.fileID = fileID;
		this.fileName = fileName;
		this.fileOriginName = fileOriginName;
		this.filePath = filePath;
		this.recruitID = recruitID;
		this.postID = postID;
	}

	public FileDto() {
	}

	public void setRecruitID(Integer recruitID) {
        this.recruitID = recruitID;
    }

    public Integer getPostID() {
        return postID;
    }

    public void setPostID(Integer postID) {
        this.postID = postID;
    }
}
