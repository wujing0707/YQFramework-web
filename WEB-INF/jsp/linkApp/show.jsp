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
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script>
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
#dataGrid{
	overflow: hidden;
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
		html += "<a href='javascript:result(\""+rowData.id+"\");' style='margin: 5px; color: blue;'>查询结果</a>";
		if (rowData.status > 0)
			html += "<a href='javascript:(0);' style='margin: 5px; color: blue;'>撤销</a>";
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

	
		
	function conditionReset() {
		$("#query_dept").combobox("setValue", "");
		window.location.reload();
	}
	

	function result(id) {

		$.getJSON('${pageContext.request.contextPath}/linkApp/result.action?id='+id,
				function(result) {
					var columns = new Array();
					$.each(result.headers[0], function(i, field) {
						var column = {};
						column["title"] = i;
						column["field"] = field;
						column["width"] = 50;
						columns.push(column);//当需要formatter的时候自己添加就可以了,原理就是拼接字符串.  
					});
					$('#dataGrid').datagrid({
						height : 500,
						singleSelect : true,
						columns : [ columns ],
						rownumbers : true,
						pagination:true
					}).datagrid('loadData', result.body);
					
					$('#resListId').window('open');
				});
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

				<label for="dept">请选择部门:</label> <input id="query_dept"
					class="easyui-combobox" name="dept" 
					url='dataupload/getDept.action' editable="false"
					data-options="valueField:'code', textField:'name',multiple:false">
				</input>
				<label for="dept">状态: </label><select  class="easyui-combobox" name="dept" style="width:100px;">
					<option value="1">审核通过</option>
					<option value="2">审核不通过</option>
					</select> 
			
			<a class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">查询</a>&nbsp;&nbsp; 
			<a class="easyui-linkbutton" iconCls="icon-refresh" onclick="conditionReset();">重置</a>
		</div>
	</div>
	
		<div>
			<table id="ListGrid" class="easyui-datagrid" style="width:auto;height: 450px; padding: 5px" 
				data-options="rownumbers:true, pagination:true, singleSelect:true,collapsible:true,fitColumns:true, 
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
		<div id="resListId" class="easyui-dialog" title="信用联动应用"
		style="width:800px;height:480px;" closed="true">
					<div id="tbtb" style="padding:5px;height:auto">
		<div style="margin-bottom:5px">

				<label for="dept">企业名称:</label> <input id="query_dept"
					class="easyui-validatebox" name="qymc" >
				</input>			
			<a class="easyui-linkbutton" iconCls="icon-search" >查询</a>&nbsp;&nbsp; 
			<a class="easyui-linkbutton" iconCls="icon-refresh" >重置</a>
		</div>
	</div>
			<div><table id="dataGrid" class="easyui-datagrid"  
				data-options="rownumbers:true, pagination:true, singleSelect:true, collapsible:true, fitColumns:true,
	 		 method:'post', iconCls:'icon-user', toolbar:'#tbtb'">
			</table></div>
		</div>
</body>
</html>
