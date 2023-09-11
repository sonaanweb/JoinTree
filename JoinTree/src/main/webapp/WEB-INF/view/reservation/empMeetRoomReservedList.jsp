<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<style>
</style>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
<div class="container-fluid page-body-wrapper">
<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->

<div class="row">
	<div class="col-lg-12 grid-margin stretch-card">
		<div class="card">
			<div class="card-body">

				<div>
		            <label class="adminsearch">예약일시</label>
					<input type="date" name="revStartTime" id="revStartTime"> ~ <input type="date" name="revEndTime" id="revEndTime">
		            <button id="searchButton" class="btn btn-success btn-sm margin10">검색</button>
		        </div>
		        
			</div>
		</div>
	</div>
</div>    

<div class="row">
	<div class="col-lg-12 grid-margin stretch-card">
		<div class="card">
			<div class="card-body">
		        <table class="table">
		            <thead>
		                <tr>
		                    <td>예약번호</td>
		                    <td>회의실 이름</td>
		                    <td>예약 시간</td>
		                    <td>예약 내용</td>
		                    <td>예약 신청일</td>
		                    <td>상태</td>
		                    <td></td>
		                </tr>
		            </thead>
		            <tbody id="reservationbody">
		                <c:forEach var="r" items="${empMeetReserved}">
		                    <tr>
		                        <td>${r.revNo}</td>
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
		                        <!-- 예약 완료인 상태에만 취소 버튼 활성화 / 사용완료 상태는 취소 버튼 X-->
		                        <c:choose>
		                            <c:when test="${r.revStatus == 'A0301'}">
		                                <td><button class="btn btn-success btn-sm cancel-btn" data-revno="${r.revNo}">예약취소</button></td>
		                            </c:when>
		                            <c:otherwise>
		                                <td></td>
		                            </c:otherwise>
		                        </c:choose>
		                    </tr>
		                </c:forEach>
		            </tbody>
		        </table>
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
	<script src="/JoinTree/resource/js/reservation/empMeetRoomReservedList.js"></script>
</html>
