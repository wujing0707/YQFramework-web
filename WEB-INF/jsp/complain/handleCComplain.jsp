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
<script type="text/javascript">

	function finish(){
		
		  var checkedr = $('input:radio[name="radio"]:checked').val();
		  if(!checkedr||checkedr.length==0){
			  alert("请选择信用办核查!");
				return ;
		  }

        if($('#contentdd').val().length<1){
					$.messager.alert("提示", "请输入处理意见");
					return ;
				}
			var file = document.getElementById("handleFile");
			var browserCfg = {};
			var ua = window.navigator.userAgent;
			if (ua.indexOf("MSIE")>=1){
			browserCfg.ie = true;
			}else if(ua.indexOf("Firefox")>=1){
			browserCfg.firefox = true;
			}else if(ua.indexOf("Chrome")>=1){
			browserCfg.chrome = true;
			}
				if (file == null) {
					alert("请上传附件!");
				}
		
			if (file != null && file.value) {
				if (browserCfg.firefox || browserCfg.chrome) {
					var size = file.files[0].size / (1024 * 1024);
					if (size > 2) {
						alert("附件大小不得超过2M!");
						return;
					}
				}
			}
			if(!file.value||file.value.length<1){
				alert("材料不能为空");
				return ;
			}
			var filename= file.value;
			var filetype= filename.substring(filename.lastIndexOf("."),filename.length);
			if(!(filetype == '.docx') && !(filetype == '.doc')){
			 alert("附件只能上传 docx文件和doc文件！");
			 return ;
			}
			
			 $.messager.confirm("确认", "确定已处理完成提交吗?", function (r) {  
			  if (r) {
        		$('#handleForm').form('submit', {
	        	    success: function(data){
	        	    $.messager.alert("提示", "异议申诉处理成功！","info",function (){window.location.href='<%=basePath%>complain/complainManage.action';});
	        	    $('.panel-tool-close').hide();
	        	    history.go(-1);
	        	    
	        	   /**
       		$.ajax({
				type : 'POST',
				url : '${pageContext.request.contextPath}/complain/finish.action',
				data : {
					id : id
				},
				error : function() {
					$.messager.alert("提示", "网络错误");
				},
				success : function(data, status) {
					$.messager.alert("提示", "处理成功!","info",function (){history.go(-1);});
					$('.panel-tool-close').hide();
					var json = eval('(' + data + ')');
					alert(json.success);
					if (json.success == true) {
						$.messager.alert("提示", json.msg,"info",function (){history.go(-1);});
					} else {
						$.messager.alert("提示", json.msg);
					}
				}
			});**/
	        	    }
	        	});
        		
 
			
			
        } 
        else{
        return;
        }
    });  
	 }
	 
</script>
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

.radio {
	 margin-top: 10px;
}
.welinfo{
	padding: left;
}
</style>
</head>
<body style="height:450px">
	
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>信用异议修复</li>
    <li>申诉管理</li>
    <li><a href="../complain/uploadFile.action">处理申诉</a></li>
  </ul>
</div>
<div class="formbody">
 <form:form action="" commandName="complain" id="cform"  method="POST" >
  <ul class="forminfo">
 
    <li>
      <label>申诉人姓名</label>
      <form:input path="name" class="dfinput" disabled="true"/>
    </li>
     <li>
      <label><b>*</b>机构代码</label>
      <form:input path="idNumber" class="dfinput" disabled="true"/>
    </li>
    <li>
      <label><b>*</b>申诉人电话</label>
      <form:input path="phoneNumber" class="dfinput" disabled="true"/>
    </li>
    <li>
      <label><b>*</b>申诉人Email</label>
       <form:input path="email" class="dfinput" disabled="true"/>
    </li>
    <li>
      <label><b>*</b>申诉人单位</label>
      <form:input path="company" class="dfinput" disabled="true"/>
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
	    
	    <li>
      <label>申诉文件</label>
      <div class="in">
      	<ul id="files">
      		<c:forEach items="${cfiles }" var="file">
      			<li>
      			<a href="javascript:showfile('downloadFileT.action?filepath=${file.path}')">${file.fileName }</a>
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
    
   
    
    <c:forEach items="${hinfos}" var="hi" varStatus="status">
    <c:if test="${hi['show'] }">
    	<li class="border_top">
    	
    	<div class="welinfo">
                <span>${hi["depName"]}
                <i> 处理人：${hi["handler"]} </i>
                <i> 处理时间：<fmt:formatDate value="${hi['time']}" type="date"/>  </i></span>
            </div>
    	</li>
    	<li>
    	<c:if test="${hi['type'] eq 'DHANDLE' }">
    	  <label><b></b>部门处理意见</label></c:if>
    	  <c:if test="${hi['type'] eq 'RESULT' }">
    	  <label>信用办意见</label></c:if>
    	  <textarea rows="4" cols="20" style="overflow-y:auto;color:#ADADAD" class="textinput" readonly="true" >${hi['content']}</textarea>
    	</li>
    </c:if>
    </c:forEach>
     </ul>
    </form:form>
