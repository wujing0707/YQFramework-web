<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%    
	String path = request.getContextPath();    
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";    
	pageContext.setAttribute("basePath",basePath);    
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>企业征信数据处理</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">

    
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/json2.js"></script>
</head>
<script type="text/javascript">
$.extend($.fn.validatebox.defaults.rules,{
	englishCheckSub:{
		validator:function(value){
		return /^[a-zA-Z]+$/.test(value);
		},
		message:"只能包括英文字母"
	}
});


$.extend($.fn.datagrid.methods, {
	fixRownumber : function (jq) {
		return jq.each(function () {
			var panel = $(this).datagrid("getPanel");
			//获取最后一行的number容器,并拷贝一份
			var clone = $(".datagrid-cell-rownumber", panel).last().clone();
			//由于在某些浏览器里面,是不支持获取隐藏元素的宽度,所以取巧一下
			clone.css({
				"position" : "absolute",
				left : -1000
			}).appendTo("body");
			var width = clone.width("auto").width();
			//默认宽度是25,所以只有大于25的时候才进行fix
			if (width > 25) {
				//多加5个像素,保持一点边距
				$(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).width(width + 5);
				//修改了宽度之后,需要对容器进行重新计算,所以调用resize
				$(this).datagrid("resize");
				//一些清理工作
				clone.remove();
				clone = null;
			} else {
				//还原成默认状态
				$(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).removeAttr("style");
			}
		});
	}
});


$(function(){
	initDataGridSearch();
	$("#showOrhide").hide();
});

function initDataGridSearch(){
	$('#dg_search').datagrid({
		url: "${pageContext.request.contextPath}/system/tablemapping/queryTableByName.action",
		height: 380,
		width: '100%',
		rownumbers:true, 
		pagination:true, 
		collapsible: true,
		fitColumns:true,
		title: '关系映射查询',
		singleSelect: true,
		toolbar: '#tb_search',
		queryParams: {tableName: '', tableType: '1'},
		method: 'post',
		 onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
				    },
		columns: [[{
			title: '临时表名', field:'tempTableName', width:348, align:'center'
		},{
			title: '原始表名', field:'albtTableName', width:348, align:'center'
		},{
			title: '操作', field:'none', width:348, align:'center',
			formatter: function(value, rowData, index){
				var html = "<a href='javascript: dgReload(\""+rowData.id+"\",\""+rowData.tempTableName+"\",\""+rowData.albtTableName+"\",\""+rowData.isCompletion+"\");' style='padding: 5px;color:blue' >编辑</a>"+
						"<a href='javascript: deleteById(\""+rowData.id+"\");' style='padding: 5px;color:blue' >删除</a>";
				return html;
			}
		}]]
		
	});
}

