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

<style type="text/css">
.easyui-input{
 	height: 22px; 
}
#winEditDIV label {
	float: left;
	width: 120px;
	font-size:12px;
}

#winEditDIV div {
	padding: 10px;
}

</style>
<script type="text/javascript">
    var data = [['1', '平台接入'], ['2', '对外开放']];  
    
    function ajaxLoading(){
    $("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body");
    $("<div class=\"datagrid-mask-msg\"></div>").html("正在加载，请稍候...").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
 	}
 	function ajaxLoadEnd(){
     $(".datagrid-mask").remove();
     $(".datagrid-mask-msg").remove();            
	} 
	function formatOper(value, rowData, index){ 
		var html =""; 
		if(rowData.status==0)
   		html += "<a href='javascript: updateStatus(\""+rowData.id+"\",\""+rowData.status+"\");' style='margin: 5px;'>启用</a>";
   		if(rowData.status==1)
   		html += "<a href='javascript: updateStatus(\""+rowData.id+"\",\""+rowData.status+"\");' style='margin: 5px;'>禁用</a>";
   		html += "<a href='javascript: openEditWin(\""+index+"\");' style='margin: 5px; color: blue;'>| 编辑</a>";
   		return html;
   		} 
   				
	function formatTitle(value){
		return "<span title='"+value+"'>"+value+"</span>";
	}
	function formatType(value){
				if(value==1){
			return "<span title='平台接入'>平台接入</span>";
		}
		if(value==2){
		return "<span title='对外开放'>对外开放</span>";}
	}
	function formatStatus(value){
		if(value==0){
			return "<span title='禁用'>禁用</span>";
		}
		if(value==1){
		return "<span title='启用'>启用</span>";}
	}

	function openAddWin(){
		 $("#select_type").combobox("loadData",data);
		// 部门拉框
		$('#select_depart').combobox({
			url : '${pageContext.request.contextPath}/interface/getDept.action' ,
			valueField : 'code',
			textField : 'value',
			multiple : false,
			required:true,
			panelHeight : '150',
			editable : false,
			onSelect:function(record){
				$('#select_username').combobox({
					url : '${pageContext.request.contextPath}/interface/getUserName.action?deptname=' + encodeURI(record.code),
					valueField : 'code',
					textField : 'value',
					multiple : false,
					required:true,
					panelHeight : 'auto',
					editable : false
				}).combobox('clear');

         }
		});
		//用户名下拉框
		$('#select_username').combobox({
			url : '${pageContext.request.contextPath}/interface/getUserName.action' ,
			valueField : 'code',
			textField : 'value',
			multiple : false,
			required:true,
			panelHeight : 'auto',
			editable : false,
			onSelect:function(record){
				$('#select_realname').combobox({
					url : '${pageContext.request.contextPath}/interface/getRealName.action?username=' + encodeURI(record.code),
					valueField : 'code',
					textField : 'value',
					multiple : false,
					panelHeight : 'auto',
					editable : false
				}).combobox('clear');
	
	     }
		});
		//真实姓名下拉框
		$('#select_realname').combobox({
			url : '${pageContext.request.contextPath}/interface/getRealName.action' ,
			valueField : 'code',
			textField : 'value',
			multiple : false,
			panelHeight : 'auto',
			editable : false
		});
		$("#form").form('clear');
		$('#winEditDIV').window('open');
	}
	
	function deleteInt(){
		var row = $("#dataGrid").datagrid('getSelected');
		if(!row){
			$.messager.alert("提示","请选择要删除的行!");
		}else{
			$.messager.confirm("确认", "确定删除此接口吗?", function (r) {
				if(r){
							$.ajax({
							type : 'POST',
							url : 'interface/delete.action',
							data:{id:row.id},
							error : function() {
										$.messager.alert("提示", "网络错误");
									},
							success : function(data, status) {
								var json = eval('(' + data + ')');
								if (json.success == true) 
									$.messager.alert("提示", json.msg,"info",function(){$('#dataGrid').datagrid("reload");});
					 			else 
									$.messager.alert("提示", json.msg);
								}
							});
				}else return null;
			 }); 
		}
	}
	
	function openEditWin(obj){
		 $("#form").form('reset');
		var obj1 = new Object();
		obj1 = $("#dataGrid").datagrid("getRows")[obj++]; 
		$("#form").form('load',obj1);
		$("#select_type").combobox("loadData",data);	
		$("#select_type").combobox('setValue',obj1.type);   
		// 部门拉框
		$('#select_depart').combobox({
			url : '${pageContext.request.contextPath}/interface/getDept.action' ,
			valueField : 'code',
			textField : 'value',
			multiple : false,
			required:true,
			panelHeight : '150',
			editable : false,
			onSelect:function(record){
				$('#select_username').combobox({
					url : '${pageContext.request.contextPath}/interface/getUserName.action?deptname=' + encodeURI(record.code),
					valueField : 'code',
					textField : 'value',
					multiple : false,
					required:true,
					panelHeight : 'auto',
					editable : false
				}).combobox('clear');

         }
		});
		//用户名下拉框
		$('#select_username').combobox({
			url : '${pageContext.request.contextPath}/interface/getUserName.action' ,
			valueField : 'code',
			textField : 'value',
			multiple : false,
			required:true,
			panelHeight : 'auto',
			editable : false,
			onSelect:function(record){
				$('#select_realname').combobox({
					url : '${pageContext.request.contextPath}/interface/getRealName.action?username=' + encodeURI(record.code),
					valueField : 'code',
					textField : 'value',
					multiple : false,
					required:true,
					panelHeight : 'auto',
					editable : false
				}).combobox('clear');
	
	     }
		});
		//真实姓名下拉框
		$('#select_realname').combobox({
			url : '${pageContext.request.contextPath}/interface/getRealName.action' ,
			valueField : 'code',
			textField : 'value',
			multiple : false,
			panelHeight : 'auto',
			editable : false
		});
		$("#select_depart").combobox('setValue',obj1.deptid);
		$("#select_username").combobox('setValue',obj1.username);
		$("#select_realname").combobox('setValue',obj1.password);
		$('#winEditDIV').window('open');
	}
	
	function updateStatus(id,st){
			 $.messager.confirm("确认", "确定该项操作吗?", function (r) {  
			 var rest = 0;
			 	if(st==0)
			 		rest=1;
			 if (r) {
       		  $.ajax({
				type : 'POST',
				url : '${pageContext.request.contextPath}/interface/updateStauts.action',
				data : {
					id : id,status:rest
				},
				error : function() {
					$.messager.alert("提示", "网络错误");
				},
				success : function(data, status) {
					var json = eval('(' + data + ')');
					if (json.success == true) {
						$.messager.alert("提示", json.msg,"info",function(){$('#dataGrid').datagrid("reload");});
					} else {
						$.messager.alert("提示", json.msg);
					}
				}
				});		
        } 
        else{
        return;
        }
    });  
	}

	function conditionSearch() {
		var queryParams = $('#dataGrid').datagrid('options').queryParams;
		queryParams.name = $("#nameID").val();
		queryParams.deptid = $("#select_dept").combobox('getValue');
		queryParams.type = $("#typeID").combobox('getValue');
		$('#dataGrid').datagrid('options').queryParams = queryParams;
    	$('#dataGrid').datagrid("load");
    	$('#dataGrid').datagrid("uncheckAll");
	}
	
	function conditionReset() {
		$("#queryFormID").form('reset');
	}

	function submit(){
	if(!$("#form").form("validate")){
	    	$.messager.alert("提示", '请正确填写信息!','info');
	    	return ;
	    }  
	var parmars =  $("#form").serialize();
	$.ajax({
                type: "post",
                url:'interface/saveOrUpdate.action',
                data:parmars,
                error: function() {
                    $.messager.alert("提示", '网络错误!');
                },
                success: function(data) {
                	var json = eval('(' + data + ')');
                    $.messager.alert("提示", json.msg,"info",function(){$('#winEditDIV').window('close');$('#dataGrid').datagrid("reload");});
                   
                }
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
			<div><a href="javascript:openAddWin();" class="easyui-linkbutton"
					iconCls="icon-add" plain="true">新增</a>
					<a href="javascript:deleteInt();" class="easyui-linkbutton"
					iconCls="icon-remove" plain="true">删除</a>
		<div style="float: right;">
			<form id="queryFormID">
				<label for="kind">接口名称:</label> <input class="easyui-textbox" name="name"  id="nameID"/>
				<label for="dept">请选择部门:</label> <input id="select_dept"
					class="easyui-combobox" name="dept" 
					url='interface/getDept.action' editable="false"
					data-options="valueField:'code', textField:'value',multiple:false">
				</input>
				<label for="kind">请选择接口类别:</label> <select class="easyui-combobox" id="typeID" name="type" editable="false" style="width:120px;">
				         		<option value="">--请选择--</option>
         						<option value="1">平台接入</option>
         						<option value="2">对外开放</option>
				</select>
			<a class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">查询</a>&nbsp;&nbsp; 
			<a class="easyui-linkbutton" iconCls="icon-refresh" onclick="conditionReset();">重置</a>
			</form>
		</div></div>
		
	</div>
		<div>
			<table id="dataGrid" class="easyui-datagrid" style="width:100%;height: 370px; padding: 5px" 
				data-options="rownumbers:true, pagination:true, singleSelect:true, collapsible:true, fitColumns:true, 
	 		url:'interface/list.action', method:'post', iconCls:'icon-user', toolbar:'#tb'">
				<thead>
					<tr>
						<th field="name"  width="15%" align="left" data-options="formatter:formatTitle">接口名称</th>
						<th field="type" width="10%" align="left" data-options="formatter:formatType">接口类型</th>
						<th field="deptname" width="15%" align="left" data-options="formatter:formatTitle">接口部门</th>
						<th field="ip" width="20%" align="left">接口IP</th>
						<th field="limitimes" width="10%" align="left" data-options="formatter:formatTitle">每日限制访问次数</th>
						<th field="status" width="10%" align="left" data-options="formatter:formatStatus">状态</th>					
						<th width="15%" data-options="field:'_operate',align:'center',formatter:formatOper">操作</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
	<div id="winEditDIV" class="easyui-dialog" title="接口管理"
		style="width:500px;height:400px;" closed="true"
		buttons="#edit-buttons">
		<form id="form" method="post" enctype="multipart/form-data">
			<div align="left">
				<label for="name">接口名称:</label> <input class="easyui-textbox"
					id="nameID" name="name"  style="width:180px;" data-options="required:true,validType:'length[0,50]'"></input>
			</div>
			<input style="display: none" name="id"/>
			<div align="left">
							<label for="limitimes1">所属部门:</label><input style="width:180px;" id="select_depart" name="deptid" />
			</div>
			<div align="left">
				<label for="ip">接口IP:</label> <input class="easyui-textbox"
					id="ip" name="ip" style="width:180px;" data-options="required:true,validType:'length[0,20]'"></input>
			</div>
 			<div align="left">
			    <label for="type">接口类型:</label>
				<input id="select_type"
					class="easyui-combobox" style="width:180px;" name="type"  data-options="valueField:0, textField:1,required:true"></input>
			</div> 
			<div align="left">
				<label for="limitimes">每日限制访问次数:</label> <input class="easyui-textbox" id="limitimes"
					name="limitimes"  style="width:180px;" data-options="required:true,validType:'length[0,50]'"></input>
			</div>
			<div align="left">
				<label for="limitimes2">用户名:</label><input style="width:180px;" id="select_username" name="username" />
			</div>
			<div align="left">
				<label for="limitimes3">真实姓名:</label><input style="width:180px;" id="select_realname" name="password" />
			</div>
		</form>
		<div id="edit-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-save" onclick="submit()" style="width:66px">提交</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#form').form('clear');$('#winEditDIV').dialog('close');"
				style="width:66px">取消</a>
		</div>
	</div>
</body>
</html>
