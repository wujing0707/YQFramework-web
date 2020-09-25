﻿<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
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
<script type="text/javascript" src="<%=basePath%>js/jquery.validity.js"></script>
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
<!--  
<div class="place"> <span>位置：</span>
  <ul class="placeul">
    <li>信用异议修复</li>
    <li>企业申诉</li>
    <li>企业申诉</li>
  </ul>
</div>
-->
<div class="formbody">

  <ul class="forminfo">
  <form:form action="saveComplain.action" commandName="complain" id="cform"  method="POST" >
    <li>
      <label>申诉人姓名</label>
      <form:input path="name" id="name" class="dfinput" maxlength="25" infos="申诉人姓名"/>
    </li>
     <li>
      <label><b>*</b>申诉人单位</label>
      <form:input path="company" id="company" class="dfinput must" maxlength="25" infos="申诉人单位"/>
    </li>
     <li>
      <label><b>*</b>组织机构代码</label>
      <form:input path="idNumber" id="idNumber" class="dfinput" disabled="true" maxlength="25" infos="机构代码"/>
      <form:hidden path="idNumber"/>
    </li>
    <li>
      <label><b>*</b>申诉人电话</label>
      <form:input path="phoneNumber" id="phoneNumber" class="dfinput must" maxlength="25" infos="申诉人电话"/>
    </li>
    <li>
      <label><b>*</b>申诉人Email</label>
       <form:input path="email" id="email" class="dfinput must" maxlength="25" infos="申诉人Email"/>
    </li>
   
    <li>
      <label><b>*</b>申诉人地址</label>
      <form:input path="address" id="address" class="dfinput must" maxlength="25" infos="申诉人地址"/>
    </li>
    <li>
      <label><b>*</b>申诉主题</label>
      <form:input path="subject" class="dfinput must" maxlength="25" id="subjectID" infos="申诉主题"/>
    </li>
    <li>
      <label><b>*</b>申诉内容</label>
      <form:textarea path="content" id="content" rows="4" cols="20" class="textinput must" onchange="this.value=this.value.substring(0, 300)" onkeydown="this.value=this.value.substring(0, 300)" onkeyup="this.value=this.value.substring(0, 300)" maxlength="300" style="overflow-y:auto" infos="申诉内容"/>
      <form:hidden path="type" />
      
    </li>
	    <li>
	      <label><b>*</b>上传材料</label>
	      <input  value="选择文件" type="file" name="uploadfiles" id='uploadfiles'>
	      <input value="上传" class="fileinput" type="button"  id="uploadbt"><br/>
	      	附件只能上传 doc/docx/jpg/pdf文件，附件大小不得超过2M<br/>
	      <span style="padding-left:98px">模板</span><a href="downloadFileT.action?type=1&filepath=${pageContext.request.contextPath}/templates/">异议申诉申请表.docx</a>
	    </li>
	    <li>
          <div class="in">
      	   <ul id="files">
        	
            </ul>
          </div>
	  </li>
    
    <li>
      <label style="line-height:20px">上传所需材料</label>
      <div class="in">
        1.异议信息申请表。<br />
        2.经办人身份证扫描件。（原件备查）<br />
        3.企业工商营业执照扫描件。（原件备查）<br />
        4.组织机构代码证扫描件。（原件备查）<br />
        5.相关证明材料扫描件。（原件备查）
      </div>
    </li>
    <li>
        <input name="" type="button" class="btn click" value="提 交" id="submitComplain"/>
        <input id="check" type="hidden" value="${CHECK}"/>
      <input name="" type="reset" class="btn ml20" value="重 置"/>
    </li>
      </form:form>
  </ul>
  
</div>

<!--提示窗口 -->
<div class="tip">
    <div class="tiptop"><span>提示信息</span><a></a></div>
    
    <div class="tipnr tc">
        <p>您的申诉已提交成功！请耐心等待！</p>
    </div>
</div>

</body>
		
<script type="text/javascript">
var uploadedFileString = "";

