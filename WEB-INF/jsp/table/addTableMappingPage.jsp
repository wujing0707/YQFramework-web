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
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/autocomplete.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/json2.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.autocomplete.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/browser.js"></script>
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

var tempTableName = '';
var albtTableName = '';
function initDataGrid(){
	$('#dg').datagrid({
		//title: '【添加映射】——原始数据转标准数据关系映射',
		height: 360,
		singleSelect: true,
		toolbar: '#tb',
		method: 'post',
		onClickRow: onClickRow,
		 onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
				    },
		//url: '${pageContext.request.contextPath}/front/table/findByIdOfEditing.action?tableId='+tableId,
		columns: [[{
			title: '临时表字段',
			field:'tempcolumnid',width:270,align:'center',
			editor:{
				type:'combobox',
				options:{
					valueField:'tempColumnId',
					textField:'tempColumnName',
					url:'${pageContext.request.contextPath}/system/table/tempEntityColumns.action?tableName='+tempTableName,
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
					url:'${pageContext.request.contextPath}/system/table/albtEntityColumns.action?tableName='+albtTableName,
					required:true,
					editable: false
				}
			}
		},
		{
			title: '是否为联合唯一键',
			field:'isjoin',width:270,align:'center',editor:{type:'checkbox',options:{on:'是',off:'否'}}
		}
		]]
	});
}
	$(function(){
		initDataGrid();
		/*
		$('#tempEntityTableId').combobox({
			//editable : false,
			panelHeight: 200,
			mode: 'remote',
			valueField: 'tableId',
			textField: 'tableName',
			url: '${pageContext.request.contextPath}/system/table/tempEntityTables.action',
			onSelect: function(rec){
				//console.info(rec);
				var rows = $('#dg').datagrid('getRows');
				if(rows.length > 0){
					//console.info("datagrid 有数据");
					while(rows.length > 0)
						$('#dg').datagrid('deleteRow', 0);		// 因为删除 datagrid 数据后，行数会发生变化，所以删除 id 永远为 0 ，直到全部删除
				}else{
					//console.info("datagrid 无数据");
				}
				if(hasMapped(rec.tableId, "1")){
					$.messager.alert("提示", "此表已增加关系映射，请去“去重规则管理”菜单进行维护");
					$('#tempEntityTableId').combobox("setValue", "");
					tempTableName = '';
				}else{
					tempTableName = rec.tableId;
				}
				initDataGrid();
			}
		});
		
		
		$('#albtEntityTableId').combobox({
			editable : false,
			panelHeight: 200,
			mode: 'remote',
			valueField: 'tableId',
			textField: 'tableName',
			url: '${pageContext.request.contextPath}/system/table/albtEntityTables.action',
			onSelect: function(rec){
				//console.info(rec);
				var rows = $('#dg').datagrid('getRows');
				if(rows.length > 0){
					//console.info("datagrid 有数据");
					while(rows.length > 0)
						$('#dg').datagrid('deleteRow', 0);		// 因为删除 datagrid 数据后，行数会发生变化，所以删除 id 永远为 0 ，直到全部删除
				}else{
					//console.info("datagrid 无数据");
				}
				if(hasMapped(rec.tableId, "2")){
					$.messager.alert("提示", "此表已增加关系映射，请去“去重规则管理”菜单进行维护");
					$('#albtEntityTableId').combobox("setValue", "");
					albtTableName = '';
				}else{
					albtTableName = rec.tableId;
				}
				initDataGrid();
			}
		});
		*/
		
		var lsurl = '${pageContext.request.contextPath}/system/table/tempEntityTables.action';
        $("#tempEntityTableId").autocomplete(lsurl,{
              minChars: 0,//自动完成激活之前填入的最小字符
              max:300,//列表条目数
              width: 300,//提示的宽度
              scrollHeight: 300,//提示的高度
              matchContains: true,//是否只要包含文本框里的就可以
              autoFill:false,//自动填充
              //需要把data转换成json数据格式                        
                        parse: function(data) {  
                           return $.map(eval(data), function(row) {  
                               return {  
                                data: row,  
                                value: row.tableName,
                                result: row.tableId   
                              }  
                        });  
                 }, 
              formatItem: function(data, i, max) {//格式化列表中的条目 row:条目对象,i:当前条目数,max:总条目数
				return data.tableName;
            },
            formatMatch: function(data, i, max) {//配合formatItem使用，作用在于，由于使用了formatItem，所以条目中的内容有所改变，而我们要匹配的是原始的数据，所以用formatMatch做一个调整，使之匹配原始数据
				return data.tableName;
            },
            formatResult: function(data) {//定义最终返回的数据，比如我们还是要返回原始数据，而不是formatItem过的数据
				return data.tableName;
            }
        }).result(function(event,data,formatted){
             if(hasMapped(data.tableId, "1")){
					$.messager.alert("提示", "此表已增加关系映射，请去“去重规则管理”菜单进行维护","info");
					$('#tempEntityTableId').val("");
					tempTableName = '';
				}else{
					$('#tempEntityTableId').val(data.tableName);
					tempTableName = data.tableId;
					$('#albtEntityTableId').val('BUS'+data.tableName.substring(1));
					albtTableName = $('#albtEntityTableId').val();
				}
				initDataGrid();
        });
        
        var ysurl = '${pageContext.request.contextPath}/system/table/albtEntityTables.action';
        $("#albtEntityTableId").autocomplete(ysurl,{
              minChars: 0,//自动完成激活之前填入的最小字符
              max:300,//列表条目数
              width: 300,//提示的宽度
              scrollHeight: 300,//提示的高度
              matchContains: true,//是否只要包含文本框里的就可以
              autoFill:false,//自动填充
              //需要把data转换成json数据格式                        
                        parse: function(data) {  
                           return $.map(eval(data), function(row) {  
                               return {  
                                data: row,  
                                value: row.tableName,
                                result: row.tableId   
                              }  
                        });  
                 }, 
              formatItem: function(data, i, max) {//格式化列表中的条目 row:条目对象,i:当前条目数,max:总条目数
				return data.tableName;
            },
            formatMatch: function(data, i, max) {//配合formatItem使用，作用在于，由于使用了formatItem，所以条目中的内容有所改变，而我们要匹配的是原始的数据，所以用formatMatch做一个调整，使之匹配原始数据
				return data.tableName;
            },
            formatResult: function(data) {//定义最终返回的数据，比如我们还是要返回原始数据，而不是formatItem过的数据
				return data.tableName;
            }
        }).result(function(event,data,formatted){
             if(hasMapped(data.tableId, "2")){
					$.messager.alert("提示", "此表已增加关系映射，请去“去重规则管理”菜单进行维护","info");
					$('#albtEntityTableId').val("");
					albtTableName='';
				}else{
					$('#albtEntityTableId').val(data.tableName);
					albtTableName = data.tableId;
					$('#tempEntityTableId').val('S'+data.tableName.substring(3));
					tempTableName = $('#tempEntityTableId').val();
				}
				initDataGrid();
        });
		
		
	});
	// 提交保存
	function submitSave(){
		if(editIndex != undefined){
			$.messager.alert('提示','请按‘确定’按钮后再保存！');
			return;
		}
		var tempcolumnids = new Array();
		var albtpcolumnids = new Array();
	/* 	var isspilts = new Array(); */
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
// 			isspilts.push(rows[i].issplit);
			isonlys.push(rows[i].isonly);
			isjoins.push(rows[i].isjoin);
		}
		var count = 0;
		// 只能有一个是拆分的
		/* for(var i = 0; i < isspilts.length; i++){
			if(isspilts[i] == '是'){
				count++;
			}
		} */
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
		if(count > 1){
			$.messager.alert('提示',"只能设置一个字段为拆分字段");
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
				$.messager.alert('提示',"原始表字段'"+nalbtpcolumnids[i]+"'有重复");				return ;
			}
		}
		// 将 datagrid 中的数据构建成 json 格式的数据
		var jsonColumns = bulidColumns(rows);
		
		//是否需要补全数据
		var iscompletion="";
		if($("#iscompletion").prop("checked")==true){
			iscompletion=1;
		}else{
			iscompletion=0;
		}
		
		// console.info(jsonColumns);
		// 灰掉，防止重复提交
		$("#saveId").linkbutton("disable");
		$("#addId").linkbutton("disable");
		$("#delId").linkbutton("disable");
		$("#cancelId").linkbutton("disable");
		$("#sureId").linkbutton("disable");
		$.post("${pageContext.request.contextPath}/system/tablemapping/addMappingRelation.action", {
				temptablename: tempTableName,
				albttablename: albtTableName,
				columns: jsonColumns,
				iscompletion:iscompletion,
				t: new Date()
			}, 
			function(data){
				if(data.result){
					$.messager.alert('提示', data.message, 'info', function(){
						window.location = "${pageContext.request.contextPath}/system/tablemapping/indexAddTableMapping.action";
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

function hasMapped(p_tableName, p_tableType){
	var flag = false;
	$.ajax({
		url: '${pageContext.request.contextPath}/system/tablemapping/queryTableByName.action',
		data: {
			tableName: p_tableName,
			tableType: p_tableType,
			t: new Date()
		},
		async: false,
		dataType: 'json',
		success: function(data){
			if(data.total > 0){
				flag = true;
			}
		}
	});
	return flag;
}
	

</script>
<script type="text/javascript">
var oldCount = 0;
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
	var tempEntityTableId = $('#tempEntityTableId').val();
	var albtEntityTableId = $('#albtEntityTableId').val();
	
	if(tempEntityTableId==""){
		
		$.messager.alert('提示',"请选择临时数据库表");
		return;
	}
	if(albtEntityTableId==""){
		$.messager.alert('提示',"请选择原始库数据库表");
		return;
	}
	if (endEditing()){
		$('#dg').datagrid('appendRow',{status:'P'});
		editIndex = $('#dg').datagrid('getRows').length-1;
		$('#dg').datagrid('selectRow', editIndex)
				.datagrid('beginEdit', editIndex);
	}
}
function removeit(){
	if (editIndex == undefined){
	$.messager.alert('提示',"请选择一条记录");
	return;}
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
	$("#form1").form('validate');
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
var Column = function(tempcolumnid, albtpcolumnid, fieldtypeid, issplit,isjoin,isonly){
	this.tempcolumnid = tempcolumnid || '';
	this.albtpcolumnid = albtpcolumnid || '';
	this.fieldtypeid = fieldtypeid || '';
    this.issplit = issplit || '' ;
    this.isjoin = isjoin || '' ;
    this.isonly = isonly || '' ;
    return {tempcolumnid: this.tempcolumnid, albtpcolumnid: this.albtpcolumnid, fieldtypeid: 'varchar', issplit: this.issplit, isjoin: this.isjoin, isonly: isonly};
};
// 构建 json 格式数据
function bulidColumns(rows){
	var columns = new Array();
	for(var i = 0; i < rows.length; i++){
		var column = new Column(rows[i].tempcolumnid, rows[i].albtpcolumnid, rows[i].fieldtypeid, rows[i].issplit,rows[i].isjoin,rows[i].isonly);
		columns.push(column);
	}
	return JSON.stringify(columns);
}

</script>
<body style="height:360px" onload="">
	<input type="hidden" id="tableId" value="${logicTableCode }" />
	<input type="hidden" id="tableName" value="${logicTableName }" />
	<div>
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
						<li><%=request.getAttribute("path") %></li>
				</ul>
			</div>
	<form id="form1">
	<table id="dg"></table>
	</form>
	</div>
	<div id="tb">
		<div style="padding:5px;height:auto">
			请选择临时库表：
			<input id="tempEntityTableId"  />
			请选择原始库表：
			<input id="albtEntityTableId"  />
        </div>
		<div style="padding:3px;height:auto">
			<a id="addId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">新增</a>
			<a id="delId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">删除</a>
			<a id="sureId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-check',plain:true" onclick="accept()">确定</a>
			<a id="cancelId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true" onclick="reject()">撤销</a>
			<a id="saveId" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="submitSave()">保存</a>
	<!-- 		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="getChanges()">获取修改内容</a> -->
		</div>
	</div>
	
</body>
</html>