var tempTableName = '';
var albtTableName = '';
var albtTableId = '';
var iscompletion='';
function initDataGrid(){
	//console.info(tempTableName);
	//console.info(albtTableName);
	$("#showOrhide").show();
	$('#dg').datagrid({
		title: '【编辑映射】——临时数据转原始数据关系映射',
		singleSelect: true,
		height: 325,
		toolbar: '#tb',
		method: 'post',
		onClickRow: onClickRow,
		url: '${pageContext.request.contextPath}/system/tablemapping/queryTableColumnByFK.action',
		queryParams: {albtTableId: albtTableId},
		 onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
				    },
		columns: [[{
			title: 'id',hidden:'true',
			field: 'id',width:270,align:'center'
		},{
			title: '临时表字段',
			field:'tempcolumnid',width:270,align:'center',
			editor:{
				type:'combobox',
				options:{
					valueField:'tempColumnId',
					textField:'tempColumnName',
					url:'${pageContext.request.contextPath}/system/table/tempEntityColumns.action?tableName='+tempTableName+"&t="+new Date(),
					required:true,
					editable: false
				}
			}
		},{
			title: '原始表字段',
			field:'albtpcolumnid',width:270,align:'center',
			editor:{
				type:'combobox',
				options:{
					valueField:'albtColumnId',
					textField:'albtColumnName',
					url:'${pageContext.request.contextPath}/system/table/albtEntityColumns.action?tableName='+albtTableName+"&t="+new Date(),
					required:true,
					editable: false					
				}
			}
		},
		{
			title: '是否联合唯一主键',
			field:'isjoin',width:270,align:'center',
				editor:{
					type:'checkbox',
					options:{
						on:'是',off:'否'
					}
				}
		}]]
	});
	// 注意：重新 init datagrid 时不要忘了重置这个参数
	editIndex = undefined;
}

	// 提交保存
	function submitSave(){
		if(editIndex != undefined){
			$.messager.alert('提示','请按‘确定’按钮后再保存！');
			return;
		}
		var tempcolumnids = new Array();
		var albtpcolumnids = new Array();
		var isspilts = new Array();
		var isonlys=new Array();
		var isjoins=new Array();
		var rows = $("#dg").datagrid("getRows");
		if(rows.length == 0){
			$.messager.alert('提示','请至少新增一个列');
			return;
		}
		
		for(var i = 0; i < rows.length; i++){
			tempcolumnids.push(rows[i].tempcolumnid);
			albtpcolumnids.push(rows[i].albtpcolumnid);
			isspilts.push(rows[i].issplit);
			isonlys.push(rows[i].isonly);
			isjoins.push(rows[i].isjoin);
		}
		var count = 0;
		// 只能有一个是拆分的
		for(var i = 0; i < isspilts.length; i++){
			if(isspilts[i] == '是'){
				count++;
			}
		}
		if(count > 1){
			$.messager.alert('提示',"只能设置一个字段为拆分字段");
			return ;
		}
		
		// 只能有一个是唯一的
		var countonly=0;
		for(var i = 0; i < isonlys.length; i++){
			if(isonlys[i] == '是'){
				countonly++;
			}
		}
		if(countonly > 1){
			$.messager.alert('提示',"只能设置一个字段为唯一属性");
			return ;
		}
		
		if(isjoins.length==0){
			$.messager.alert('提示',"至少设置一个字段为联合主键");
			return ;
		}
		// 判断 字段名 是否有重复
		var ntempcolumnids = tempcolumnids.sort();
		for (var i = 0; i < tempcolumnids.length; i++) {
			if (ntempcolumnids[i] == ntempcolumnids[i + 1]) {
				$.messager.alert('提示',"临时表字段'"+ntempcolumnids[i]+"'有重复");
				return ;
			}
		}
		// 判断 对应字段 是否有重复
		var nalbtpcolumnids = albtpcolumnids.sort();
		for (var i = 0; i < albtpcolumnids.length; i++) {
			if (nalbtpcolumnids[i] == nalbtpcolumnids[i + 1]) {
				$.messager.alert('提示',"原始表字段'"+nalbtpcolumnids[i]+"'有重复");
				return ;
			}
		}
		
		// 将 datagrid 中的数据构建成 json 格式的数据
		var jsonColumns = bulidColumns(rows);
		// console.info(jsonColumns);
		
		//是否需要补全数据
		if($("#iscompletion").prop("checked")==true){
			iscompletion=1;
		}else{
			iscompletion=0;
		}
		
		// 灰掉，防止重复提交
		$("#saveId").linkbutton("disable");
		$("#addId").linkbutton("disable");
		$("#delId").linkbutton("disable");
		$("#cancelId").linkbutton("disable");
		$("#sureId").linkbutton("disable");
		$.post("${pageContext.request.contextPath}/system/tablemapping/updatedMappingRelation.action", {
			    albtTableId: albtTableId,
				temptablename: tempTableName,
				albttablename: albtTableName,
				columns: jsonColumns,
				iscompletion: iscompletion
			}, 
			function(data){
				if(data.result){
					$.messager.alert('提示', data.message, 'info', function(){
						window.location = "${pageContext.request.contextPath}/system/tablemapping/indexUpdateTableMapping.action";
					});
				}else{
					$.messager.alert('提示', data.message);
					$("#saveId").linkbutton("enable");
					$("#addId").linkbutton("enable");
					$("#delId").linkbutton("enable");
					$("#cancelId").linkbutton("enable");
					$("#sureId").linkbutton("enable");
				}
			}
		,"json");
	}

