package com.goodee.JoinTree.vo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Reservation {

	private int revNo;
	private int empNo;
	private String roomName; // 회의실 이름 join용
	private String empName; // 사원 이름 join용
	private String updateName; // 수정자 join용
	private int equipNo;
	private String equipCategory;
	
    /* 예약 시작시간과 종료시간 localdatetime 적용
	컬럼 데이터 형태가 datetime인 경우 이렇게 바꿨을 시 다른쪽에서 별도의 수정 X */
    private LocalDateTime revStartTime;
    private LocalDateTime revEndTime;
   
	private String revStatus;
	private String revReason;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
