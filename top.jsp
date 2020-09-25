<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%    
	String path = request.getContextPath();    
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";    
	pageContext.setAttribute("basePath", basePath);    
%> 
<title>top</title>
<link href="css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
</head>

<body style="background:url(images/topbj.jpg) no-repeat top left #3a94c8;">

<!-- <div class="topleft"> <a href="main.html" target="_parent"><img src="images/logo.png" title="系统首页" /></a> </div>-->
<div class="topleft"> <img src="images/logo.png" title="系统首页" /></div>
</body>
</html>
