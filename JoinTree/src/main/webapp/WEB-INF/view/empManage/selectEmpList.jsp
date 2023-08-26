<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectEmpList</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
	
		<!-- 사원등록 모달창 버튼 -->
		<div>
			<button type="button" id="addEmpModalBtn" data-bs-toggle="modal" data-bs-target="#addEmpModal"> 사원등록</button>
		</div>
		<!-- 검색별 조회 -->
		<div>
			<form id="searchEmpListForm">
				<div>
					<div>사번</div>
					<input type="text" id="searchEmpNo" name="empNo">
				</div>
				<div>
					<div>사원명</div>
					<input type="text" id="searchEmpName" name="empName">
				</div>
				<div>
					<div>상태</div>
					<select id="searchActive" name="active">
						<option value="">선택하세요</option>
						<c:forEach var="a" items="${activeCodeList}">
							<option value="${a.code}">${a.codeName}</option>
						</c:forEach>
					</select>
				</div>
				<div>
					<div>입사일</div>
					<input type="date" id="searchStartEmpHireDate" name="startEmpHireDate"> &#126; 
					<input type="date" id="searchEndEmpHireDate" name="endEmpHireDate">
				</div>
				<div>
					<div>부서</div>
					<select id="searchDept" name="dept">
						<option value="">선택하세요</option>
						<c:forEach var="d" items="${deptCodeList}">
							<option value="${d.code}">${d.codeName}</option>
						</c:forEach>
					</select>
				</div>
				<div>
					<div>직급</div>
					<select id="searchPosition" name="position">
						<option value="">선택하세요</option>
						<c:forEach var="p" items="${positionCodeList}">
							<option value="${p.code}">${p.codeName}</option>
						</c:forEach>
					</select>
				</div>
				<div>
					<button type="button" id="searchEmpListBtn">검색</button>
				</div>
			</form>
		</div>
		
		<!-- 검색별 사원 목록 출력 -->
		<table>
			<thead>
				<tr>
					<th>사번</th>
					<th>사원명</th>
					<th>입사일</th>
					<th>부서</th>
					<th>직급</th>
					<th>재직상태</th>
				</tr>
			</thead>
			<tbody id="empInfoList">
			
			</tbody>
		</table>
		
		
		<!-- 페이지 네비게이션 -->
		<div id="pagination">
			
		</div>
	

	<!-- 사원 등록 모달창 -->
	<div class="modal" id="addEmpModal">
		<div class="modal-dialog">
			<div class="modal-content">
			
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">사원 등록</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal" id="addEmpModalClose"></button>
				</div>
			
				<!-- Modal body -->
				<div class="modal-body">
					<form id="addEmpForm" method="post">
						<div>
							<div>사원명</div>
							<input type="text" id="empName" name="empName">
						</div>
						<div>
							<div>주민번호</div>
							<input type="text" id="empJuminNo1" name="empJuminNo1"> &#45; 
							<input type="text" id="empJuminNo2" name="empJuminNo2">
						</div>
						<div>
							<div>연락처</div>
							<input type="text" id="empPhone1" name="empPhone1"> &#45; 
							<input type="text" id="empPhone2" name="empPhone2"> &#45; 
							<input type="text" id="empPhone3" name="empPhone3">
						</div>
						<div>
							<div>주소</div>
							<div>
								<input type="text" name="postCode" id="sample6_postcode" placeholder="우편번호" readonly="readonly">
							</div>
							<div>
								<input type="button" onclick="sample6_execDaumPostcode()" id="postCodeBtn" value="우편번호 찾기" class="btn btn-primary">
							</div>
							<div>
								<input type="text" name="add1" id="sample6_address" placeholder="주소" class="form-control" readonly="readonly">
								<input type="text" name="add2" id="sample6_detailAddress" placeholder="상세주소" class="form-control">
								<input type="text" name="add3" id="sample6_extraAddress" placeholder="참고항목" class="form-control">
							</div>
						</div>
						<div>
							<div>부서</div>
							<select id="deptCategory" name="dept">
								<option value="">선택하세요</option>
								<c:forEach var="d" items="${deptCodeList}">
									<option value="${d.code}">${d.codeName}</option>
								</c:forEach>
							</select>
						</div>
						<div>
							<div>직급</div>
							<select id="positionCategory" name="position">
								<option value="">선택하세요</option>
								<c:forEach var="p" items="${positionCodeList}">
									<option value="${p.code}">${p.codeName}</option>
								</c:forEach>
							</select>
						</div>
						<div>
							<div>내선번호</div>
							<input type="text" id="empExtensionNo" name="empExtensionNo">
						</div>
						<div>
							<div>입사일</div>
							<input type="date" id="empHireDate" name="empHireDate">
						</div>
						<div class="text-center">
							<button type="button" id="addEmpBtn">등록</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 사원 상세정보, 수정 모달창 -->
	<div class="modal" id="empOneModal">
		<div class="modal-dialog">
			<div class="modal-content" id="empOneModalContent">
			
			<!-- 사원 상세 정보 조회 -->
			<jsp:include page="./selectEmpOne.jsp"></jsp:include>

			<!-- 사원 정보 수정 -->
			<jsp:include page="./modifyEmpForm.jsp"></jsp:include>
			
			</div>
		</div>
	</div>
