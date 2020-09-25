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
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/ajaxfileupload.js"></script>
<style type="text/css">
#winAdd label {
	float: left;
	vertical-align: middle;
	width: 150px;
}
#winAdd input,.easyui-combobox,.easyui-datebox {
	width: 200px;
}

#winAdd div {
	padding: 10px;
}
#form div {
	height: 30px;
}
#form label{
	height: 30px;
width: 150px;

}
</style>
<script type="text/javascript" src="<%=basePath%>js/ajaxfileupload.js"></script>

<script type="text/javascript">
	
	function formatTitle(value) {
		return "<span title='"+value+"'>" + value;
	}
	function conditionSearch() {
		var queryParams = $('#ListGrid').datagrid('options').queryParams;
		$('#ListGrid').datagrid('options').queryParams = queryParams;
		$('#ListGrid').datagrid("load");
		$('#ListGrid').datagrid("uncheckAll");
	}

	function formatOper(value, rowData) {
		var html = "";
		html += "<a href='javascript:(0);' style='margin: 5px; color: blue;'>查看</a>";
		if (rowData.status == 0)
			html += "<a href='javascript:cancle(\"" + rowData.id + "\");' style='margin: 5px; color: blue;'>撤销</a>";
		return html;
	}

	function formatStatus(value) {

		if (value == 0)
			return "未审核";
		if (value == 1)
			return "审核通过";
		if (value == 2)
			return "审核不通过";
		if (value == 4)
			return "申请已撤销";
	}

	function cancle(id) {
		$.messager.confirm('提示框', '你确定要撤销申请吗?', function() {
			$.ajax({
				type : 'POST',
				url : 'linkApp/applcancle.action',
				data : {
					ids : id.toString()
				},
				error : function() {
					$.messager.alert("提示", "网络错误");
				},
				success : function(data, status) {
					var json = eval('(' + data + ')');
					if (json.success == true) {
						$.messager.alert("提示", json.msg);
						$('#ListGrid').datagrid("reload");
					} else {
						$.messager.alert("提示", json.msg);
					}
				}
			});
		});
	}
	
	function addAppl(){		
		$('#winAdd').window('open');
	}
	function getKind() {
		var value = $('#select_dept').combobox('getValue');
		$('#select_kind').combobox({
			url : 'dataupload/getKind.action?dept=' + encodeURI(value),
			valueField : 'code',
			textField : 'name',
			disabled: false,
			multiple:false,
			editable : false
		}).combobox('clear');
	}

	function getCol() {
		var value = $('#select_kind').combobox('getValue');
		$('#select_col').combobox({
			url : 'dataupload/getCol.action?tablename=' + encodeURI(value),
			valueField : 'code',
			textField : 'name',
			disabled : false,
			multiple : true,
			editable : false
		}).combobox('clear');
	}
	
			function saveAppl() {	
			var typename = $('#select_kind').combobox('getText');
			if(!$('#form').form('validate')){
				$.messager.alert("提示","<font color='red'>数据项请填写完整!</font>");
				return ;
			}
			var file = document.getElementById('fileUpload').files[0];
			if(!file){

			}else{
				var size = file.size / 1024;   
				var type = file.type ;
     			if(size>10000) {
      				$.messager.alert("提示","<font color='red'>附件能大于10M!</font>");
      				return;
      			}
			}
			
			$.ajaxFileUpload({
				type : "POST",
				url : "linkApp/appladd.action?"+$('#form').serialize(),
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
						$.messager.alert("提示", json.msg);
						$('#winAdd').dialog('close');
					}else{
						$.messager.alert("提示", json.msg);
					}
				}
			});
		};
		
	function conditionReset() {
		$("#query_dept").combobox("setValue", "");
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
								<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-add" plain="true" onclick="addAppl()">新增</a> 
		<div style="margin-bottom:5px;float:right">

				<label for="dept">请选择部门:</label> <input id="query_dept"
					class="easyui-combobox" name="dept" 
					url='dataupload/getDept.action' editable="false"
					data-options="valueField:'code', textField:'name',multiple:false">
				</input>
			
			<a class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">查询</a>&nbsp;&nbsp; 
			<a class="easyui-linkbutton" iconCls="icon-refresh" onclick="conditionReset();">重置</a>
		</div>
	</div>
		<div>
			<table id="ListGrid" class="easyui-datagrid" style="width:auto;height: 450px; padding: 5px" 
				data-options="rownumbers:true, pagination:true, singleSelect:true, collapsible:true, fitColumns:true, 
	 		url:'linkApp/list.action', method:'post', iconCls:'icon-user', toolbar:'#tb'">
				<thead>
					<tr>
						<th field="applName"  width="23%" align="left" data-options="formatter:formatTitle">应用名称</th>
						<th field="applDeptcode"  width="15%" align="left" data-options="formatter:formatTitle">部门</th>
						<th field="applUsername"  width="15%" align="left" data-options="formatter:formatTitle">申请人</th>
						<th field="status"  width="15%" align="left" data-options="formatter:formatStatus">申请状态</th>
						<th field="createtimeString"  width="15%" align="left" data-options="formatter:formatTitle">申请时间</th>
						<th width="17%" align="left" data-options="field:'_operate',align:'center',formatter:formatOper">操作</th>
					</tr>
				</thead>
			</table>
		</div>
		</div>
		
		
			<div id="winAdd" class="easyui-dialog" title="申请"
		style="width:520px;height:480px;padding:10px 20px" closed="true"
		buttons="#dlg-buttons">

		<form id="form" method="post" enctype="multipart/form-data">
			<div align="left">
				<label for="update">核查应用名称:</label> <input
					class="easyui-validatebox" id="applNameID"
					name="applName" ></input>
			</div>
			<div align="left">
				<label for="dept">请选择部门:</label> <input id="select_dept"
					class="easyui-combobox" name="queryDeptcode" 
					url='dataupload/getDept.action'  editable="false" 
					data-options="valueField:'code', textField:'name',multiple:false,onSelect:getKind">
 
				</input>
			</div>
			<div align="left">
				<label for="update">核查信息类:</label><input  id="select_kind"
					class="easyui-combobox" name="queryTablename"   editable="false" 
					data-options="multiple:false,onSelect:getCol"></input>
			</div>
			<div align="left">
				<label for="kind">请选择核查字段:</label> <input  id="select_col"
					class="easyui-combobox" name="queryCol"   editable="false" data-options="multiple:true"></input>
			</div>
			<div align="left">
				<label for="update">核查应用场景:</label> <input
					class="easyui-validatebox"  id="scenariosID"
					name="scenarios" ></input>
			</div>
			<div align="left">
				<label for="fileUpload">附件:</label> <input id="fileUpload"
					name="fileUpload" type="file" />
			</div>
			<div align="left">
				<label for="update">核查日期:</label> <input class="easyui-datebox"
					id="updateID" name="update"  editable=false></input>
			</div>
		</form>
		<div id="dlg-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-save" onclick="saveAppl()" style="width:66px">提交</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#form').form('clear');$('#winAdd').dialog('close');"
				style="width:66px">取消</a>
		</div>
	</div>
</body>
</html>