</div>


<div class="formbody">
 <ul class="forminfo">
 <c:if test="${!(complain.handleStatus eq 'CHECKED') }">
    <form:form action="doHandleComplain.action" commandName="complainHandle" enctype="multipart/form-data" id="handleForm"  >
    <c:if test="${userDeptId eq '999' }">
         <li>
      <label>选择核查单位</label>
      <input type='radio' value='1' name='radio' class='radio' checked="checked">信用办核查</input><span></span>
		<input type='radio' value='2' name='radio' calss='radio' >部门核查</input>
      </li>
     <li id="DEPTLI">
     <label><b>*</b>核查部门</label>
      <div class="in">
      		<select name="selectDepId">
      			<option value="">---请选择部门---</option>
      			<c:forEach items="${depts}" var="dep">
      				<option value="${dep.code }">${dep.codedesc }</option>
      			</c:forEach>
      		</select>
        	
      </div>
    </li>
    </c:if>
     <li id="CLYJID">
      <label><b>*</b>处理意见</label>
      <form:textarea path="content"   rows="4" cols="20" class="textinput" onchange="this.value=this.value.substring(0, 300)" onkeydown="this.value=this.value.substring(0, 300)" onkeyup="this.value=this.value.substring(0, 300)" id="contentdd" style="overflow-y:auto" maxlength="300"/>
    </li>
      
<c:if test="${userDeptId eq '999' }">
   <li id="SCCLID">
	      <label><b>*</b>上传材料</label>
	      <input  value="选择文件" class="fileinput" type="file" name="handleFile" id='handleFile' >
	      <i>附件只能上传 docx文件和doc文件，附件大小不得超过2M</i>
	      <span>模板</span><a href="downloadFileT.action?type=2&filepath=${pageContext.request.contextPath}/templates/">异议信息处理反馈单.docx</a>
	</li>
</c:if>
    <li>
    <li></li>
    <li></li>
    <form:hidden path="complainId" id="complainID"/>
     <form:hidden path="handledBy" />
     <form:hidden path="depId" />
      <input name="" type="button" class="btn click" value="部门处理" id="submitHandle"/>
       <c:if test="${(userDeptId eq '999') }">
      <input type="button" class="btn click" value="处理完成" id="finishID" onclick="finish();"/>
      </c:if>
       <input name="" type="button" class="btn click" value="重置" onclick="resetfield()" />
       <input name="" type="button" class="btn click" value="返回 " onclick="window.history.go(-1);"/>
    </li>
      </form:form>
  </c:if>
  
  <c:if test="${complain.handleStatus eq 'CHECKED' }">
    <form:form action="doHandleComplain.action" commandName="complainHandle" enctype="multipart/form-data" id="handleForm"  >
             <li>
      <label>选择核查单位</label>
      <input type='radio' value='1' name='radio' class='radio' checked="checked">信用办核查</input><span></span>
		<input type='radio' value='2' name='radio' calss='radio' >部门核查</input>
      </li>
     <li id="DEPTLI">
      <label><b>*</b>核查部门</label>
      <div class="in">
      		<select name="selectDepId">
      			<option value="">---请选择部门---</option>
      			<c:forEach items="${depts}" var="dep">
      				<option value="${dep.code }">${dep.codedesc }</option>
      			</c:forEach>
      		</select>
        	
      </div>
    </li>
     <li id="CLYJID">
      <label><b>*</b>信用办意见 </label>
      <form:textarea path="content"   rows="4" cols="20" class="textinput" onchange="this.value=this.value.substring(0, 300)" onkeydown="this.value=this.value.substring(0, 300)" onkeyup="this.value=this.value.substring(0, 300)" id="contentdd" style="overflow-y:auto" maxlength="300"/>
    </li>

   <li id="SCCLID">
	      <label><b>*</b>上传材料</label>
	      <input  value="选择文件"  type="file" name="handleFile" id='handleFile'>
	      <i>附件只能上传 docx文件和doc文件，附件大小不得超过2M</i>
	      <span>模板</span><a href="downloadFileT.action?type=2&filepath=${pageContext.request.contextPath}/templates/">异议信息处理反馈单.docx</a>
	</li>
 
    <li>
    <form:hidden path="complainId" id="complainID"/>
     <form:hidden path="handledBy" />
     <form:hidden path="depId" />
       <input name="" type="button" class="btn click" value="部门处理" id="submitHandle"/>
            <c:if test="${(userDeptId eq '999') }">
      <input type="button" class="btn click" value="处理完成" id="finishID" onclick="finish();"/>
      </c:if>
      <input name="" type="button" class="btn click" value="重置" onclick="resetfield()" />
      <input name="" type="button" class="btn click" value="返回 " onclick="window.history.go(-1);"/>
    </li>
      </form:form>
  </c:if>
  

 </ul>
 <input type="hidden" id="donef" value="f">
 </div>

		
