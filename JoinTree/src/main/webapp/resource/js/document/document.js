/*문서 폼 확인 및 날짜출력*/
$(document).ready(function() {
	const today = new Date();
	const year = today.getFullYear();
	const month = String(today.getMonth() + 1).padStart(2, '0'); // 0부터 시작하므로 1을 더해준다
	const day = String(today.getDate()).padStart(2, '0');
	const formattedDate = year + "-" + month + "-" + day;
	
	$("#draftDate").val(formattedDate); // 오늘날짜 출력

	$('#docOriginFilename').on("change", function() {
		const selectedFile = event.target.files[0];
		console.log("selectedFile", selectedFile);
	
		if (selectedFile) {
			const allowedFormats = ['jpg', 'jpeg', 'png', 'zip', 'pdf'];
			const fileExtension = selectedFile.name.slice(selectedFile.name.lastIndexOf('.') + 1).toLowerCase();
			console.log("파일 들어옴",fileExtension);
		
			if (allowedFormats.includes(fileExtension)) {
				console.log("파일 정상");
			} else {
				$('#docOriginFilename').val('');
				Swal.fire(
					'Error',
					'jpg, jpeg, png, zip, pdf만 업로드 할 수 있습니다.',
					'error'
				);
			}
		}
	});
});