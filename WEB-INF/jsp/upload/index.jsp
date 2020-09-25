<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>苏州工业园区社会信用信息平台</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script>

<script type="text/javascript" src="<%=basePath%>js/ajaxfileupload.js"></script>
<style type="text/css">
label {
	float: left;
	width: 150px;
}

form {
	padding: 20px;
}

form div {
	padding: 10px;
}

.blod {
	padding-top: 0;
}

#input-file {
	position: relative; /* 保证子元素的定位 */
	width: 120px;
	height: 30px;
	background: #eee;
	border: 1px solid #ccc;
	text-align: center;
	cursor: pointer;
}

#text {
	display: inline-block;
	margin-top: 5px;
	color: #666;
	font-family: "黑体";
	font-size: 18px;
}

#file {
	display: block;
	position: absolute;
	top: 0;
	left: 0;
	width: 120px; /* 宽高和外围元素保持一致 */
	height: 30px;
	opacity: 0;
	-moz-opacity: 0; /* 兼容老式浏览器 */
	filter: alpha(opacity = 0); /* 兼容IE */
}
</style>
<script type="text/javascript">
	function getFileName(o){
    var pos=o.lastIndexOf("\\");
    return o.substring(pos+1);  
	}
	$(function() {
		$("#downmb").click(function() {
			var typename = $('#select_kind').combobox('getValue');
			var dept = $('#select_dept').combobox('getText');
			if(!typename || !dept){
				$.messager.alert("提示","<font color='red'>请选择部门信息类别!</font>");
				return ;
			}
			$('#selectMB').window('open');
			$("#checkdown").click(function() {
			var val = $('input:radio[name=planType]:checked').val();
			// modify by zhengzw 2015-11-26 对dept进行encodeURI
			window.location.href="${pageContext.request.contextPath}/dataupload/downmb.action?filetype="+val+"&tablename="+encodeURI(typename)+"&dept="+encodeURI(dept);
			$('#selectMB').dialog('close');
		});
		});
		
		$("#submitID").click(function() {	
			var typename = $('#select_kind').combobox('getText');
			if(!$('#form').form('validate')){
				$.messager.alert("提示","<font color='red'>数据项请填写完整!</font>");
				return ;
			}
			var file = $('#fileUpload').val();
			if(!file){
				$.messager.alert("提示","<font color='red'>请选择上报文件!</font>");
				return ;
			}else{
				/**
				var fileName = getFileName(file);
				var size = $('#fileUpload')[0].files[0].size/ 1024;   
				var IESize = $('#fileUpload').context.fileSize;
				if(Number(IESize)/1024>1024){
				    $.messager.alert("提示","<font color='red'>上报文件不能大于1M,请将文件分割分批上报!</font>");
      				return;
				}
     			if(size>1024) {
      				$.messager.alert("提示","<font color='red'>上报文件不能大于1M,请将文件分割分批上报!</font>");
      				return;
      			} 
      			var d1=/\.[^\.]+$/.exec(fileName);
      			if(d1!='.xlsx' && d1!='.xls'){
					$.messager.alert("提示","<font color='red'>请选择正确的excel文件上报!</font>");
					return;
      			}
      			**/
      			
      			// modify by zhengzw 2015-11-27 修改上传文件时，验证文件大小浏览器兼容问题
      			var fileName = getFileName(file);
      			
      			var d1=/\.[^\.]+$/.exec(fileName);
      			if(d1!='.xlsx' && d1!='.xls'){
					$.messager.alert("提示","<font color='red'>请选择正确的excel文件上报!</font>");
					return;
      			}
      			// modify by zhengzw 2015-11-27 修改上传文件时，验证文件大小浏览器兼容问题
			}
			
			// modify by zhengzw 2015-11-26 修改上传get 方式参数乱码问题
			var data = $('#form').serialize();
			//data = decodeURIComponent(data,true);
			//data = encodeURI(encodeURI(data));
			
			$.ajaxFileUpload({
				type : "POST",
				url : "dataupload/file.action?"+data,
				dataType : 'json',
				fileElementId : 'fileUpload',
				error : function(data, status, e)//服务器响应失败处理函数
				{
					alert(e);
				},
				success : function(data, status) {
					var json = eval('(' + data + ')');
					if (json.success==true) {
						$('#form')[0].reset();
						$.messager.alert("提示", json.fieldTXT + " 上传成功！");

					}else{
						$.messager.alert("提示", json.msg);
					}
				}
			});
		});
		$("#resetID").click(function() {
			$('#form')[0].reset();	
			window.location.reload();
		});
	});

	function getKind() {
		var value = $('#select_dept').combobox('getValue');
		$('#select_kind').combobox({
			// modify by zhengzw 2015-11-23 入参增加一次编码
			url : 'dataupload/getKind.action?dept=' + encodeURI(value),
			//url : 'dataupload/getKind.action?dept=' + encodeURI(encodeURI(value)),
			valueField : 'code',
			textField : 'name',
			disabled: false,
			multiple:false,
			editable : false
		}).combobox('clear');
	}
</script>
</head>

<body  class="bodyBG" >
	<div>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
	</div>
	<div class="blod" >
	<div style="background:#fafafa;" >
		<form id="form" method="post" enctype="multipart/form-data">
			<div align="left">
				<label for="dept">请选择部门:</label> <input id="select_dept"
					class="easyui-combobox" name="dept" style="width:200px;"
					url='dataupload/getDept.action' required="true" editable="false" 
					data-options="valueField:'code', textField:'name',multiple:false,onSelect:getKind">
 
				</input>
			</div>
			<div align="left">
				<label for="kind">请选择信息类别:</label> <select  id="select_kind"
					class="easyui-combobox" name="kind" style="width:200px;" required="true" editable="false"></select>
			</div>
			<div align="left">
				<label for="fileUpload">请选择上报数据:</label> <input id="fileUpload" name="fileUpload" required="true" type="file" />
			</div>
<!-- 			<div align="left">
				<label for="message">备注信息:</label>
				<textarea name="message" style="height:60px;width:200px;"></textarea>
			</div> -->
			<div></div>
			<div></div>
			<div align="left">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:void(0)"  class="easyui-linkbutton" iconCls="icon-download"  id="downmb" >模板下载</a>
				<a href="javascript:void(0)"  class="easyui-linkbutton" iconCls="icon-save"  id="submitID" >提交</a>
				<a href="javascript:void(0)"  class="easyui-linkbutton" iconCls="icon-refresh"  id="resetID">重置</a>
			</div>
		</form>
	</div>
		<div id="selectMB" class="easyui-dialog" title="请选择模板类型"
		style="width:300px;height:110px;padding:10px 20px; overflow:hidden;" closed="true" 
		buttons="#dlg-buttonsc">
<input type="radio" name="planType" value="0" checked="true" />.xlsx
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="radio" name="planType" value="1" />.xls
		<div id="dlg-buttonsc">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-download"  id="checkdown" style="width:66px">下载</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#selectMB').dialog('close');"
				style="width:66px">关闭</a>
		</div>
	</div>
	</div>
</body>
</html>
