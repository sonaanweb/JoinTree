<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectEmpList</title>
<style>
	/* 모달 */
	.modal {
		display: none;
		position: fixed;
		z-index: 1;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
		overflow: auto;
		background-color: rgba(0, 0, 0, 0.4);
	}
	
	.modal-content {
		background-color: #fefefe;
		margin: 15% auto;
		padding: 20px;
		border: 1px solid #888;
		width: 30%;
	}
	.modal-header {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	}
	
	.modal-header h4 {
	    margin: 0;
	}
	
	.close {
	    font-size: 28px;
	    font-weight: bold;
	    cursor: pointer;
	}
	
	/* 정렬 */	
	.text-center{
		display: flex;
    	justify-content: center;
	}
</style>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script>

</script>
<body>
	<div>
		<button type="button" id="addEmpModalBtn"> 사원등록</button>
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
				<select id="searchActiveCategory" name="active">
					<option id="searchActive" value=null>선택하세요</option>
					<c:forEach var="a" items="${activeCodeList}">
						<option id="searchActive" value="${a.code}">${a.codeName}</option>
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
				<select id="searchDeptCategory" name="dept">
					<option id="searchDept" value=null>선택하세요</option>
					<c:forEach var="d" items="${deptCodeList}">
						<option id="searchDept" value="${d.code}">${d.codeName}</option>
					</c:forEach>
				</select>
			</div>
			<div>
				<div>직급</div>
				<select id="searchPositionCategory" name="position">
					<option id="searchPosition" value=null>선택하세요</option>
					<c:forEach var="p" items="${positionCodeList}">
						<option id="searchPosition" value="${p.code}">${p.codeName}</option>
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
		<tbody id="tableBody">
		
		</tbody>
	</table>
	
	<!-- 사원등록 모달창 -->
	<div id="addEmpModal" class="modal">
		<div class="modal-content">
			<div class="modal-header">
				<h4>사원 등록</h4>
				<span class="close">&times;</span>
			</div>
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
							<input type="text" name="zip" id="sample6_postcode" placeholder="우편번호">
						</div>
						<div>
							<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기" class="btn btn-primary">
						</div>
						<div>
							<input type="text" name="add1" id="sample6_address" placeholder="주소" class="form-control">
							<input type="text" name="add2" id="sample6_detailAddress" placeholder="상세주소" class="form-control">
							<input type="text" name="add3" id="sample6_extraAddress" placeholder="참고항목" class="form-control">
						</div>
					</div>
					<div>
						<div>부서</div>
						<select id="deptCategory" name="dept">
							<c:forEach var="d" items="${deptCodeList}">
								<option id="dept" value="${d.code}">${d.codeName}</option>
							</c:forEach>
						</select>
					</div>
					<div>
						<div>직급</div>
						<select id="positionCategory" name="position">
							<c:forEach var="p" items="${positionCodeList}">
								<option id="position" value="${p.code}">${p.codeName}</option>
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
</body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	
	
	// 사원 등록 모달 창 열기
	$('#addEmpModalBtn').click(function () {
		$('#addEmpModal').css('display', 'block');
	});
	
	// 모달 창 닫기
	$('.close').click(function () {
		$('#addEmpModal').css('display', 'none');
	});
	
	// addEmpBtn click
	$('#addEmpBtn').on('click', function(){
		
		
		// 값 유효성 검사 후 signUpAction.jsp 이동
	    let addEmpUrl = '/empManage/addEmp';
		$('#addEmpForm').attr('action', addEmpUrl);
	    $('#addEmpForm').submit();
	});
	
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
	
	
	 //검색 조건별 사원 목록 출력
	 // 페이지 로드 될 때 자동 초기 검색
	 $(document).ready(function(){
	     // 초기 검색 조건 설정
	     let searchEmpList = {
	         empNo: null,
	         empName: null,
	         active: null,
	         startEmpHireDate: null,
	         endEmpHireDate: null,
	         dept: null,
	         position: null
	     };
	 
     // 초기 검색 실행
     searchEmpListResults(searchEmpList);
     
 	 // 검색 폼 제출 이벤트
		$('#searchEmpListBtn').click(function(){
			
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
			
			// 페이징 설정
			
			// Ajax 요청 함수 호출
			searchEmpListResults(searchEmpList);
		});
		
		// Ajax 요청 및 처리 함수
		function searchEmpListResults(searchEmpList){
			$.ajax({
				url: '/empManage/searchEmpList',
				method: 'GET',
				data: {
					// 검색조건 객체를 JSON으로 변환
					searchEmpList: JSON.stringify(searchEmpList)
				},
				success: function(data){
					 alert(JSON.stringify(data));
					// 데이터를 테이블에 적용하는 로직
			        updateTableWithData(data);
				},
				error: function(){
					
				}
			});
		}
		
		function updateTableWithData(data) {
		    // data는 서버에서 반환된 JSON 데이터
		    // 테이블의 tbody를 선택하고 초기화
		    let tbody = $('#tableBody');
		    tbody.empty();
	
		    // data의 길이만큼 테이블 행을 추가
		    for (let i = 0; i < data.length; i++) {
		        let emp = data[i];
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
	
 	});
	
	
</script>
</html>