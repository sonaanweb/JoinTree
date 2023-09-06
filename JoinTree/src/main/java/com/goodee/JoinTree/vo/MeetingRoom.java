package com.goodee.JoinTree.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MeetingRoom {

	private int roomNo;
	private String equipCategory;
	private int empNo;
	private String roomName;
	private int roomCapacity;
	private String roomStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
	
	private MultipartFile multipartFile; //이미지 업로드용
    private String meetRoomFile; // MeetRoomFile 정보를 담는 필드
    private String roomSaveFilename;

}
