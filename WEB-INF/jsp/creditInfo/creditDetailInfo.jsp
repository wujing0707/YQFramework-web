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
<title>信用查询详情</title>
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
			<li>信用查询</li>
			<li>信用查询详情</li>
		</ul>
	</div>
	<div class="rightinfo">
		<table cellspacing="0" cellpadding="0" class="tablelist tablelist0"
			id="">
			<tbody>
				<tr>
					<th colspan="10" style="text-align: center;">基本信息</th>
				</tr>
				<c:choose>
				<c:when test='${ not empty tip }' ><tr><td>暂无信息！</td></tr></c:when>
				<c:otherwise>
				<tr>
					<th width = "10%">企业名称</th>
					<td colspan="3">${baseInfo.企业名称}</td>
					<th width = "10%">组织机构代码</th>
					<td width = "10%">${baseInfo.组织机构代码}</td>
					
					<!-- 
					<th width = "10%">企业英文名称</th>
					<td width = "10%">${baseInfo.企业英文名称}</td>
					 -->
					<th width = "10%">工商注册号</th>
					<td width = "10%">${baseInfo.企业注册号}</td>
					<th width = "10%">法定代表人</th>
					<td width = "10%">${baseInfo.法定代表人}</td>
				</tr>
				<tr>
				<!-- 
					<th >注册地址</th>
					<td>${baseInfo.注册地址}</td>
					
					<th>工商注册日期</th>
					<td>${baseInfo.工商注册日期}</td>
					<th >所属行业</th>
					<td>${baseInfo.所属行业}</td>
					<th >注册类型</th>
					<td>${baseInfo.注册类型}</td>
					<th >机构类型</th>
					<td>${baseInfo.机构类型}</td>
					 -->
				</tr>
				<tr>
					<th >注册类型</th>
					<td>${baseInfo.注册类型}</td>
					<th >注册资本(元 )</th>
					<td>${baseInfo.注册资本}</td>
					<!-- 
					<th>注册币种</th>
					<td>${baseInfo.注册币种}</td>
					
					<th >经营范围</th>
					<td>${baseInfo.经营范围}</td>
					
					<th >所属区域</th>
					<td>${baseInfo.所属区域}</td>
					 -->
					<th >企业状态</th>
					<td>${baseInfo.企业状态}</td>
					<th >联系电话</th>
					<td>${baseInfo.联系电话}</td>
					<th >纳税人标识号</th>
					<td>${baseInfo.纳税人标识号}</td>
				</tr>
				<!-- 
				<tr>
					
					<th >是否园区工商注册</th>
					<td>${baseInfo.是否园区工商注册}</td>
					<th>投资国家</th>
					<td>${baseInfo.投资国家}</td>
					<th >实际投资国别</th>
					<td>${baseInfo.实际投资国别}</td>
				</tr>
				-->
				<tr>
					<th >注册地址</th>
					<td colspan="3">${baseInfo.注册地址}</td>
					<th >经营范围</th>
					<td colspan="5"> ${baseInfo.经营范围}</td>
				</tr>
				</c:otherwise>
				</c:choose>
			</tbody>
		</table>

		<div id="usual1" class="usual mt10">

			<div class="itab">
				<ul>
					<c:forEach items="${allList}" var="info" varStatus="status">
						<li><a href="#tab${status.count}"
							<c:if test='${status.count==1}'> class='selected' </c:if>>${info.name}(${info.totalNum})</a>
						</li>
					</c:forEach>
				</ul>
			</div>

			<c:forEach items="${allList}" var="info" varStatus="status">
				<div id="tab${status.count}" class="tabson" 
					style=" overflow:scroll; width:98%; height:240px; position: relative;">
					<c:choose>
						<c:when test="${empty info.list}">
						${info.name}暂无信息！
						</c:when>
						<c:otherwise>
							<c:forEach items="${info.list}" var="deptInfo"
								varStatus="status">

								<div class="tab_tit">
									<span>${deptInfo.deptName}-${deptInfo.tableName}</span>
								</div>
								<table class="tablelist"  style="table-layout:fixed;width:100%">
									<tbody>
										<tr>
											<!-- 标题 -->
											<c:forEach items="${deptInfo.columnName}" var="titleInfo"
												varStatus="status">
												<th style="width:auto;word-wrap:break-word;">${titleInfo}</th>
											</c:forEach>
										</tr>
										<c:choose>
											<c:when test="${empty deptInfo.columnVal}">
											<tr>
											<td colspan="${fn:length(deptInfo.columnName) }" style="word-wrap:break-word;">暂无信息！</td>
											</tr>
											</c:when>
											<c:otherwise>
										<c:forEach items="${deptInfo.columnVal}" var="value"
											varStatus="status">
											<tr>
												<c:forEach items="${value}" var="var" varStatus="status">
													<td style="word-wrap:break-word;">${var}</td>
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

				</div>
			</c:forEach>
<!-- 
                    <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="window.location.href='<%=basePath%>creditInfo/tocreditInfo.action';">返回 </a>
	 -->
		</div>

		<script type="text/javascript">
			$("#usual1 ul").idTabs();
		</script>


	</div>
</body>
</html>