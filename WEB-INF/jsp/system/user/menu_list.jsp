<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/WaFramework.tld" prefix="wf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String basePath = request.getScheme() + "://" + request.getServerName() 
			+ ":" + request.getServerPort() + request.getContextPath() + "/";
	pageContext.setAttribute("basePath", basePath);
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>系统菜单管理</title>
	 <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    
     <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script> 
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
</head>
<body>
	<script type="text/javascript">

		var parentIdForSch;

		$.extend($.fn.validatebox.defaults.rules, {
			intValidate : { // 验证正整数
				validator : function(value) {

					if (value.length >= 10) {

						return false;
					}

					return /^[1-9]\d*$/.test(value);
				},
				message : '请输入大于0的正整数,内容长度小于10'
			}
		});

		$(function() {
			$('#menuTree').tree("options").url = "../menu/tree.action";
			$('#menuTree').tree("reload");
			$('#menuTree').tree({
				onSelect : function(node) {
					//if ($('#menuTree').tree('isLeaf', node.target)) {
					//alert(node.target);
					//setPlace(node);
					conditionSearch(node.id);
					//}
				},
				onContextMenu : function(e, node) {
					e.preventDefault();
					$(this).tree('select', node.target);
					$('#mm').menu('show', {
						left : e.pageX,
						top : e.pageY
					});
				}
			});

			//         var p = $('#menuGrid').datagrid('getPager');  
			//         $(p).pagination({  
			//             pageSize: 10, // 每页显示的记录条数，默认为10  
			//             pageList: [5, 10, 12, 15], // 可以设置每页记录条数的列表  
			//             beforePageText: '第', // 页数文本框前显示的汉字  
			//             afterPageText: '页    共 {pages} 页',  
			//             displayMsg: '显示 {from} - {to}    共 {total} 条记录'
			//         });

		});
		
		function getHtmlInfo(s){
	s = s.replace(/&amp;/g, "&");  
    s = s.replace(/&nbsp;/g, " ");  
    s = s.replace(/&#39;/g, "'");          
    s = s.replace(/&lt;/g, "<");  
    s = s.replace(/&gt;/g, ">");  
    s = s.replace(/"<br>"/g, "\n");  
    s = s.replace(/"?D"/g, "—");  
    s = s.replace(/&quot;/g, "\"");  
    return s;  
	}

		
		function setFirstPage(ids) {
			var opts = $(ids).datagrid('options');
			var pager = $(ids).datagrid('getPager');
			opts.pageNumber = 1;
			opts.pageSize = opts.pageSize;
			pager.pagination('refresh', {
				pageNumber : 1,
				pageSize : opts.pageSize
			});
		}

		function conditionSearch(parentId) {
			setFirstPage("#menuGrid");
			$('#cdName').val('');
			parentIdForSch = parentId;
			var queryParams = $('#menuGrid').datagrid('options').queryParams;
			queryParams["parentId"] = parentId;
			queryParams["cdName"] = "";
			$('#menuGrid').datagrid('options').queryParams = queryParams;
			$('#menuGrid').datagrid('options').pageNumber = 1;
			$('#menuGrid').datagrid('getPager').pagination({
				pageNumber : 1
			});
			$("#menuGrid").datagrid('reload');
		}

		function onAddMenu() {
			var node = $('#menuTree').tree('getSelected');
			if (node != null) {
				$('#menuAddForm').form("clear");
				$('#parentId').val(node.id);
				$('#currentName').textbox('setValue', node.text);
				$('#menuAddForm').form('validate');
				$('#winAdd').window('open');
			} else {
				$.messager.alert('选择', '请先在左边的树中选择菜单节点!', 'warning');
			}
		}

		function addMenu() {
			$('#menuAddForm').form('submit', {
				success : function(data) {
					var data = eval('(' + data + ')'); // change the JSON string to javascript object
					if (!data.result) {
						$.messager.alert('失败', data.message, 'error');
					} else {
						$.messager.alert('成功', data.message, 'info',function(){	
								$('#menuTree').tree("reload");
								conditionSearch("");
								$('#winAdd').dialog('close');});
					}
				}
			});
		}

		function onEditMenu() {
			var node = $('#menuGrid').datagrid('getSelected');
			if (node != null) {
				$('#id').val(node.id);
				$('#editParentId').val(node.parentId);
				$('#menuName').textbox('setValue', getHtmlInfo(node.menuName));
				$('#menuUrl').textbox('setValue', getHtmlInfo(node.menuUrl));
				$('#displayOrder').textbox('setValue', node.displayOrder);
				$('#menuEditForm').form('validate');
				$('#winEdit').window('open');
			} else {
				$.messager.alert('选择', '请在列表中选择要编辑的菜单项!', 'warning');
			}
		}

		function editMenu() {
			$('#menuEditForm').form('submit', {
				success : function(data) {
					var data = eval('(' + data + ')'); // change the JSON string to javascript object
					if (!data.result) {
						$.messager.alert('失败', data.message, 'error');
					} else {
						$.messager.alert('成功', data.message, 'info');
						$('#menuTree').tree("reload");
						$("#menuGrid").datagrid('reload');
						$('#winEdit').dialog('close');
					}
				}
			});
		}

		function deleteMenu() {
			var node = $('#menuTree').tree('getSelected');
			var gridNode = $('#menuGrid').datagrid('getSelected');
			if (node != null) {
				$.messager.confirm('确定删除', '删除此菜单会删除该菜单下的所有子菜单, 确认要删除此菜单吗?',
						function(r) {
							if (r) {
								$.post("deleteMenu.action", {
									id : node.id
								}, function(data) {
									var data = eval('(' + data + ')'); // change the JSON string to javascript object
									if (!data.result) {
										$.messager.alert('失败', data.message,
												'error');
									} else {
										$.messager.alert('成功', data.message,
												'info');
									}
									$('#menuTree').tree("reload");
									conditionSearch("");
								});
							}
						});
			} else if (gridNode != null) {
				$.messager.confirm('确定删除', '删除此菜单会删除该菜单下的所有子菜单, 确认要删除此菜单吗?',
						function(r) {
							if (r) {
								$.post("deleteMenu.action", {
									id : gridNode.id
								}, function(data) {
									var data = eval('(' + data + ')'); // change the JSON string to javascript object
									if (!data.result) {
										$.messager.alert('失败', data.message,
												'error');
									} else {
										$.messager.alert('成功', data.message,
												'info');
									}
									$('#menuTree').tree("reload");
									conditionSearch("");
								});
							}
						});
			} else {
				$.messager.alert('选择', '请先在左边的树中选择菜单节点!', 'warning');
			}
		}

		function conditionSearch1() {
			setFirstPage("#menuGrid");
			var name = $.trim($('#cdName').val());
			var queryParams = $('#menuGrid').datagrid('options').queryParams;
			queryParams["cdName"] = name;
			//queryParams["parentId"] = parentIdForSch;
			$('#menuGrid').datagrid('options').queryParams = queryParams;
			$("#menuGrid").datagrid('reload');
		}
		function conditionReset() {
			$('#cdName').val('');
		}
	</script>
	<div>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
		<div id="layoutzone" class="easyui-layout"
			style="width:100%; height:420px;">
			<div id="westzone"
				data-options="region:'west', split:true, title:'菜单树', iconCls:'globe'"
				style="width:20%;">
				<div id="menuTree" class="easyui-tree" style="margin: 10px"
					data-options="lines:true, animate:true, method:'post'"></div>
			</div>
			<div id="mainzone"
				data-options="region:'center', title:'菜单列表', iconCls:'icon-document'">

				<table id="menuGrid" class="easyui-datagrid"
					data-options="url:'list.action', 
                rownumbers:true, pagination:true, method:'post', toolbar:'#tb', border:false,  
                singleSelect:true, pageSize:10, fit:true, fitColumns:true">
					<thead>
						<tr>
							<th data-options="field:'menuName',align:'center'" width="80">菜单名称</th>
							<th data-options="field:'menuUrl',align:'center'" width="150">菜单URL</th>
							<th data-options="field:'displayOrder',align:'center'" width="60">优先级</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
	</div>
	<div id="tb" style="padding:5px;height:auto">
		<div style="margin-bottom:5px">
			<a  href="#" class="easyui-linkbutton" onclick="onAddMenu();" iconCls='icon-add'>新增子菜单</a>
			<a  href="#" class="easyui-linkbutton" onclick="onEditMenu();" iconCls='icon-edit'>编辑菜单</a>
			<a  href="#" class="easyui-linkbutton" onclick="deleteMenu();" iconCls='icon-remove'>删除菜单</a>
			<div style="float: right;">
				菜单名称：<input id="cdName" class="easyui-input" style="width:120px">&nbsp;&nbsp;
				<a href="#" class="easyui-linkbutton" iconCls="icon-search"
					onclick="conditionSearch1();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="conditionReset();">重置</a>
			</div>
		</div>

	</div>

	<style>
.easyui-textbox {
	width: 200px;
}

html,body {
	text-align: center;
	margin: 0px auto;
}

form {
	padding: 10px;
	margin: 10px;
}
</style>
	<div id="winAdd" class="easyui-window" title="新增子菜单"
		data-options="modal:true, iconCls:'icon-edit',left:'25%', top:'10%', closed:true, tools:'#editTool'"
		style="width: 370px; height: 280px; padding: 10px;">
		<form id="menuAddForm" method="post" action="addMenu.action">
			<input type="hidden" name="parentId" id="parentId"></input>
			<table>
				<tr>
					<td height="30px">父菜单名称:</td>
					<td><input class="easyui-textbox" id="currentName"
						name="currentName" data-options="readonly:true"></input>
					</td>
				</tr>
				<tr>
					<td height="30px">子菜单名称:</td>
					<td><input class="easyui-textbox" name="menuName"
						data-options="required:true,validType:'length[0,30]'"></input>
					</td>
				</tr>
				<tr>
					<td height="30px">子菜单URL:</td>
					<td><input class="easyui-textbox" name="menuUrl"
						data-options="required:false,validType:'length[0,100]'"></input>
					</td>
				</tr>
				<tr>
					<td height="30px">排列优先级:</td>
					<td><input class="easyui-textbox" name="displayOrder"
						data-options="required:true,validType:'intValidate'"></input>
					</td>
				</tr>
			</table>
		</form>
		<div id="addTool">
			<a href="javascript:void(0)" class="icon-save" onclick="addMenu()"
				title="新增菜单"></a>
		</div>
		<div id="add-buttons" style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="addMenu()">确定</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#winAdd').window('close');"
				style="width:66px">取消</a>
		</div>
	</div>

	<div id="winEdit" class="easyui-window" title="编辑菜单"
		data-options="modal:true, iconCls:'icon-edit',left:'25%', top:'10%', closed:true, tools:'#editTool'"
		style="width: 350px; height: 270px; padding: 10px;">
		<form id="menuEditForm" method="post" action="editMenu.action">
			<input type="hidden" name="id" id="id"></input> <input type="hidden"
				name="parentId" id="editParentId"></input>
			<table>
				<tr>
					<td height="30px">菜单名称:</td>
					<td><input class="easyui-textbox" id="menuName"
						name="menuName"
						data-options="required:true,validType:'length[0,30]'"></input>
					</td>
				</tr>
				<tr>
					<td height="30px">菜单URL:</td>
					<td><input class="easyui-textbox" id="menuUrl" name="menuUrl"
						data-options="required:false,validType:'length[0,100]'"></input>
					</td>
				</tr>
				<tr>
					<td height="30px">排列优先级:</td>
					<td><input class="easyui-textbox" id="displayOrder"
						name="displayOrder"
						data-options="required:true,validType:'intValidate'"></input>
					</td>
				</tr>
			</table>
		</form>
<!-- 		<div id="editTool">
			<a href="javascript:void(0)" class="icon-save" onclick="editMenu()"
				title="保存菜单"></a>
		</div> -->
		<div id="edit-buttons" style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="editMenu()">确定</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#winEdit').window('close');"
				style="width:66px">取消</a>
		</div>
		<div id="mm" class="easyui-menu" style="width:120px;">
			<div onclick="onAddMenu()" data-options="iconCls:'icon-add'">新增子菜单</div>
			<div onclick="deleteMenu()" data-options="iconCls:'icon-remove'">删除菜单</div>
		</div>
</body>
</html>