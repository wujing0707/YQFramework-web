<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	String bath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css" />
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
<script type="text/javascript" src="<%=basePath%>js/ajaxfileupload.js"></script>
<title>异议申诉</title>
<link href="css/style.css" rel="stylesheet" type="text/css" />

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
<body style="height:450px">
<!-- <div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>信用异议修复</li>
    <li>个人申诉</li>
    <li><a href="../complain/uploadFile.action">查看申诉信息</a></li>
  </ul>
</div> -->
<div class="formbody">

  <ul class="forminfo">
  <form:form action="saveComplain.action" commandName="complain" id="cform"  method="POST" >
    <li>
      <label>申诉人姓名</label>
      <form:input path="name" class="dfinput" disabled="true"/>
    </li>
    <li>
      <label><b>*</b>申诉人电话</label>
      <form:input path="phoneNumber" class="dfinput" disabled="true"/>
    </li>
    <li>
      <label><b>*</b>身份证号码</label>
      <form:input path="idNumber" class="dfinput" disabled="true"/>
    </li>
    
    <li>
      <label><b>*</b>申诉人Email</label>
       <form:input path="email" class="dfinput" disabled="true"/>
    </li>
    <li>
      <label><b>*</b>申诉人地址</label>
      <form:input path="address" class="dfinput" disabled="true"/>
    </li>
    <li>
      <label><b>*</b>申诉主题</label>
      <form:input path="subject" class="dfinput" disabled="true"/>
    </li>
    <li>
      <label><b>*</b>申诉内容</label>
      <textarea rows="4" cols="20" class="textinput"  style="overflow:auto;color:#ADADAD" readonly="true">${complain.content }</textarea>
      <form:hidden path="type" />
      
    </li>
    </li>
    
	  
	    <li>
      <label>申诉文件</label>
      <div class="in">
      	<ul id="files">
      		<c:forEach items="${cfiles }" var="file">
      			<li>
      			<!-- <a href="javascript:javascript:showfile('<%=bath %>/${file.path}');">${file.fileName }</a> -->
      			<a href="javascript:showfile('downloadFileT.action?filepath=${file.path}')">${file.fileName}</a>
      			</li>
      		</c:forEach>
        </ul>
      </div>
	</li>
    
    <li>
      <label>上传所需材料</label>
      <div class="in">
        1.异议信息申请表。<br />
        2.经办人身份证扫描件。（原件备查）<br />
        3.企业工商营业执照扫描件。（原件备查）<br />
        4.组织机构代码证扫描件。（原件备查）<br />
        5.相关证明材料扫描件。（原件备查）
      </div>
    </li>
    
     <c:if test="${(complain.handleStatus eq 'HANDLING') }">
      <li>
      <label>当前处理部门</label>
      <div class="">
      	<form:input path="handleDep" class="dfinput" disabled="true"/>
      </div>
    </li>
    </c:if>
     
    <c:forEach items="${hinfos}" var="hi" varStatus="status">
    <c:if test="${hi['show'] }">
    	<li class="border_top">
    	
    	<div class="welinfo">
                <span>${hi["depName"]}</span>
                <i> 处理人：${hi["handler"]} </i>
                <i> 处理时间：<fmt:formatDate value="${hi['time']}" type="date"/>  </i>
            </div>
    	</li>
    	<li>
    	<c:if test="${hi['type'] eq 'DHANDLE' }">
    	  <label><b></b>部门处理意见</label></c:if>
    	  <c:if test="${hi['type'] eq 'RESULT' }">
    	  <label>信用办处理意见</label></c:if>
    	  <textarea rows="4" cols="20" style="overflow-y:auto;color:#ADADAD" class="textinput" readonly="true">${hi['content']}</textarea>   	  
    	</li>
    </c:if>
     	<c:if test="${not empty hi['dfilepath'] }">
    	   <li>
      <b>附件:</b>
      <a href="javascript:showfile('downloadFileT.action?filepath=${hi['dfilepath']}')">${hi['filename']}</a>
       </li>
       </c:if> 
    </c:forEach>
    <li>
            <c:if test="${CHECK == 'Y'}">
      <input name="" type="button" class="btn click" value="关闭" onclick="javascript:window.opener=null;window.open('','_self');window.close();"/>
      </c:if>
      <c:if test="${CHECK != 'Y'}">
       <input name="" type="button" class="btn click" value="返回 " onclick="window.history.go(-1);"/>
      </c:if>
    </li>
      </form:form>
  </ul>
  
</div>

</body>
		
<script type="text/javascript">

function showfile(filepath){
	window.location.href=encodeURI(encodeURI(filepath, "UTF-8"), "UTF-8");    
}
	$(document).ready(function(){
		
	})
	
</script>