</body>

<script>
	
	$(document).ready(function() {
		
		// 사원등록 성공, 실패 시 메세지
		const urlParams = new URL(location.href).searchParams;
	    const msg = urlParams.get("msg");
	    if (msg != null) {
	       alert(msg);
	       
	    // 쿼리 매개변수 "msg"를 제거하고 URL을 업데이트
        urlParams.delete("msg");
        const newUrl = `${location.pathname}?${urlParams.toString()}`;
        history.replaceState({}, document.title, newUrl);
	    }
	    
	 	// 페이지 로드 시 검색조건 초기화
		searchEmpListResults();
	});
	
	// 요청 값 공백검사 함수
	function checkEmptyAndAlert(input, message, focus) {
	    if (input.trim() == '') {
	        alert(message);
	        $(focus).focus();
	        return true;
	    }
	    return false;
	}
	
	// 주민번호 유효성 검사 함수
	function isValidEmpJuminNo(empJuminNo1, empJuminNo2){
		
		// empJuminNo1 유효성 검사
		if (!/^\d{6}$/.test(empJuminNo1)) {
        	return false;
    	}
		
		// 년, 월, 일 값 저장
		const year = parseInt(empJuminNo1.substr(0, 2), 10); // 년
	    const month = parseInt(empJuminNo1.substr(2, 2), 10); // 월
	    const day = parseInt(empJuminNo1.substr(4, 2), 10); // 일
	    
	 	// 생년월일 정보가 유효한지 검사합니다.
	    if (year < 0 || month <= 0 || month > 12 || day <= 0 || day > 31) {
	        return false;
	    }
	    
	    // empJuminNo2 유효성 검사
	    if (!/^\d{7}$/.test(empJuminNo2)) {
	        return false;
	    }
	    
	    return true;
	}
	
	// 연락처 유효성 검사 함수
	function isValidEmpPhone(empPhone1, empPhone2, empPhone3){
		
		// 각 부분의 유효성 검사
	    if (!/^\d{2,3}$/.test(empPhone1)) { // 첫 번째(2-3자리)
	        return false;
	    }

	    if (!/^\d{3,4}$/.test(empPhone2)) { // 두 번째(3-4자리)
	        return false;
	    }

	    if (!/^\d{4}$/.test(empPhone3)) { // 세 번째(4자리)
	        return false;
	    }

	    return true;
	}
	
	// 내선번호 유효성 검사 함수
	function isValidEmpExtensionNo(empExtensionNo){
		
		if (!/^\d{4}$/.test(empExtensionNo)) { // 4자리
	        return false;
	    }
		
		return true;
	}
	
	// 주소찾기 https://devofroad.tistory.com/42 참고
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                let addr = ''; // 주소 변수
                let extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById('sample6_extraAddress').value = extraAddr;
                
                } else {
                    document.getElementById('sample6_extraAddress').value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample6_postcode').value = data.zonecode;
                document.getElementById('sample6_address').value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('sample6_detailAddress').focus();
            }
        }).open();
    }
	
	// 사원등록 버튼(addEmpBtn) click
	$('#addEmpBtn').on('click', function(){
		
		// 값 공백 검사
		if (checkEmptyAndAlert($('#empName').val(), '사원명을 입력해주세요', '#empName')) return; // 사원명
		if (checkEmptyAndAlert($('#empJuminNo1').val(), '주민번호를 입력해주세요', '#empJuminNo1')) return; // 주민번호1
		if (checkEmptyAndAlert($('#empJuminNo2').val(), '주민번호를 입력해주세요', '#empJuminNo2')) return; // 주민번호2
		if (checkEmptyAndAlert($('#empPhone1').val(), '연락처를 입력해주세요', '#empPhone1')) return; // 연락처1
		if (checkEmptyAndAlert($('#empPhone2').val(), '연락처를 입력해주세요', '#empPhone2')) return; // 연락처2
		if (checkEmptyAndAlert($('#empPhone3').val(), '연락처를 입력해주세요', '#empPhone3')) return; // 연락처3
		if (checkEmptyAndAlert($('#sample6_postcode').val(), '우편번호를 입력해주세요', '#postCodeBtn')) return; // 우편번호
		if (checkEmptyAndAlert($('#sample6_address').val(), '주소를 입력해주세요', '#sample6_address')) return; // 주소
		if (checkEmptyAndAlert($('#sample6_detailAddress').val(), '상세주소를 입력해주세요', '#sample6_detailAddress')) return; // 상세주소
		if (checkEmptyAndAlert($('#deptCategory').val(), '부서를 선택해주세요', '#deptCategory')) return; // 부서
		if (checkEmptyAndAlert($('#positionCategory').val(), '직급을 선택해주세요', '#positionCategory')) return; // 직급
		if (checkEmptyAndAlert($('#empExtensionNo').val(), '내선번호를 입력해주세요', '#empExtensionNo')) return; // 내선번호
		if (checkEmptyAndAlert($('#empHireDate').val(), '입사일을 입력해주세요', '#empHireDate')) return; // 입사일
		
		// 주민번호 유효성 검사
		let empJuminNo1 = $('#empJuminNo1').val(); // 주민번호1
		let empJuminNo2 = $('#empJuminNo2').val(); // 주민번호2
		if (!isValidEmpJuminNo(empJuminNo1, empJuminNo2)) {
		   	alert('유효하지 않은 주민등록번호입니다');
		   	$('#empJuminNo1').focus();
		   	return;
		} 
		
		// 연락처 유효성 검사
		let empPhone1 = $('#empPhone1').val(); // 주민번호1
		let empPhone2 = $('#empPhone2').val(); // 주민번호2
		let empPhone3 = $('#empPhone3').val(); // 주민번호3
		if(!isValidEmpPhone(empPhone1, empPhone2, empPhone3)) {
			alert('유효하지 않은 연락처입니다');
			$('#empPhone1').focus();
			return;
		}
		
		// 내선번호 유효성 검사
		let empExtensionNo = $('#empExtensionNo').val();
		if(!isValidEmpExtensionNo(empExtensionNo)){
			alert('유효하지 않은 내선번호입니다');
			$('#empExtensionNo').focus();
			return;
		}
		
		// 값 유효성 검사 후 사원 등록
	    let addEmpUrl = '/JoinTree/empManage/addEmp';
		$('#addEmpForm').attr('action', addEmpUrl);
	    $('#addEmpForm').submit();
	    
	});
	
	// 모달창(사원등록) 입력내용 초기화 함수
	function resetAddEmpModal() {
	    // 사원등록 초기화
	    $('#empName').val('');
	    $('#empJuminNo1').val('');
	    $('#empJuminNo2').val('');
	    $('#empPhone1').val('');
	    $('#empPhone2').val('');
	    $('#empPhone3').val('');
	    $('#sample6_postcode').val('');
	    $('#sample6_address').val('');
	    $('#sample6_detailAddress').val('');
	    $('#sample6_extraAddress').val('');
	    $('#deptCategory').val('');
	    $('#positionCategory').val('');
	    $('#empExtensionNo').val('');
	    $('#empHireDate').val('');
	}
	
	// 모달창(사원등록) 닫을 때
 	$('#addEmpModalClose').click(function(){
 		// 모달창 입력 내용 초기화
 		resetAddEmpModal();
 	});
	
	// 페이지 네비게이션 수정 함수
	function updatePagination(data){
		let pagination = $('#pagination');
		pagination.empty();
		
		// 이전 페이지 버튼
		if(data.startPage > 1){
			let prevButton = $('<button type="button" class="page-btn">').text('이전');
            prevButton.click(function() {
                goToPage(data.startPage - 1);
            });
            pagination.append(prevButton);
		}
		
		// 페이지 버튼 생성
		for(let i = data.startPage; i <= data.endPage; i++){
			const page = i;
			let pageButton = $('<button type="button" class="page-btn">').text(i);
	        pageButton.click(function(){
	        	goToPage(page);
	        });
	        pagination.append(pageButton);
		}
		
		// 다음 페이지 버튼
		if(data.endPage < data.lastPage){
			let nextButton = $('<button type="button" class="page-btn">').text('다음');
            nextButton.click(function() {
                goToPage(data.endPage + 1);
            });
            pagination.append(nextButton);
		}
	}
	
	// 검색별 사원 목록 테이블(empInfoList) 데이터 수정 함수
	function updateTableWithData(data) {
	    // data는 서버에서 반환된 JSON 데이터
	    // data 객체 속성에 접근하여 값 추출
	    let empList = data.searchEmpListByPage;
	    
	    // 테이블의 tbody를 선택하고 초기화
	    let tbody = $('#empInfoList');
	    tbody.empty();

	    // data의 길이만큼 테이블 행을 추가
	    for (let i = 0; i < empList.length; i++) {
	        let emp = empList[i];
	        let row = $('<tr>');
	        row.append($('<td>').text(emp.empNo));
	        row.append($('<td>').text(emp.empName));
	        row.append($('<td>').text(emp.empHireDate));
	        row.append($('<td>').text(emp.dept));
	        row.append($('<td>').text(emp.position));
	        row.append($('<td>').text(emp.active));
	        tbody.append(row);
	    }
	}
	
	// 검색 조건별 결과 값 함수
	function searchEmpListResults(page =1){
		
		// 검색 조건
		let searchEmpList = {
			empNo: $('#searchEmpNo').val(),
			empName: $('#searchEmpName').val(),
			active: $('#searchActive').val(),
			startEmpHireDate: $('#searchStartEmpHireDate').val(),
			endEmpHireDate: $('#searchEndEmpHireDate').val(),
			dept: $('#searchDept').val(),
			position: $('#searchPosition').val()
		};
		
		// 데이터 조회
		$.ajax({
			url: '/JoinTree/empManage/searchEmpList',
			type: 'GET',
			data: {
				// 검색조건 객체를 JSON으로 변환
				searchEmpList: JSON.stringify(searchEmpList),
				currentPage: page, // 현재페이지
				rowPerPage: 10 // 한 페이지당 행의 수
			},
			success: function(data){
				console.log(data);
		        updateTableWithData(data), // 테이블 데이터 수정 함수
		        updatePagination(data); // 페이지 네비게이션 데이터 수정 함수
			},
			error: function(){
				console.log(data);
			}
		});
	}
	
	// 페이지 이동 함수
	function goToPage(page){
		// 검색 및 페이지 데이터 수정 함수
	  	searchEmpListResults(page);
    } 
	
	// 인사이동 테이블(reshuffleHistoryList) 데이터 수정 함수
	function updateReshuffleHistoryTableWithData(data) {
	    // data는 서버에서 반환된 JSON 데이터
	    // data 값 저장
	    let reshuffleHistoryList = data;
	    
	    // 테이블의 tbody를 선택하고 초기화
	    let tbody = $('#reshuffleHistoryList');
	    tbody.empty();

	    // data의 길이만큼 테이블 행을 추가
	    for (let i = 0; i < reshuffleHistoryList.length; i++) {
	        let rh = reshuffleHistoryList[i];
	        let row = $('<tr>');
	        let dateOnly = rh.createdate.split(" ")[0];
	        row.append($('<td>').text(dateOnly));
	        row.append($('<td>').text(rh.departBeforeNo));
	        row.append($('<td>').text(rh.departNo));
	        row.append($('<td>').text(rh.positionBeforeLevel));
	        row.append($('<td>').text(rh.position));
	        tbody.append(row);
	    }
	};
	
	// 검색 버튼 클릭 이벤트
	$('#searchEmpListBtn').click(function(){
		searchEmpListResults();
	});
	
	// 사원 상세정보 호출
	function selectEmpInfoOne(empNo){
		// 상세 정보 가져오기
        $.ajax({
			url: '/JoinTree/empManage/selectEmpOne',
			type: 'GET',
			data: {empNo: empNo},
			success: function(data){
				
				console.log(data);
				let empInfoOne = data.selectEmpOne;// 사원 상세정보
				let reshuffleHistoryList = data.reshuffleHistoryList; // 인사이동 이력 목록
				
				// 사원 상세정보 값 변수에 저장
				let empNo = empInfoOne.empNo;
				let empName = empInfoOne.empName;
				let empJuminNo = empInfoOne.empJuminNo;
				let empPhone = empInfoOne.empPhone;
				let empAddress = empInfoOne.empAddress;
				let dept = empInfoOne.dept;
				let deptCode = empInfoOne.deptCode;
				let position = empInfoOne.position;
				let positionCode = empInfoOne.positionCode;
				let empExtensionNo = empInfoOne.empExtensionNo;
				let empHireDate = empInfoOne.empHireDate;
				let empLastDate = empInfoOne.empLastDate;
				let active = empInfoOne.active;
				let activeCode = empInfoOne.activeCode;
				let empSaveImgName = empInfoOne.empSaveImgName;
	            
				// 사원 상세정보 값 설정
	            //$('#empImgOne img').attr('src', empInfo.empImage || '기본이미지경로');
	            $('.empNoOne').text(empNo);
				$('.empNameOne').text(empName);
	            $('.empJuminNoOne').text(empJuminNo);
	            $('.empPhoneOne').text(empPhone);
	            $('.empoAddressOne').text(empAddress);
	            $('#deptOne').text(dept);
	            $('#positionOne').text(position);
	            $('#empExtensionNoOne').text(empExtensionNo);
	            $('#empHireDateOne').text(empHireDate);
	        	$('#empActiveOne').text(active);
	        	
	            // 이미지 유무에 따른 분기
	            if (empSaveImgName) {
                 	//$('#empImgOne img').attr('src', empInfo.empSaveImgName);
	            	$('.empImgOne').text('사진 정보 있음');
	             } else {
	                 // 이미지가 없는 경우 처리
	                 //$('#empImgOne img').attr('src', '#');
	                 $('.empImgOne').text('사진 정보 없음');
	             }
		            
		            // 퇴사일 분기
		            if (empLastDate) {
	                 $('#empLastDateOne').text(empLastDate);
	             } else {
	                 $('#empLastDateOne').text('퇴사일 정보 없음');
	             }
	            
	 	        // 사원 정보 수정 input 요소에 값 설정
			    $('input[name="empNoOne"]').val(empNo);
	 	 	    $('input[name="empExtensionNo"]').val(empExtensionNo);
			    $('input[name="empHireDate"]').val(empHireDate);
			    $('input[name="empLastDate"]').val(empLastDate);
			    $('input[name="departBeforeNo"]').val(deptCode);
			    $('input[name="positionBeforeLevel"]').val(positionCode);
				
			    // 사원 정보로 값 selected		 	      
			    $('#modifyDept option[value="' + deptCode + '"]').prop('selected', true);
			    $('#modifyPosition option[value="' + positionCode + '"]').prop('selected', true);
			    $('#modifyEmpAtive option[value="' + activeCode + '"]').prop('selected', true);
			 	
			    // 인사이동이력 값 저장
			    updateReshuffleHistoryTableWithData(reshuffleHistoryList); 
			    
			    // 직원 활성화에 따른 수정버튼 분기
		        if (active === '퇴직'){
		            $('#modifyEmpBtn').hide(); // 퇴직 상태일 때 버튼 숨김
		        } else {
		            $('#modifyEmpBtn').show();  // 재직 또는 다른 상태일 때 버튼 활성화
		        }
	    	},
			error: function(){
				console.log("잘못된 요청입니다");
			}
		});
	}
	
	// 사원 상세정보, 수정폼 관리
 	let modifyFormMode = false; // 수정폼 실행 상태 변수
 	
 	// 사원 상세정보로 초기화
 	function resetEmpOne(){
 		$('#empOneInfoModalContent').show();
        $('#modifyEmpFormModalContent').hide();
        modifyFormMode = false;
 	}
	
 	// 수정버튼(modifyEmpBtn) click
 	$('#modifyEmpBtn').click(function(){
 		$('#modifyEmpFormModalContent').show();
 		$('#empOneInfoModalContent').hide();
 		modifyFormMode = true;
 	});
 	
 	// 모달창(사원수정) 닫을 때
 	$('#empOneModalClose').click(function(){
 		// 사원 상세정보 초기화
 		resetEmpOne();
 	});
 	
 	// 사원상서젱보, 인사이동이력 탭 이동
    $(".tablink").click(function(evt) {
      var empInfoOne = $(this).data("target");
      var x = $(".empOne");
      var tablinks = $(".tablink");
      x.hide();
      tablinks.removeClass("w3-light-grey");
      $("#" + empInfoOne).show();
      $(this).addClass("w3-light-grey");
    });
 	
	// 사원 상제정보, 수정폼 
	$('#empInfoList').on('click', 'tr', function(){
		resetEmpOne(); // 사원 상세정보 초기화
		let empNo = $(this).find('td:eq(0)').text();// empNo의 값이 들어있는 첫 번째 열의 값을 가져온다
		selectEmpInfoOne(empNo); // 사원 상세정보 호출
		$('#empOneModal').modal('show'); // 모달창 열기
    	$(".tablink").eq(0).click();
	});
	
	// 사원정보 수정확인 버튼(modifyEmpConfirmBtn) click
   	$('#modifyEmpConfirmBtn').on('click', function(){
   		
   		// 내선번호 공백, 유효성 검사
   		if (checkEmptyAndAlert($('#modifyEmpExtensionNo').val(), '내선번호를 입력해주세요', '#modifyEmpExtensionNo')) return; // 내선번호
   		
   		let empExtensionNo = $('#modifyEmpExtensionNo').val();
		if(!isValidEmpExtensionNo(empExtensionNo)){
			alert('유효하지 않은 내선번호입니다');
			$('#modifyEmpExtensionNo').focus();
			return;
		}
   		
   		// 카테고리별 이름 값 저장 변수
   		let deptCategory = $('#modifyDept option:selected').text();
   		let positionCategory = $('#modifyPosition option:selected').text();
   		let activeCategory = $('#modifyEmpAtive option:selected').text();
   		
   		// 수정할 사원 정보, 인사이동 이력 정보(이전부서, 이전직급)
   		let modifyEmpOne = {
   			empNo: $('#modifyEmpNo').val(),
   			dept: $('#modifyDept').val(),
   			position: $('#modifyPosition').val(),
   			active: $('#modifyEmpAtive').val(),
   			empExtensionNo: $('#modifyEmpExtensionNo').val(),
   			empHireDate: $('#modifyEmpHireDate').val(),
   			empLastDate: $('#modifyEmpLastDate').val(),
   			departBeforeNo: $('#departBeforeNo').val(),
   			positionBeforeLevel: $('#positionBeforeLevel').val()
   		}
    		
   		$.ajax({
   			url: '/JoinTree/empManage/modifyEmp',
   			type: 'POST',
   			contentType: 'application/json',
   			dataType: 'json',
   			data: JSON.stringify(modifyEmpOne),
   			success: function(data){
   				console.log(data + "<-- modifyEmpOne data");
   				let activeResult = data.modifyActiveResult;
   				let empInfoResult = data.modifyEmpInfoResult;
   				
   				if(activeResult == 1 || empInfoResult == 1){
   					alert('사원 정보 수정 성공');
   					
   					// 모달창 회원상세정보 수정된 내용 업데이트
   					$('#deptOne').text(deptCategory);
	 	            $('#positionOne').text(positionCategory);
	 	            $('#empExtensionNoOne').text(modifyEmpOne.empExtensionNo);
	 	            $('#empHireDateOne').text(modifyEmpOne.empHireDate);
	 	        	$('#empActiveOne').text(activeCategory);
   					
   					// 모달 창 내용 변경 후, 수정 폼을 숨기고 상세 정보를 보이게 설정
   		            $('#modifyEmpFormModalContent').hide();
   		            $('#empOneInfoModalContent').show();
   		         	
   				} 
   			},
   			error: function(){
   				console.log(data + "<-- modifyEmpOne error data");
   			}
   		});
   	});
	
 	// 수정취소 버튼(modifyEmpCancelBtn) click
 	$('#modifyEmpCancelBtn').click(function(){
 		// 수정 폼을 숨기고 상세 정보를 보이게 설정
        $('#modifyEmpFormModalContent').hide();
        $('#empOneInfoModalContent').show();
 	});
	 	
</script>
</html>