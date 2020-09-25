<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%    
	String path = request.getContextPath();    
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";    
	pageContext.setAttribute("basePath", basePath);    
%> 
<title></title>
<link href="css/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
</head>

<body style="overflow:auto;">
	<div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li>欢迎页面</li>
    </ul>
    </div>
    
    <div class="mainindex hybj">
    <div class="welinfo">
    <span><img src="images/sun.png" alt="天气" /></span>
    <b>${SESSION_USERNAME}你好，欢迎使用苏州工业园区社会信用信息平台</b>
    </div>
    <!-- 
    <div class="welinfo">
    <span><img src="images/time.png" alt="时间" /></span>
    
    <i>您上次登录的时间：2013-10-09 15:22</i> （不是您登录的？<a href="#">请点这里</a>）
     
    </div>    
    -->
    </div>
</body>
</html>