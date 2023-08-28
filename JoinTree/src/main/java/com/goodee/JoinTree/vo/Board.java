package com.goodee.JoinTree.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Board {
	private int boardNo;
	private int empNo;
	private String boardCategory;
	private String boardTitle;
	private String boardContent;
	private String boardPinned; // VARCHAR(1) 0, 1
	private int boardCount;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
	
	// table 속성은 아니고 입력폼 속성 -> BoardForm.class(DTO), Board.class(도메인) 분리해서 사용 가능
	// 입력 시 위 컬럼명과 함께 업로드 파일도 받기 때문에 Board.java 내 위치
	private MultipartFile multipartFile;
	
	private String empName; // DB에 없음, 작성자 이름 출력을 위해 추가
	
	private int commentCnt; // DB에 없음, 게시글별 댓글 개수 출력을 위해 추가
}
