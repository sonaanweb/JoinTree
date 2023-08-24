package com.goodee.JoinTree.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class DocumentDefault {

	private int docNo;
	private int empNo;
	private String docTitle;
	private String docContent;
	private String category;
	private String writer;
	private int reference;
	private String receiverTeam;
	private String docStatus;
	private String docStamp1;
	private String docStamp2;
	private String docStamp3;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
	private MultipartFile multipartFile;
}
