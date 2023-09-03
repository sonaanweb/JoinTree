package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class MeetRoomFile {

	private int roomFileNo;
	private int roomNo;
	private String roomOriginFilename;
	private String roomSaveFilename;
	private String roomFiletype;
	private long roomFilesize;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
