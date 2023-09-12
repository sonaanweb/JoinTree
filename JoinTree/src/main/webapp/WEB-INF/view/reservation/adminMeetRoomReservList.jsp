<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
<div class="container-fluid page-body-wrapper">
<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
	    
	<h4>경영지원팀 예약관리</h4>
	
	<!-- 검색 -->
<div class="row">
	<div class="col-lg-12 grid-margin stretch-card">
		<div class="card">
			<div class="card-body">
			
				<div>
		            <label class="adminsearch">예약일시</label>
		            <input type="date" name="revStartTime"> ~ <input type="date" name="revEndTime">
		        </div>
		        <div class="wrapper">
		        <label class="adminsearch col-form-label">예약상태</label>
		        <div class="form-check form-check-success">
		        	<label class="form-check-label">
		            <input type="radio" name="revStatus" value=""> 전체
		            </label>
		       	</div>
		       	<div class="form-check form-check-success margin-left10">
		            <label class="form-check-label">
		            <input type="radio" name="revStatus" value="A0301"> 예약완료
		            </label>
		        </div>
		        <div class="form-check form-check-success margin-left10">
		            <label class="form-check-label">
		            <input type="radio" name="revStatus" value="A0302"> 예약취소
		            </label>
		        </div>
		        <div class="form-check form-check-success margin-left10">
		            <label class="form-check-label">
		            <input type="radio" name="revStatus" value="A0303"> 사용완료
		            </label>
		        </div>
		        </div>
		        <div class="wrapper">
		        	<label class="adminsearch">예약자</label>
		        	<input type="text" name="empName" placeholder="예약자 성명을 입력해주세요" class="form-control" style="width: 20%; margin-right: 10px;" >
		        	<button id="searchButton" class="btn btn-success btn-sm">검색</button>
		        </div>
		        
			</div>
		</div>
	</div>
</div>
	<!-- -- -->
	
 <div class="row">
	<div class="col-lg-12 grid-margin stretch-card">
		<div class="card">
			<div class="card-body">
			
		        <table class="table">
		            <thead>
		                <tr>
		                    <td>예약번호</td>
		                    <td>예약자</td>
		                    <td>회의실 이름</td>
		                    <td>예약일시</td>
		                    <td>예약 내용</td>
		                    <td>예약 신청일</td>
		                    <td>상태</td>
		                    <td>최종수정자</td>
		                    <td></td>
		                </tr>
		            </thead>
		            <tbody id="reservationbody">
		                <c:forEach var="r" items="${empAllMeetReserved}">
		                    <tr>
		                        <td>${r.revNo}</td>
		                        <td>${r.empName}(${r.empNo})</td>
		                        <td>${r.roomName}</td>
		                        <td>${r.revStartTime.toString().substring(0, 10)}  ${r.revStartTime.toString().substring(11, 16)}
		                         ~ ${r.revEndTime.toString().substring(11, 16)}</td>
		                        <td>${r.revReason}</td>
		                        <td>${r.createdate.substring(0,10)}</td>
		                        <td>
		                            <c:choose>
		                                <c:when test="${r.revStatus == 'A0301'}">
		                                <span class="badge badge-success">예약완료</span>
		                                </c:when>
		                                <c:when test="${r.revStatus == 'A0302'}">
		                                <span class="badge badge-secondary">예약취소</span>
		                                </c:when>
		                                <c:when test="${r.revStatus == 'A0303'}">
		                                <span class="badge badge-dark">사용완료</span>
		                                </c:when>
		                            </c:choose>
		                        </td>
		                        <td>${r.updateName}(${r.updateId})</td>
		                        <!-- 예약 완료인 상태에만 취소 버튼 활성화 / 사용완료 상태는 취소 버튼 X-->
		                        <c:choose>
		                            <c:when test="${r.revStatus == 'A0301'}">
		                                <td><button class="btn btn-success btn-sm cancel-btn" data-revno="${r.revNo}">취소</button></td>
		                            </c:when>
		                            <c:otherwise>
		                                <td></td>
		                            </c:otherwise>
		                        </c:choose>
		                    </tr>
		                </c:forEach>
		            </tbody>
		        </table>
			        		<!-- <div class="center pagination" id="paging">
							페이징 버튼이 표시되는 부분
							</div> -->
			</div>
		</div>
	</div>
</div>
	    <!-- 컨텐츠 끝 -->
</div>
</div>
<!-- 컨텐츠전체 끝 -->
<!-- footer -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	<div id="empNo" data-empno="${loginAccount.empNo}"></div>
	<div id="empName" data-empname="${sessionScope.empName}"></div>
	<script src="/JoinTree/resource/js/reservation/adminMeetRoomReservList.js"></script>
</html>