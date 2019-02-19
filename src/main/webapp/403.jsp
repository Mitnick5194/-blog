<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width , initial-scale=1">
<title>拒绝访问</title>

<style type="text/css">
.notify{
    margin-top: 120px;
    font-weight: 600;
    height: 100%;
    font-size: 20px;
    text-align: center;
}

.qrcode-dv{
	text-align: center;
	margin-top: 20px;
}
</style>
</head>
<body>
	<div class="notify">抱歉，权限不足，如需继续访问，<br>请联系管理员！</div>
	<div class="qrcode-dv"><img src="${ pageContext.request.contextPath }/images/my_qr_code.jpg" width="200px"/></div>
</body>
</html>