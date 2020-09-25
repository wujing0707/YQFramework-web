<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<title>访问页面不存在</title>
</head>

<body>
<div>
	<h1><span>Page Not Found</span></h1>
	<div align="center"><img alt="system internal error" src="../../images/404.png" /></div>
	<div align="center"><a href="<c:url value="../../system/user/login.action"/>">go back to home</a></div>
</div>
</body>
</html>