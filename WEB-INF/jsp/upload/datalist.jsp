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
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>

<script type="text/javascript" src="<%=basePath%>js/ajaxfileupload.js"></script>

<style type="text/css">
.easyui-combobox {
	width: 180px;
}

#winUpload label {
	float: left;
	width: 120px;
}

#winUpload div {
	padding: 5px;
}
#kindID,#deptID{
	background-color: #cccccc;
}
	.datagrid-btable .datagrid-cell {
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
</style>
<script type="text/javascript">
	 function findSize(field_id)
{
           var fileInput = $("#"+field_id)[0];
           byteSize  = fileInput.files[0].fileSize;
        return ( Math.ceil(byteSize / 1024) ); // Size returned in KB.
}
	function getFileName(o){
    var pos=o.lastIndexOf("\\");
    return o.substring(pos+1);  
	}
	function getKind() {
		var value = $('#select_dept').combobox('getValue');
		$('#select_kind').combobox({
			url : 'dataupload/getKind.action?dept=' + encodeURI(value),
			valueField : 'code',
			textField : 'name',
			multiple : false,
			//panelHeight : 'auto',
			editable : false
		}).combobox('clear');
	}
	

	function formatOper(value, rowData, index){ 
		var html =""; 
		if (rowData.count > 0)
		{
			html += "<a href='javascript: queryById(\""+rowData.tablename+"\",\""+rowData.count+"\",\"down\",\""+rowData.deptName+"\");' style='margin: 5px; color: blue;'>疑问报告下载</a>";	   		
		}
		if (rowData.error >0)
		{
			html += "<a href='javascript: queryByIdT(\""+rowData.tablename+"\",\""+rowData.error+"\",\"down\",\""+rowData.deptName+"\");' style='margin: 5px; color: blue;'>错误报告下载</a>";
		}
   		return html;
   		} 

	function formatTitle(value){
		return "<span title='"+value+"'>"+value+"</span>";
	}
	function queryById(id,count,p,d) {

		if (p == 'up') {
			window.location.href = "${pageContext.request.contextPath}/dataview/queryById.action?id=" + id;
		} else {
			if(count<=0){
			$.messager.alert("提示","<font color='red'>没有疑问报告!</font>");
			return;
			}
			$.messager.confirm("确认", "疑问报告下载后，请尽快处理重新上传！", function (r) {  
        if (r) {  
        	$('#yiwenDataGrid').datagrid("reload");
            window.location.href = "${pageContext.request.contextPath}/dataview/downResult.action?dept="+encodeURI(d)+"&tablename=" + id;
			
       			 }  
    		}); 

		}
	}
	
		function queryByIdT(id,count,p,d) {

		if (p == 'up') {
			window.location.href = "${pageContext.request.contextPath}/dataview/queryByIdT.action?id=" + id;
		} else {
			if(count<=0){
			$.messager.alert("提示","<font color='red'>没有错误报告!</font>");
			return;
			}
			$.messager.confirm("确认", "错误报告下载后，请尽快处理重新上传！", function (r) {  
        if (r) {  
        	$('#yiwenDataGrid').datagrid("reload");
            window.location.href = "${pageContext.request.contextPath}/dataview/downResultT.action?dept="+encodeURI(d)+"&tablename=" + id;
			
       			 }  
    		}); 

		}
	}
	
	function openUpWin(c,d,t){
		$('#deptID').val(d);
		$('#kindID').val(c);
		$('#kindTID').val(t);
		$('#winUpload').window('open');
		
		
	}
	function reUpload(){
			var file = $('#fileUpload').val();
			if(!file){
				$.messager.alert("提示","<font color='red'>请选择上报文件!</font>");
				return ;
			}else{
				var fileName = getFileName(file);
				var browserCfg = {};
				var ua = window.navigator.userAgent;
      			if(ua.indexOf("MSIE") >= 1)  // IE
      			{
      				browserCfg.ie = true;
      			}
      			else if(ua.indexOf("Firefox") >= 1)
      			{
      				browserCfg.firefox = true;
      			}
      			else if(ua.indexOf("Chrome") >= 1)
      			{
      				browserCfg.chrome = true;
      			}
      			
      			var size = 0;
      			if(browserCfg.firefox || browserCfg.chrome )
      			{
      				size = $('#fileUpload')[0].files[0].size;//1024;
      			}
      			else if(browserCfg.ie)
      			{
      				size = $('#fileUpload').context.fileSize;
      			}
      			
      			if(Number(size)/1024 > 1024)
      			{
      				$.messager.alert("提示","<font color='red'>上报文件不能大于1M,请将文件分割分批上报!</font>");
      				return;
      			}
				
      			var d1=/\.[^\.]+$/.exec(fileName);
      			if(d1!='.xlsx' && d1!='.xls'){
					$.messager.alert("提示","<font color='red'>请选择正确的excel文件上报!</font>");
					return;
      			}
			}
			$.ajaxFileUpload({
				type : "POST",
				url : "dataupload/file.action?"+$('#form').serialize(),
				dataType : 'json',
				fileElementId : 'fileUpload',
				error : function(data, status, e)//服务器响应失败处理函数
				{
					alert(e);
				},
				success : function(data, status) {
					var json = eval('(' + data + ')');
					if (json.success==true) {
						$.messager.alert("提示", json.fieldTXT + "上传成功！");
						$('#form')[0].reset() ;
						$('#winUpload').dialog('close');
						$('#yiwenDataGrid').datagrid("reload");
					}else{
						$.messager.alert("提示", json.msg);
					}
				}
			});
	}

	function conditionSearch() {
		var queryParams = $('#yiwenDataGrid').datagrid('options').queryParams;
		queryParams.dept = $.trim($("#select_dept").combobox("getValue"));
		queryParams.kind = $.trim($("#select_kind").combobox("getValue"));
		$('#yiwenDataGrid').datagrid('options').queryParams = queryParams;
    	$('#yiwenDataGrid').datagrid("load");
    	$('#yiwenDataGrid').datagrid("uncheckAll");
	}
	
	function conditionReset() {
		$("#select_dept").combobox("setValue", "");
		$("#select_kind").combobox("setValue", "");
		window.location.reload();
	}
</script>
</head>

<body>

	<div >
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
			<div id="tb" style="padding:5px;height:auto">
		<div style="margin-bottom:5px">
				<label for="dept">请选择部门:</label> <input id="select_dept"
					class="easyui-combobox" name="dept" 
					url='dataupload/getDept.action' editable="false"
					data-options="valueField:'code', textField:'name',multiple:false,onSelect:getKind">
				</input>

				<label for="kind">请选择信息类别:</label> <select id="select_kind" class="easyui-combobox" name="kind"  editable="false"></select>
			<a class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">查询</a>&nbsp;&nbsp; 
			<a class="easyui-linkbutton" iconCls="icon-refresh" onclick="conditionReset();">重置</a>
		</div>
		<div></div>
	</div>
		<div>
			<table id="yiwenDataGrid" class="easyui-datagrid" style="width:100%;height: 370px; padding: 5px" 
				data-options="rownumbers:true, pagination:true, singleSelect:true, collapsible:true, fitColumns:true, 
	 		url:'dataview/list.action', method:'post', iconCls:'icon-user', toolbar:'#tb'">
				<thead>
					<tr>
						<th field="deptName"  width="10%" align="left" data-options="formatter:formatTitle">部门</th>
						<th field="comment" width="15%" align="left" data-options="formatter:formatTitle">信息类别</th>
						<th field="createtime" width="8%" align="left" data-options="formatter:formatTitle">上传时间</th>
						<th field="repeat" width="7%" align="left" data-options="formatter:formatTitle">重复数据量</th>	
						<th field="error" width="7%" align="left" data-options="formatter:formatTitle">错误数据量</th>	
						<th field="mismatch" width="8%" align="left" data-options="formatter:formatTitle">未匹配数据量</th>			
						<th field="success" width="7%" align="left" data-options="formatter:formatTitle">有效数据量</th>			
						<th field="nohandle" width="8%" align="left" data-options="formatter:formatTitle">未处理数据量</th>		
						<th field="count" width="7%" align="left" data-options="formatter:formatTitle">疑问数据量</th>				
						<th width="30%" data-options="field:'_operate',align:'center',formatter:formatOper">操作</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
	<div id="winUpload" class="easyui-dialog" title="上报文件"
		style="width:400px;height:380px;padding:10px 20px" closed="true"
		buttons="#dlg-buttons">
		<form id="form" method="post" enctype="multipart/form-data">
					<div align="left">
				<label for="update">部门:</label> <input class="easyui-validatebox" readonly="readonly" 
					id="deptID" name="dept"  style="width:180px;" ></input>
			</div>
						<div align="left">
				<label for="update">信息类别:</label> <input class="easyui-validatebox" readonly="readonly" 
					id="kindID" name="kindf"  style="width:180px;" ></input>
					<input type="hidden" id="kindTID" name="kind" ></input>
			</div>
						<div align="left">
				<label for="fileUpload">请选择上报数据:</label> <input id="fileUpload"
					name="fileUpload" type="file"/>
			</div>
			<div align="left">
				<label for="update">修复日期:</label> <input class="easyui-datebox" id="updateID"
					name="update"  style="width:180px;" editable=false ></input>
			</div>
<!-- 			<div align="left">
				<label for="message">备注信息:</label>
				<textarea name="message" style="height:60px;width:180px;"></textarea>
			</div> -->
		</form>
		<div id="dlg-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-save" onclick="reUpload()" style="width:66px">提交</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#form').form('clear');$('#winUpload').dialog('close');"
				style="width:66px">取消</a>
		</div>
	</div>
</body>
</html>
