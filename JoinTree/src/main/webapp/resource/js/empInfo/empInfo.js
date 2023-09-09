$(document).ready(function() {
	const urlParams = new URL(location.href).searchParams;
	const msg = urlParams.get("msg");
	if (msg != null) {
		Swal.fire({
			icon: 'success',
			title: msg,
			showConfirmButton: false,
			timer: 1000
		});
	}
	
	// 쿼리 매개변수 "msg"를 제거하고 URL을 업데이트 (새로고침 시 메시지 알림창 출력하지 않음)
    urlParams.delete("msg");
    const newUrl = `${location.pathname}?${urlParams.toString()}`;
    history.replaceState({}, document.title, newUrl);
});