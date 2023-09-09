<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<style>

 .container {
     max-height: 1000px; /*최대 높이 */
     overflow-y: auto; /*스크롤 자동 표시 */
 }
.detail-label {
    display: inline-block;
    width: 120px;
    font-weight: bold;
    vertical-align: top;
    padding-right: 10px;
}

.detail-value {
    display: inline-block;
    max-width: calc(100% - 130px);
    word-wrap: break-word; /* 줄바꿈 */
    vertical-align: top;
}
.room-details {
    margin-top: 20px;

}
.room-details div {
    display: block;
    margin-bottom: 12px;
}
.btn-fw{
float:right;
margin-top: 56px;
}
.img-responsive {
    max-width: 100%;
}

</style>
<!-- header -->
<!-- body, title 삭제 -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
<div class="container-fluid page-body-wrapper">
<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
		
		<div class="card">
			<br><br>
				<div class="container">
				<h2 style="font-family: 'Pretendard-Regular';"><span class="mdi mdi-format-list-bulleted-type"></span> 회의실 목록</h2>
				<div class="line"></div>
				    <div class="row margin-top20">
				        <c:forEach var="m" items="${meetRoomList}">
				            <c:if test="${m.roomStatus == 1}"> <!-- 사용 가능 상태인 회의실만 표시 -->
				                <div class="col-md-12 mb-4">
				                    <div class="meeting-room-item">
				                        <div class="row">
				                            <div class="col-md-6">
				                                <c:if test="${not empty m.roomSaveFilename}">
				                                    <img src="${pageContext.request.contextPath}/roomImg/${m.roomSaveFilename}" alt="${m.roomName} 이미지" id="imgsize" width="500" height="300"  class="img-responsive">
				                                </c:if>
				                            </div>
				                            <div class="col-md-6">
				                                <h2>${m.roomName}</h2>
											<div class="room-details">
		                                    <div>
		                                        <span class="detail-label">공간유형</span>
		                                        <span class="detail-value">회의실</span>
		                                    </div>
		                                    <div>
		                                        <span class="detail-label">수용인원</span>
		                                        <span class="detail-value">${m.roomCapacity}명</span>
		                                    </div>
		                                    <div>
		                                        <span class="detail-label">예약 가능 시간</span>
		                                        <span class="detail-value">평일 : 9시~18시 <br>( 그 외 시간은 별도의 예약 없이 사용가능합니다. ) <br>* 정각이 되기 전 미리 예약해주세요.</span>
		                                    </div>
		                                	</div>             
				                                 <a href="/JoinTree/reservation/meetRoomReserv?roomNo=${m.roomNo}&roomName=${m.roomName}" class="btn btn-success btn-fw">예약하기</a>		                                
				                            </div>
				                        </div>
				                    </div>
				                </div>
				            </c:if>
				        </c:forEach>
				    </div>
				</div>
			<br><br>
		</div>
	<!-- 컨텐츠 끝 -->
		</div>
	</div><!-- 컨텐츠전체 끝 -->
<!-- footer -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>