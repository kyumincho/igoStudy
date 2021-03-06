<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
	<title>Insert title here</title>
<%@ include file="../include/header.jsp" %>
<script src="${path}/include/js/common.js"></script>
<script src="${path}/ckeditor/ckeditor.js"></script>
<script type="text/javascript">
$(function(){
	$("#btnSave").click(function(){
		document.form1.submit();
	});
	// 드래그 기본효과 막음
	$(".fileDrop").on("dragenter dragover", function(e) {
		e.preventDefault();
	})
	$(".fileDrop").on("drop", function(e){
		e.preventDefault();
		// 드롭한 파일을 폼데이터에 추가함
		var files = e.originalEvent.dataTransfer.files;
		var file = files[0];
		var formData = new FormData();
		// 폼데이터에 추가
		formData.append("file", file);
		// processData: false - header가 아닌 body로 전송
		$.ajax({
			url: "${path}/upload/uploadAjax",
			data: formData,
			dataType: "text",
			processData: false,
			contentType: false,
			type: "post",
			success: function(data){ // 콜백함수
				var fileInfo = getFileInfo(data); // 첨부파일 정보
				var html = "<a href='" + fileInfo.getLink + "'>" + fileInfo.fileName + "</a><br>"; // 첨부파일 링크
				html += "<input type='hidden' name='files' value='" + fileInfo.fullName + "'>"; // hidden 태그 추가
				$("#uploadedList").append(html); // div에 추가
			}
		});
	});
	// 첨부파일 삭제
	$("#uploadedList").on("click", ".file_del", function(e){
		var that = $(this);
		$.ajax({
			type: "post",
			url: "${path}/upload/deleteFile",
			data: {fileName:$(this).attr("data-src")},
			dataType: "text",
			success: function(result){
				if(result == "deleted"){
					that.parent("div").remove();
				}
			}
		});
	});
});
</script>
<style type="text/css">
.fileDrop {
	width: 600px;
	height: 100px;
	border: 1px dotted gray;
	background-color: gray;
}
</style>
</head>
<body>
<%@ include file="../include/menu.jsp" %>
<h2>글쓰기</h2>
<form id="form1" name="form1" method="post" action="${path}/board/insert.do">
<div>
	제목 <input name="title" id="title" size="80" placeholder="제목을 입력하세요.">
</div>
<div style="width:800px;">
	내용 <textarea id="content" name="content" rows="3" cols="80" placeholder="내용을 입력하세요."></textarea>
</div>
<script type="text/javascript">
CKEDITOR.replace("content", {
	filebrowserUploadUrl: "${path}/imageUpload.do",
	height: "500px"
});
</script>
<div>
	첨부파일을 등록하세요.
	<div class="fileDrop"></div>
	<div id="uploadedList"></div>
</div>
<div style="width:700px; text-align: center">
	<button type="button" id="btnSave">확인</button>
</div>
</form>
</body>
</html>