/**
 * 查询
 */
function tableMappingSearch(){
	var queryParams = $('#dg_search').datagrid('options').queryParams;
    
    queryParams.tableType = $("#tableType").val();
    queryParams.tableName = $.trim($('#tableName_search').val());
    
    $('#dg_search').datagrid('options').queryParams = queryParams;
    $("#dg_search").datagrid("reload");
}

function dgReload(p_albtTableId, p_tempTableName, p_albtTableName,p_iscompletion){
	albtTableId = p_albtTableId;
	tempTableName = p_tempTableName;
	albtTableName = p_albtTableName;
	iscompletion = p_iscompletion;
	initDataGrid();
    
    $('#tempEntityTableId').combobox({
    	valueField: 'tableId',
		textField: 'tableName',
    	disabled: true,
    	data:[{'tableId': p_tempTableName, 'tableName': p_tempTableName, 'selected': true}]
    });
    
    $('#albtEntityTableId').combobox({
    	valueField: 'tableId',
		textField: 'tableName',
    	disabled: true,
    	data:[{'tableId': p_albtTableName, 'tableName': p_albtTableName, 'selected': true}]
    });
    if(iscompletion==1){
    	$("#iscompletion").prop("checked",true);
    }else{
    	$("#iscompletion").prop("checked",false);
    }
}

function deleteById(p_albtTableId){
	$.messager.confirm('提示', '您确认要删除关系映射吗？', function(r){
		if(r){
			$.post('${pageContext.request.contextPath}/system/tablemapping/deleteMappingRelation.action', {
				albtTableId: p_albtTableId
			},
			function(data){
				if(data.result){
					$.messager.alert('提示', data.message);
					//tableMappingSearch();
					window.location.reload();
				}else{
					$.messager.alert('提示', data.message);
				}
			}, 'json');
		}
	});
	 $('#tempEntityTableId').combobox("setValue","");
	 $('#albtEntityTableId').combobox("setValue","");
	 $("#iscompletion").prop("checked",false);
	//$("table tbody").html("");
}

