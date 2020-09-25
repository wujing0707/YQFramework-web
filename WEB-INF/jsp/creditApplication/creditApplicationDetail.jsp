<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String tip=(String)request.getAttribute("tip");
	if("NoThisEnterprise".equals(tip)){
		out.println("<script type='text/javascript'>alert('没有该企业的基本信息')</script>");
	}
	if("NoNull".equals(tip)){
		out.println("<script type='text/javascript'>alert('至少输入一查询条件')</script>");
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/commonCheck.js"></script>
<link href="${pageContext.request.contextPath}/css/creditstyle.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.idTabs.min.js"></script>
<title>信用联动查询详情</title>
<script type="text/javascript">
	
</script>
<style type="text/css">
#fm {
	margin: 0;
	padding: 10px 30px;
}

.ftitle {
	font-size: 14px;
	font-weight: bold;
	padding: 5px 0;
	margin-bottom: 10px;
	border-bottom: 1px solid #ccc;
}

.fitem {
	margin-bottom: 5px;
}

.fitem label {
	display: inline-block;
	width: 80px;
}

.fitem input {
	width: 160px;
}
</style>
</head>
<body style="overflow:auto;">
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li>信用联动应用</li>
			<li>企业信用详细</li>
		</ul>
	</div>
	<div class="rightinfo">
		<font style="font-size:20px;font-weight:800;">一、基本信息</font><br /><br />
		<table cellspacing="0" cellpadding="0" class="tablelist tablelist0" style="width:95%" id="">
				
			<tbody>
				
				<tr>
					<th width = "25%" style="text-align: center">企业名称</th>
					<th width = "25%" style="text-align: center">组织机构代码</th>
					<th width = "25%" style="text-align: center">企业注册号</th>
					<th width = "25%" style="text-align: center">纳税人标识号</th>
					
				</tr>
				<tr>
					<td >${baseInfo.企业名称}</td>
					<td >${baseInfo.组织机构代码}</td>
					<td >${baseInfo.企业注册号}</td>
					<td >${baseInfo.纳税人标识号}</td>
				</tr>
			</tbody>
		</table>

		<c:forEach items="${allList}" var="info" varStatus="status">
			<font style="font-size:20px;font-weight:800;">
			<c:if test="${status.index + 2 == 2}">二</c:if>
			<c:if test="${status.index + 2 == 3}">三</c:if>
			、${info.name}</font><br /><br />
		<c:choose>
			<c:when test="${empty info.list}">
				暂无信息！<br/><br/>
			</c:when>
			<c:otherwise>
				<c:forEach items="${info.list}" var="deptInfo" varStatus="status2">
				<font style="font-size:18px;font-weight:700;">${deptInfo.deptName}-${deptInfo.tableName}</font><br />
				<table bordercolor="black" class="tablelist tablelist0" border="1" cellspacing="0" style="table-layout:fixed;word-break:break-all word-wrap:break-word;width:100%;text-align:center;margin:0  auto;font-size:14px">
				<tbody>
				<tr >
				<c:forEach items="${deptInfo.columnName}" var="titleInfo" varStatus="status3">
					<th width="auto" style="text-align: center">${titleInfo}</th>
				</c:forEach>																
				</tr>
				<c:choose>
					<c:when test="${empty deptInfo.columnVal}">
					<tr>
					<td colspan="${fn:length(deptInfo.columnName) }" style="word-wrap:break-word;">暂无信息！</td>
					</tr>
					</c:when>
					<c:otherwise>
			<c:forEach items="${deptInfo.columnVal}" var="value" varStatus="status3">
			<tr>
				<c:forEach items="${value}" var="var" varStatus="status">
					<td title="${var}">${var}</td>
				</c:forEach>
			</tr>
			</c:forEach>
					</c:otherwise>
				</c:choose>
				</tbody>
				</table>
			    </c:forEach>
			</c:otherwise>
		</c:choose>
	</c:forEach>

	</div>
</body>
</html>