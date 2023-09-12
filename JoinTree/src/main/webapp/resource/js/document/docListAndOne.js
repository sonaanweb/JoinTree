	$(document).ready(function(){
		
		// 페이지 로드 시 검색조건 초기화
		docListResults();
	});
	
	// 페이지 네비게이션 수정 함수
	function updatePagination(data){
		let pagination = $('#pagination');
		pagination.empty();
		
		// 이전 페이지 버튼
		if(data.startPage > 1){
			let prevButton = $('<button type="button" class="page-link">').text('이전');
            prevButton.click(function() {
                goToPage(data.startPage - 1);
            });
            pagination.append(prevButton);
		}
		
		// 페이지 버튼 생성
		for(let i = data.startPage; i <= data.endPage; i++){
			const page = i;
			let pageButton = $('<button type="button" class="page-link">').text(i);
	        
	        // 현재 페이지일 때 'selected-page' 클래스 추가
	        if (page === data.currentPage) {
	        	pageButton.addClass('selected-page');
				pageButton.prop('disabled', true); // 현재 페이지 버튼 비활성화
	        }
	        
	        pageButton.click(function(){
	        	goToPage(page);
	        });
	        pagination.append(pageButton);
		}
		
		// 다음 페이지 버튼
		if(data.endPage < data.lastPage){
			let nextButton = $('<button type="button" class="page-link">').text('다음');
            nextButton.click(function() {
                goToPage(data.endPage + 1);
            });
            pagination.append(nextButton);
		}
	}
	
	// 문서함별 사원 목록 테이블(docList) 테이터 수정 함수
	function updateDocListTableData(docList, data){
		
		// 테이블의 tbody를 선택하고 초기화
	    let tbody = $('#docList');
	    tbody.empty();
	    
	    // 로그인 사번 값 저장
	    let loginEmpNo = data.loginEmpNo;
	    
	    // data의 길이만큼 테이블 행 추가
	    for (let i = 0; i < docList.length; i++) {
	        let doc = docList[i];
	        
	        let row = $('<tr class="selectde-tr">').data('docCode', doc.docCode);
	        row.append($('<td class="text-center">').text(doc.docNo)); // 문서번호
	        
	        let dateOnly = doc.createdate.split("T")[0]; // 기안일 날짜 값만 저장
	        row.append($('<td class="text-center">').text(dateOnly)); // 기안일
	        
	        row.append($('<td class="text-center">').text(doc.category)); // 기안 양식
	        
	        // 로그인 사번이 참조자인 경우 분기
	        let docTitle;
	        if(loginEmpNo == doc.referenceNo){
				// 참조자인 경우
				docTitle = doc.docTitle + ' [참조]';
			} else{
				docTitle = doc.docTitle;
			}
			console.log(docTitle+'<--docTitle');
	        row.append($('<td>').text(docTitle)); // 제목
	        row.append($('<td>').text(doc.empNo + " " + doc.writer)); // 기안자(사번 + 이름)
	        row.append($('<td class="text-center">').text(doc.docStatus)); // 상태
	        tbody.append(row);
	    }
	}
	
	// 검색 조건별 결과 값 함수
	function docListResults(page=1){
		
		// 데이터 조회
		$.ajax({
			url: '/JoinTree/document/getDocumentList',
			type: 'GET',
			data: {
				listId: $('#listId').val(), // 문서함 id
				writer: $('#searchWriter').val(), // 기안자
				docTitle: $('#searchDocTitle').val(), // 문서제목
				startDate: $('#searchStartDate').val(), // 조회 시작일
				endDate: $('#searchEndDate').val(), // 조회 종료일
				currentPage: page,
				rowPerPage: 10
			},
			success: function(data){
				console.log(data);
				
				let docList = data.searchDocListbyPage; // 문서 목록
				
				updateDocListTableData(docList, data); // 테이블 데이터 수정 함수
				updatePagination(data); // 페이지 네비게이션 데이터 수정 함수
			},
			error: function(error){
				console.error(error);
			}
		});
	}
	
	// 페이지 이동 함수
	function goToPage(page){
		// 검색 및 페이지 데이터 수정 함수
	  	docListResults(page);
    }
    
    // 검색 버튼 클릭 이벤트
	$('#searchDocListBtn').click(function(){
		docListResults();
	});
	
	// signImg 경로
	let pathUrl = '/JoinTree/signImg/';
	
	// 결재자 서명 경로 설정 함수
	function setDocStamp(docStampId, docStampValue){
		let docStampSrc = $(docStampId); 
		if(docStampValue){
			docStampSrc.attr('src', pathUrl + docStampValue);
		} else{
			docStampSrc.hide();
		}
	}
	
	// 문서별 상세문서 양식 모달창 업데이트
	async function updateDocumentOneForm(documentCode) {
	    return new Promise((resolve, reject) => {
	        $.ajax({
	            type: 'GET',
	            url: '/JoinTree/document/getDocumentOneForm',
	            data: {
	                docCode: documentCode
	            },
	            success: function (data) {
	                $('#documentOneForm').html(data);
	                resolve(); // 업데이트 완료 후 프로미스 resolve 호출
	            },
	            error: function () {
	                console.log('error');
	                reject(); // 에러 발생 시 프로미스 reject 호출
	            }
	        });
	    });
	}
	
	// 문서결재 상세정보 조회
	async function getDocOne(documentNo, documentCode) {
	    return new Promise((resolve, reject) => {
	        // 상세 정보 가져오기
	        $.ajax({
	            url: '/JoinTree/document/getDocumentOne',
	            type: 'GET',
	            data: {
	                docNo: documentNo,
	                docCode: documentCode
	            },
	            success: function (data) {
	                
	                // 현재 로그인한 사번
	                let empNo = data.empNo;
	                
	            	// 결재문서 상세정보 값 변수에 저장
	            	// 기본기안서(공통)
					let docNo = data.docNo; // 문서번호
					let createdate = data.createdate.split("T")[0]; // 기안일
					let writer = data.writer; // 기안자
					let docStamp1 = data.docStamp1; // 기안자 서명
					let docStamp2= data.docStamp2; // 결재자1 서명
					let docStamp3 = data.docStamp3; // 결재자2 서명
					let reference = data.reference; // 참조자
					let receiverTeam = data.receiverTeam; // 수신팀
					let docTitle = data.docTitle; // 문서 제목
					let docContent = data.docContent; // 문서 내용
					let dept = data.dept; // 기안부서
					let position = data.position; // 기안자 직급
					let docSaveFileName = data.docSaveFileName; // 첨부파일 저장명
					let docOriginFileName = data.docOriginFileName; // 첨부파일 원본명
					let signer1Name = data.signer1Name; // 결재자1 사원명
					let signer1No = data.signer1No; // 결재자1 사번
					let signer1Position = data.signer1Position; // 결재자1 직급
					let signer2Name = data.signer2Name; // 결재자2 사원명
					let signer2No = data.signer2No; // 결재자2 사번
					console.log("signer2No",signer2No);
					
					let signer2Position = data.signer2Position; // 결재자2 직급
					console.log("signer2Position",signer2Position);
					
					// 휴가신청서
					let leaveType = data.leaveType; // 연차구분
					let docLeaveStartDate = data.docLeaveStartDate; // 연차 시작일
					let docLeaveEndDate = data.docLeaveEndDate; // 연차 종료일
					let docLeavePeriodDate = data.docLeavePeriodDate // 연차 일수
					let docLeaveTel = data.docLeaveTel; // 비상연락처
					
					// 인사이동신청서
					let docReshuffleDate = data.docReshuffleDate; // 인사이동 일자
					let docReshufflePosition = data.docReshufflePosition; // 변경 후 직급
					let docReshuffleDept = data.docReshuffleDept; // 변경 후 부서
					let docReshuffleTask = data.docReshuffleTask; // 주요업무
					let docReshuffleResult = data.docReshuffleResult // 업무성과
					let docReshuffleReason = data.docReshuffleReason // 발령사유
					
					// 사원 상세정보 값 설정
					// 기본기안서(공통)
					$('#docNo').text(docNo); // 문서번호
					$('#createdate').text(createdate); // 기안일
					$('.writer').text(writer); // 기안자
					$('#reference').text(reference); // 참조자
					$('#receiverTeam').text(receiverTeam); // 수신팀
					$('#docTitle').text(docTitle); // 문서 제목
					$('#docContent').text(docContent); // 문서 내용
					$('.dept').text(dept); // 기안부서
					$('.position').text(position); // 기안자 직급
					$('#signer1Name').text(signer1Name); // 결재자1 사원명
					$('#signer1Position').text(signer1Position); // 결재자1 직급
					$('#signer2Name').text(signer2Name); // 결재자2 사원명
					$('#signer2Position').text(signer2Position); // 결재자2 직급
					// 결재자2가 없을 경우 해당 칸 숨기기
					if(signer2Name && signer2Position && signer2No) {
						$('.sign2').removeClass("hidden");
					}
					// 서명 경로 설정(setDocStamp : 결재자 서명 경로 설정 함수)
					setDocStamp('#docStamp1', docStamp1); // 기안자 서명 경로 설정
					setDocStamp('#docStamp2', docStamp2); // 결재자2 서명 경로 설정
					setDocStamp('#docStamp3', docStamp3); // 결재자3 서명 경로 설정
					
					// 첨부파일 경로 설정
					if(docSaveFileName != null){ // 첨부파일이 있을 경우
						let docSaveFileNameHref = $('#docSaveFileName');
						docSaveFileNameHref.text(docOriginFileName+" 다운로드");
						docSaveFileNameHref.attr('href', docSaveFileNameHref.attr('href') + docSaveFileName); // 파일 경로설정
						docSaveFileNameHref.attr('download', docOriginFileName); // 다운로드할 파일 이름
					}
					
					// 휴가신청서
					$('#leaveType').text(leaveType); // 연차구분
					$('#docLeaveStartDate').text(docLeaveStartDate); // 연차 시작일
					$('#docLeaveEndDate').text(docLeaveEndDate); // 연차 종료일
					$('#docLeavePeriodDate').text(docLeavePeriodDate); // 연차 일수
					$('#docLeaveTel').text(docLeaveTel); // 비상연락처
					
					// 인사이동신청서
					$('#docReshuffleDate').text(docReshuffleDate); // 인사이동 일자
					$('#docReshufflePosition').text(docReshufflePosition); // 변경 후 직급
					$('#docReshuffleDept').text(docReshuffleDept); // 변경 후 부서
					$('#docReshuffleTask').text(docReshuffleTask); // 주요업무
					$('#docReshuffleResult').text(docReshuffleResult); // 업무성과
					$('#docReshuffleReason').text(docReshuffleReason); // 발령사유
					
					// 문서결재 결제, 반려 버튼 분기
					// 로그인 사번이 결재자인 경우 결재자 서명이 없을 경우 버튼 활성화
					if ((signer1No == empNo && docStamp2 == null) || (signer2No == empNo && docStamp3 == null)) {
				        $('#approvalAndRejectBtn').show();
				    } else if((signer1No == empNo && docStamp2 == null) || (signer2No == empNo && docStamp3 == null)) { 
				    // 로그인 사번이 결재자1 또는 결재자2 이면서 결재자 서명이 없을 경우 버튼 활성화
				    $('#approvalAndRejectBtn').show(); 
					} else{
						$('#approvalAndRejectBtn').hide();
					}
					
	                resolve(); // 호출 완료 후 프로미스 resolve 호출
	            },
	            error: function () {
	                console.log('error');
	                reject(); // 에러 발생 시 프로미스 reject 호출
	            }
	        });
	    });
	}
	
	
	
	
	