<script type="text/javascript">

function showfile(filepath){
	window.location.href=encodeURI(encodeURI(filepath, "UTF-8"), "UTF-8");    
}


function resetfield(){
	document.getElementById("handleForm").reset();
	var set = $("[name='radio']:checked").val();
	if (set == 1) {
		$('#DEPTLI').hide();
		$('#submitHandle').hide();
		$('#finishID').show();
		$('#CLYJID').show();
		$('#SCCLID').show();
	}
	
}

	$(document).ready(function(){
		
		$(":input").keyup(function(){
			var maxlength = $(this).attr("maxlength");
			var str = $(this).val();
			if(str!=null&&str.length==maxlength){
				alert("该字段的最大字符长度为"+maxlength+"!");
			}
		});
		
		$('#DEPTLI').hide();
		//$('#CLYJID').hide();
		//$('#SCCLID').hide();
		
			
		$("#submitHandle").bind("click",function(){
		if($("[name='radio']").length>0){

			var set = $("[name='radio']:checked").val();
			if (set != 2 || $("[name='selectDepId']").val()=="---请选择部门---") {
					$.messager.alert("提示", "请选择部门核查!");
					return false;
				}
			if(set==2 || $("[name='selectDepId']").val()=="---请选择部门---"){
				if($("[name='selectDepId']").val()<1){
					$.messager.alert("提示", "请分配核查部门!");
					return false;
				}
			}
			if (set == 1) {
					var content = $("#contentdd").val();
					if (content == null || content.length < 1) {
						$.messager.alert("提示", "请输入处理意见！");
						return false;
					}
				}
			}
			if($("[name='radio']").length<1 && $("#contentdd").length>0){
					var content = $("#contentdd").val();
					if (content == null || content.length < 1) {
						$.messager.alert("提示", "请输入处理意见！");
						return false;
					}
			}
			var file = document.getElementById("handleFile");
			if (file != null && file.value) {
				var size = file.files[0].size / (1024 * 1024);
				if (size > 2) {
					alert("附件大小不得超过2M!");
					return false;
				}
			}
			var donef = $("#donef").val();
			if (donef == "f") {
				$('#handleForm').form('submit', {
					success : function(data) {
						var data = eval('(' + data + ')'); // change the JSON string to javascript object
						$("#donef").val("t");
						$.messager.alert("提示", "申诉处理成功!","info",function (){window.location.href='<%=basePath%>complain/complainManage.action';});
						$('.panel-tool-close').hide();
					}
				});
			}

		})
		
		
		var set = $("[name='radio']:checked").val();
		if (set == 1) {
			$('#DEPTLI').hide();
			$('#submitHandle').hide();
			$('#finishID').show();
			$('#CLYJID').show();
			$('#SCCLID').show();
		}

		$("[name='radio']").bind("click", function() {
			var set = $("[name='radio']:checked").val();
			if (set == 1) {
				$('#DEPTLI').hide();
				$('#submitHandle').hide();
				$('#finishID').show();
				$('#CLYJID').show();
				$('#SCCLID').show();
			}
			if (set == 2) {
				$('#DEPTLI').show();
				$('#submitHandle').show();
				$('#finishID').hide();
				$('#CLYJID').hide();
				$('#SCCLID').hide();
			}
		})
	})
</script>