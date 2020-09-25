<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
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
<title>信用核查</title>
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

	<div class="rightinfo">
		<table cellspacing="0" cellpadding="0" class="tablelist tablelist0"
			id="">
			<tbody>
				<tr>
					<th colspan="10" style="text-align: center;">基本信息
					</th>
				</tr>
				<tr>
					<th width = "5%">姓名</th>
					<td width = "10%">${baseInfo.XM}</td>
					<th width = "10%">身份证号</th>
					<td width = "25%">${baseInfo.SFZH}</td>
					<th width = "10%">注册证书号</th>
					<td width = "20%">${baseInfo.ZCZSH}</td>
					<th width = "10%">执业类别</th>
					<td width = "10%">${baseInfo.ZYLB}</td>
				</tr>
				<tr>
				</tr>
				<tr>
					<th >性别</th>
					<td>${baseInfo.XB}</td>
					<th >执业范围</th>
					<td>${baseInfo.ZYFW}</td>
					<th >执业单位</th>
					<td>${baseInfo.ZYDW}</td>
					<th >资格证书号</th>
					<td>${baseInfo.ZGZSH}</td>
			</tbody>
		</table>

		<div id="usual1" class="usual mt10">

			<%-- <div class="itab">
				<ul>
					<c:forEach items="${allList}" var="info" varStatus="status">
						<li><a href="#tab${status.count}"
							<c:if test='${status.count==1}'> class='selected' </c:if>>${info.name}</a>
						</li>
					</c:forEach>
				</ul>
			</div> --%>

					<%-- <font style="font-size:25px;">一、良好信用信息</font><br />
				<font style="font-size:20px;">1、荣誉表彰信息</font><br />
				<table bordercolor="black" class="tablelist tablelist0" border="1" cellspacing="0" style="table-layout:fixed;word-break:break-all word-wrap:break-word;width:100%;text-align:center;margin:0  auto;font-size:14px">
					<tbody>
						<tr>
							<th width = "15%" style="text-align: center">表彰部门</th>
							<th width = "15%" style="text-align: center">荣誉称号</th>
							<th width = "10%" style="text-align: center">表彰日期</th>
							<th width = "10%" style="text-align: center">批准文号</th>
							<th width = "30%" style="text-align: center">表彰内容</th>							
							<th width = "10%" style="text-align: center">地区</th>
							<th width = "10%" style="text-align: center">年度</th>
						</tr>
						<c:forEach items="${rybzList}" var="rybz" varStatus="status">
						<tr>
							<td>${rybz.BZBM}</td>
							<td>${rybz.RYCH}</td>
							<td>${rybz.BZRQ}</td>
							<td>${rybz.PZWH}</td>
							<td>${rybz.BZNR}</td>														
							<td>${rybz.DQ}</td>
							<td>${rybz.ND}</td>
						</tr>
						</c:forEach>
					 
						
					</tbody>
				</table><br /> --%>


	
	
			<font style="font-size:25px;">一、不良信用信息</font><br />
			<font style="font-size:20px;">1.失信行为信息</font><br />
			<table bordercolor="black" class="tablelist tablelist0" border="1" cellspacing="0" style="table-layout:fixed;word-break:break-all word-wrap:break-word;width:100%;text-align:center;margin:0  auto;font-size:14px">
			<tbody>
				<tr >
					<th width = "10%" style="text-align: center">处罚机关名称</th>
					<th width = "10%" style="text-align: center">处罚名称</th>
					<th width = "10%" style="text-align: center">行政处罚日期</th>
					<th width = "10%" style="text-align: center">处罚决定书文号</th>
					<th width = "15%" style="text-align: center">处罚事由</th>
					<th width = "7%" style="text-align: center">处罚种类</th>
					<th width = "10%" style="text-align: center">行政处罚结论</th>
					<th width = "8%" style="text-align: center">失信等级</th>
				</tr>
				<c:choose>
						<c:when test='${ empty xzcfList }' ><tr><td colspan="8" align="left">暂无信息！</td></tr></c:when>
						<c:otherwise>
				<c:forEach items="${xzcfList}" var="xzcf"> 
				<tr>
					<td>${xzcf.CFJGMC}</td>
					<td>${xzcf.CFMC}</td>
					<td>${xzcf.XZCFRQ}</td>
					<td>${xzcf.CFJDSWH}</td>
					<td>${xzcf.CFSY}</td>
					<td>${xzcf.CFZL}</td>
					<td>${xzcf.XZCFJL}</td>
					<td>${xzcf.SXDJ}</td>
				</tr>
				</c:forEach>
						</c:otherwise>
				</c:choose>
			</tbody>
		</table><br />
		</div>

		<script type="text/javascript">
			$("#usual1 ul").idTabs();
		</script>


	</div>
</body>
</html>