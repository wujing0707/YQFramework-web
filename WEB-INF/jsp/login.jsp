<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title>苏州工业园区社会信用信息平台</title>
	<link href="<%=basePath%>/css/common.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="<%=basePath%>js/base.js"></script>
	<script type="text/javascript">
	if(top!=this){
		window.top.location.href = "<%=basePath%>system/user/toLogin.action";
	}
	function EnterPress(e){ //传入 event
		var e = e || window.event || arguments.callee.caller.arguments[0];
		if(e.keyCode == 13){
			$('#loginForm').submit();
		}
	} 
</script>
</head>
<body id="loginFrame">
<div id="header">
  <div id="logo"><a title="登录" href="#"></a></div>
</div>
<div id="loginBox">
  <div id="loginBoxHeader"></div>
  <div id="loginBoxBody">
  <form action="<%=basePath%>system/user/login.action" method="post" id="loginForm">
    <ul class="floatLeft">
      <li>
        <h4>管理员登录</h4>
         </li>
        <li style="margin-left:90px;color:orange;"><c:out value="${message}"/></li>
        <li>
          <label>用户名：</label>
          <input  class="textinput"  type="text"  name="username"  size="30" maxlength="2048"/>
        </li>
        <li>
          <label>密码：</label>
          <input type="hidden" name="tag" value="login"/>
          <input name="password" type="password" class="textinput" size="30" maxlength="2048"/>
          </li>
        <li>
          <label>验证码：</label>
          <input  class="textinput"  style="width:100px" name="verCode" type=""  style="width:130px;" title="" value="" size="10" maxlength="2048" onkeypress="EnterPress(event)"  onkeydown="EnterPress()" />
          <img style="float: left; cursor: pointer; margin-left:10px" title="点击换图片" src="<%=basePath%>/verCode.jsp" onclick="this.src='<%=basePath%>/verCode.jsp?d='+new Date()" alt="验证码" height="30" width="80"/>
          </li>
        <li class="highlight">
          <label>&nbsp;</label>
          <input id="loginBtn" onclick="loginForm.submit();" value="登录" type="submit"/>
     	</li>
    </ul>
    <div class="floatRight">建议：操作系统 Windows 7 以上版本，浏览器要求 IE9及以上版本，分辨率建议：1024*768及以上  </div>
    <br clear="all"/>
      </form>
  </div>
  <div id="loginBoxFooter"></div>
  </div>
<div id="footer"> © 江苏中集科技有限公司</div>
</body>
</html>