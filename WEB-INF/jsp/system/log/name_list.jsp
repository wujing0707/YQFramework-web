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
	<title>日志管理</title>
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
</head>
<body>
<div style="margin:10px 10px;"></div>
	<table id="nameGrid" title="nameMap管理" class="easyui-datagrid" 
			style="height:380px" width="100%"
	 		data-options="rownumbers:true, pagination:true, 
	 		singleSelect:true, collapsible:true, fitColumns:true, 
	 		pageSize:10, url:'nameList.action', method:'get', 
	 		iconCls:'icon-blank', toolbar:'#tb'">
        <thead>
            <tr>
                <th field="id" hidden="true">id</th>
                <th field="mapName" width="80">name</th>
                <th field="mapUrl"  width="120">url</th>
                <th field="recordParam" formatter="recParFormat" width="80" align="right">记录参数</th>
            </tr>
        </thead>
    </table>
    <div id="tb" style="padding:5px;height:auto">
        <div style="margin-bottom:5px">
            <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="onAddName();">新增</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="onEditName();">编辑</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteConfirm();">删除</a>
            <input id="conditionMapName" class="easyui-input" style="width:80px">
            <input id="conditionMapUrl" class="easyui-input" style="width:80px">
            <a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">Search</a>
        </div>
    </div>
	<script type="text/javascript">
		var dvalueMapName = "name";
		var dvalueMapUrl = "url";
		jQuery(function(){
			$("#conditionMapName").autoTip({dvalue:dvalueMapName});
			$("#conditionMapUrl").autoTip({dvalue:dvalueMapUrl});
		});
	
		function onAddName(){
			$('#nameAddForm').form('clear');
			$('#recordParam').prop("checked", false);
			$('#winAdd').window('open');
		}
		
		function addName(){
        	$('#nameAddForm').form('submit', {
        	    success: function(data){
        	    	data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.success){
        	        	$.messager.alert('失败',data.message,'error');
        	        	return;
        	        }
        	        $('#nameGrid').datagrid('reload');
        	        $('#winAdd').dialog('close');
        	    }
        	});
        }
		
		function onEditName(){
			var node = $('#nameGrid').datagrid('getSelected');
			if(node == null){
				$.messager.alert('选择','请先选择要编辑的行!','info');
				return;
			}
			$.post('nameById.action',{id:node.id},function(data){
				if(!data){
					$.messager.alert('失败','系统异常','error');
					return;
				}
               	$('#nameId').val(node.id);
               	$('#mapName').val(data.mapName);
               	$('#mapUrl').val(data.mapUrl);
               	if(data.recordParam){
               		$('#recordPar').prop("checked", true);
               	}
				$('#winEdit').window('open');
			},'json');
		}
		
		function editName(){
        	$('#editNameForm').form('submit', {
        	    success: function(data){
        	        data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.success){
        	        	$.messager.alert('失败','编辑失败!','error');
        	        }
        	        $('#nameGrid').datagrid('reload');
        	        $('#winEdit').dialog('close');
        	    }
        	});
        }
		
		
        function deleteConfirm(){
        	var node = $('#nameGrid').datagrid('getSelected');
        	if(!node){
        		$.messager.alert('选择','请先选择要删除的行!','info');
        		return;
        	}
			$.messager.confirm('确定删除', '确认要删除吗?', function(r){
                if (r){
                	$.post("delete.action?id=" + node.id, {}, function(data){
                		data = eval('(' + data + ')');  // change the JSON string to javascript object
            	        if (!data.result){
            	        	$.messager.alert('失败','删除失败!','error');
            	        }
            	        $('#nameGrid').datagrid('reload');
                	});
                }
            });
		}
        
        
		function recParFormat(value, row, index){
			if (value){
				return "是";
			} else {
				return "否";
			}
		}
		
        function conditionSearch(){
        	var mapName = $.trim($('#conditionMapName').val());
        	var mapUrl = $.trim($('#conditionMapUrl').val());
        	var queryParams = $('#nameGrid').datagrid('options').queryParams; 
        	mapName = mapName==dvalueMapName?'':mapName;
        	mapUrl = mapUrl==dvalueMapUrl?'':mapUrl;
        	
        	queryParams["mapName"] = mapName;
        	queryParams["mapUrl"] = mapUrl;
            $('#nameGrid').datagrid('options').queryParams = queryParams;
            $("#nameGrid").datagrid('reload');
        }
    </script>
    
    <div id="winAdd" class="easyui-window" title="新增日志NameMap" data-options="iconCls:'icon-add', closed:true, border:false" style="width:500px;height:220px;padding:0px;">
        <form id="nameAddForm" method="post" action="add.action">
            <table style="padding: 10px;">
                <tr>
                    <td align="right">名称:</td>
                    <td><input class="easyui-validatebox" type="text" name="mapName" data-options="required:true" maxlength="40"></input></td>
                </tr>
                <tr>
                    <td align="right">url:</td>
                    <td><input class="easyui-validatebox" type="text" name="mapUrl" data-options="required:true" size="50" maxlength="100"></input></td>
                </tr>
                <tr>
                    <td align="right">记录参数:</td>
                    <td><input class="easyui-validatebox" type="checkbox" name="recordParam" id="recordParam" checked="checked" ></input></td>
                </tr>
            </table>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="addName()">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#winAdd').dialog('close');">取消</a>
        </div>
    </div>
    
    <div id="winEdit" class="easyui-window" title="编辑日志NameMap" data-options="iconCls:'icon-add', closed:true, border:false" style="width:500px;height:220px;padding:0px;">
        <form id="editNameForm" method="post" action="edit.action">
        	<input type="hidden" name="nameId" id="nameId" value="">
            <table style="padding: 10px;">
                 <tr>
                    <td align="right">名称:</td>
                    <td><input class="easyui-validatebox" type="text" name="mapName" id="mapName" data-options="required:true" maxlength="40"></input></td>
                </tr>
                <tr>
                    <td align="right">url:</td>
                    <td><input class="easyui-validatebox" type="text" name="mapUrl" id="mapUrl" data-options="required:true" size="50" maxlength="100"></input></td>
                </tr>
                <tr>
                    <td align="right">记录参数:</td>
                    <td><input class="easyui-validatebox" type="checkbox" name="recordParam" id="recordPar"></input></td>
                </tr>
            </table>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="editName()">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#winEdit').dialog('close');">取消</a>
        </div>
    </div>
    
</body>
</html>