</script>
<script type="text/javascript">
var editIndex = undefined;
function endEditing(){
	if (editIndex == undefined){return true;}
	if ($('#dg').datagrid('validateRow', editIndex)){
		$('#dg').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
function onClickRow(index){
	if (editIndex != index){
		if (endEditing()){
			$('#dg').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			checkboxChanged();
		} else {
			$('#dg').datagrid('selectRow', editIndex);
		}
	}
}
function append(){
	if (endEditing()){
		$('#dg').datagrid('appendRow',{status:'P'});
		editIndex = $('#dg').datagrid('getRows').length-1;
		$('#dg').datagrid('selectRow', editIndex)
				.datagrid('beginEdit', editIndex);
	}
}
function removeit(){
	if (editIndex == undefined){return;}
	$.messager.confirm('提示', '您确认要删除此列吗？', function(r){
		if (r){
			$('#dg').datagrid('cancelEdit', editIndex)
					.datagrid('deleteRow', editIndex);
			editIndex = undefined;
		}
	});
}
// 确认
function accept(){
	$("#form2").form('validate');
	if (endEditing()){
		$('#dg').datagrid('acceptChanges');
		$.messager.alert('提示',"请继续点击“保存”按钮进行映射关系保存操作");
	}
}
function reject(){
	if (editIndex == undefined){
		$.messager.alert('提示',"请选择一条记录");
		return;}
	$('#dg').datagrid('rejectChanges');
	editIndex = undefined;
}

function comboboxChanged(record){
	if(record.fieldtypeid != "date"){
		var ed_issplit = $('#dg').datagrid('getEditor', {index: editIndex,field:'issplit'});
		$(ed_issplit.target).removeAttr('checked');
		$(ed_issplit.target).attr('disabled','disabled');
	}else{
		var ed_issplit = $('#dg').datagrid('getEditor', {index: editIndex,field:'issplit'});
		$(ed_issplit.target).removeAttr('disabled');
	}
}

function checkboxChanged(){
	var ed_fieldtypeid = $('#dg').datagrid('getEditor', {index: editIndex,field:'fieldtypeid'});
	if(ed_fieldtypeid.oldHtml != 'date'){
		var ed_issplit = $('#dg').datagrid('getEditor', {index: editIndex,field:'issplit'});
		$(ed_issplit.target).removeAttr('checked');
		$(ed_issplit.target).attr('disabled','disabled');
	}else{
		var ed_issplit = $('#dg').datagrid('getEditor', {index: editIndex,field:'issplit'});
		$(ed_issplit.target).removeAttr('disabled');
	}
}

// 定义 Column 列对象
var Column = function(id, tempcolumnid, albtpcolumnid, fieldtypeid, issplit,isjoin,isonly){
	this.id = id || '';
	this.tempcolumnid = tempcolumnid || '';
	this.albtpcolumnid = albtpcolumnid || '';
	this.fieldtypeid = fieldtypeid || '';
    this.issplit = issplit || '' ;
    this.isjoin = isjoin || '' ;
    this.isonly = isonly || '' ;
    return {id: this.id, tempcolumnid: this.tempcolumnid, albtpcolumnid: this.albtpcolumnid, fieldtypeid: 'varchar', issplit: this.issplit, isjoin: this.isjoin, isonly: isonly};
};
// 构建 json 格式数据
function bulidColumns(rows){
	var columns = new Array();
	for(var i = 0; i < rows.length; i++){
		var column = new Column(rows[i].id, rows[i].tempcolumnid, rows[i].albtpcolumnid, rows[i].fieldtypeid, rows[i].issplit,rows[i].isjoin,rows[i].isonly);
		columns.push(column);
	}
	return JSON.stringify(columns);
}

</script>
<body style="height:450px" onload="">
	<input type="hidden" id="tempTableName" value="${tempTableName }" />
	<div>
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
				<li><%=request.getAttribute("path") %></li>
				</ul>
			</div>
	<table id="dg_search"></table>
	<div style="padding: 2px;"></div>
	<form id="form2">
	<table id="dg"></table>
	</form>
	</div>
	<div id="showOrhide">
	<div id="tb">
		<div style="padding:5px;height:auto">
			临时库表：
			<input id="tempEntityTableId" class="easyui-combobox" data-options="disabled: true" />
			原始库表：
			<input id="albtEntityTableId" class="easyui-combobox" data-options="disabled: true" />
        </div>
		<div style="padding:3px;height:auto">
			<a id="addId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">新增</a>
			<a id="delId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">删除</a>
			<a id="sureId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="accept()">确定</a>
			<a id="cancelId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true" onclick="reject()">撤销</a>
			<a id="saveId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="submitSave()">保存</a>
		</div>
	</div>
	<div id="tb_search" style="padding:5px;height:auto">
		<input type="hidden" id="tableType" value="1" />	<!--  -->
		<input type="radio" name="tableType_search" value="1" id="tabletypes" checked="checked" onclick="javascript: $('#tableType').val(1);" />临时表
		<input type="radio" name="tableType_search" value="2" onclick="javascript: $('#tableType').val(2);"/>原始表&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
		检索表名称：<input id="tableName_search" class="validatebox" />
		<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-search"  onclick="tableMappingSearch();">查询</a>
	</div>
	</div>
</body>
</html>