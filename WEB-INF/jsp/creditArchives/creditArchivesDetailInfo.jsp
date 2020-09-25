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
<title>信用档案企业详情查询</title>
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
.clear{height:20px}
/*td {white-space:nowrap; text-overflow:ellipsis; -o-text-overflow:ellipsis; overflow:hidden;}*/
</style>
</head>
<body style="overflow:auto;">
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li>信用档案查询</li>
			<li>企业信用档案详细</li>
		</ul>
	</div>
	<div class="rightinfo">
	
	<font style="font-size:20px;font-weight:800;">一、企业标识信息</font><br /><br />
		<table cellspacing="0" cellpadding="0" class="tablelist tablelist0" id="">
			<tbody>
				<tr>
					<th colspan="10" style="text-align: center;">　　　　　　　　　　　　　
					<c:forEach items="${baseInfo.企业名称}">基本信息
					<a href="#" style="float:right"
					class="easyui-linkbutton" iconCls="icon-print"
					onclick="exportpdf();">导出pdf报告</a>
					</c:forEach>
					</th>
				</tr>
				<tr>
					<th width = "10%">企业名称</th>
					<td colspan="3" title="${baseInfo.企业名称}">${baseInfo.企业名称}</td>
					<th width = "10%">组织机构代码</th>
					<td width = "10%" title="${baseInfo.组织机构代码}">${baseInfo.组织机构代码}</td>
					<th width = "10%">工商注册号</th>
					<td width = "10%" title="${baseInfo.企业注册号}">${baseInfo.企业注册号}</td>
					<th width = "10%">纳税人识别号</th>
					<td width = "10%" title="${baseInfo.纳税人标识号}">${baseInfo.纳税人标识号}</td>
				</tr>
			</tbody>
		</table>

		<div id="usual1" class="usual mt10">
		
	<c:forEach items="${allList}" var="info" varStatus="status">
			<font style="font-size:20px;font-weight:800;">
			<c:if test="${status.index + 2 == 2}">二</c:if>
			<c:if test="${status.index + 2 == 3}">三</c:if>
			<c:if test="${status.index + 2 == 4}">四</c:if>
			<c:if test="${status.index + 2 == 5}">五</c:if>
			<c:if test="${status.index + 2 == 6}">六</c:if>
			<c:if test="${status.index + 2 == 7}">七</c:if>
			<c:if test="${status.index + 2 == 8}">八</c:if>
			<c:if test="${status.index + 2 == 9}">九</c:if>
			、${info.name}</font><br /><br />
		<c:choose>
			<c:when test="${empty info.list}">
				暂无授权！<br/><br/>
			</c:when>
			<c:otherwise>
				<c:forEach items="${info.list}" var="deptInfo" varStatus="status2">
				<font style="font-size:18px;font-weight:700;">${deptInfo.deptName}-${deptInfo.tableName}</font><br />
				<table bordercolor="black" class="tablelist tablelist0" border="1" cellspacing="0" style="table-layout:fixed;word-break:break-all word-wrap:break-word;width:100%;text-align:center;margin:0  auto;font-size:14px">
				<tbody>
				<%-- <tr>
				    <th  colspan="${fn:length(deptInfo.columnName) }" style="text-align:center">${deptInfo.tableName}</th>
				</tr> --%>			
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
		<form id="tablexx" name="tablexx" method="post" action="<%=basePath%>creditArchives/exportCreditArchivesInfoPdf.action">
		<input type="hidden" name="zzjgdm" id="zzjgdm" value="${baseInfo.组织机构代码}">
		<input type="hidden" name="qymc" id="qymc" value="${baseInfo.企业名称}">
		<input type="hidden" name="gszch" id="gszch" value="${baseInfo.企业注册号}">
		<input type="hidden" name="nsrbsh" id="nsrbsh" value="${baseInfo.纳税人标识号}">
		</form>
		<script type="text/javascript">
		$("#usual1 ul").idTabs();
		function exportpdf(){
			$('#tablexx').submit();
		}			
		</script>
	</div>
</body>
</html>