function showfile(filepath){
	window.open("downloadFileT.action?filepath=");    
}

	var passed = true
	function validateForm(){
		$(".must").each(function(){
			passed = true;
			var v = $(this).val();
			var infos = $(this).attr("infos");
			v=v.replace(/(^\s*)|(\s*$)/g, "");
			if(v==null||v.length==0){
				alert(infos+"不能为空！");
				passed = false;
				return false;
			}
		})
	}

	$(document).ready(function(){
		
		var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）———|{}【】‘；：”“'。，、？]")
		$("#subjectID").blur(function(){
			var subjet = $(this).val();
			if(pattern.test(subjet)){
				alert("申诉主题不能包含特殊字符！");
				$(this).val("");
			}
		})
		
		$("#submitComplain").bind("click",function(){
			var vp = validateForm();
			if(!passed){
				return;
			}
			var cfids1 = document.getElementsByName("cfIds");
			var c = $("#submitComplain").val();
			if(c.length>20){
				alert("申诉主题过长，不要超过20个字!");
				return;
			}
			var start_ptn = /<\/?[^>]*>/g;      //过滤标签开头      
            var end_ptn = /[ | ]*\n/g;            //过滤标签结束  
            var space_ptn = /&nbsp;/ig;          //过滤标签结尾
	  		var c1 = c.replace(start_ptn,"").replace(end_ptn).replace(space_ptn,"");  
	   		$("#submitComplain").attr("value",c1);
	   		
			var cfids = $("input[name='cfIds']").val();
			if(cfids==null||cfids.length<1){
				alert("请上传申诉文件！");
				return;
			}
		
		    if(cfids1.length != 5){
			alert("必须上传 5个附件!");
			 return ;
			}
	
			$.ajax({
                cache: true,
                type: "POST",
                url:"${pageContext.request.contextPath}/complain/saveComplain.action",
                data:$('#cform').serialize(),// 你的formid
                async: false,
                error: function(request) {
                	 alert("保存失败！");
                },
                success: function(data) {
                    alert("保存成功，如您有需要，请继续申请！");
                    var check = $('#check').val();
                    if (check == 'Y') {
                    	window.location.href = "${pageContext.request.contextPath}/complain/editComplain.action?UTYPE=C&CHECK=Y";
                    } else {
                    	history.go(-1);
                    }
                }
            });
            
            $('#idNumber').val('137810039');
		});
		
		
		$(":input").keyup(function(){
			var maxlength = $(this).attr("maxlength");
			var str = $(this).val();
			var infos = $(this).attr("infos");
			if(str!=null&&str.length==maxlength){
				alert(infos+"字数不能超过"+maxlength+"!");
			}
		});
		
		$("#uploadbt").bind("click",function(){
		    var browserCfg = {};
			var ua = window.navigator.userAgent;
			if (ua.indexOf("MSIE")>=1){
			browserCfg.ie = true;
			}else if(ua.indexOf("Firefox")>=1){
			browserCfg.firefox = true;
			}else if(ua.indexOf("Chrome")>=1){
			browserCfg.chrome = true;
			}
			//var file = $("#uploadfiles").val();
			var file = document.getElementById("uploadfiles");

			var filename= file.value;
			if (filename == '') {
			    alert("没有上传，请选择文件上传！");
                            return;
			}
			
			var filetype= filename.substring(filename.lastIndexOf("."),filename.length);
			filename = filename.replace(" ","");
			//alert(uploadedFileString.indexOf(filename));
			if (browserCfg.firefox || browserCfg.chrome) {
				var newFileName = filename.substring(filename.lastIndexOf("\\")+1,filename.length);
			   if(uploadedFileString.indexOf(newFileName)>=0){
				alert(filename+"已经上传,请选择其他文件上传！");
				return false;
			   } 
			} else {
			    var newFileName = filename.substring(filename.lastIndexOf("\\")+1,filename.length);
			    if(uploadedFileString.indexOf(newFileName)>=0){
				alert(filename+"已经上传,请选择其他文件上传！");
				return false;
			   } 
			}
			if(!file.value){
				alert("请选择申诉文件!");
				return false;
			}
			var cfids1 = document.getElementsByName("cfIds");
			if(cfids1.length>4){
			alert("最多只能上传5个附件!");
			 return false;
			}
		
			if(!(filetype == '.doc')&&!(filetype == '.pdf')&&!(filetype == '.jpg')&&!(filetype == '.docx') ){
			 alert("附件只能上传 doc/docx/jpg/pdf文件！");
			 return false;
			}

			 $("#uploadbt").attr({"disabled":"disabled"});
			$.ajaxFileUpload({
				url:'${pageContext.request.contextPath}/complain/uploadFile.action',
				dataType:'text',
				fileElementId:'uploadfiles',
				type:'POST',
				success:function(data,status){
				 $("#uploadbt").removeAttr("disabled");
		             data = data.substring(data.indexOf("{") , data.lastIndexOf("}") + 1);
					 var dataset = $.parseJSON(data);
					 uploadedFileString+=dataset.cf.fileName;
					//var json = eval('(' + data + ')');
					var idstr = "<input type='hidden' name='cfIds' value="+dataset.cf.id+">";
					//$("#hiddenIds").append(idstr);
					var url = dataset.cf.path;
					url = encodeURI(encodeURI(url, "UTF-8"), "UTF-8");
					var htmlstr= "<li class='fileLi'>"+idstr
					+"<span class='fileName'>" + dataset.cf.fileName + "</span>"+"<a href='#' onclick='removeFile(\""+dataset.cf.id+"\",this)' >删除</a><a href='downloadFileT.action?filepath=" +url+"'>查看</a></li>" ;
					$("#files").append(htmlstr);
					$("#uploadfiles").val("");
				},
				error:function(data,status,e){
					alert("附件大小不得超过2M!");
					return;
					//alert(e);
				}
			})
		});
		
	})
	
	
	
	function removeFile(id,obj){
		$.ajax({
			url:'${pageContext.request.contextPath}/complain/removeFile.action?cfid='+id,
			dataType:'text',
			success:function(data,status){
				data = data.replace("<PRE>", '');
				 data = data.replace("</PRE>", '');
				 data = data.replace("<pre>", '');
				 data = data.replace("</pre>", '');
				 var dataset = $.parseJSON(data);
				 var fileName = $(obj).parent().find('.fileName').html();
				 uploadedFileString = uploadedFileString.replace(fileName, '');
				 alert("文件删除成功！");
				$(obj).parent().remove();
			},
			error:function(data,e){
				alert(e);
			}
		})
		
		
	}
	
</script>