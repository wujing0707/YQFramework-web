<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles1.css" />
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
<title>异议申诉</title>
<script type="text/javascript">
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


	$(function() {
		$("#dg").datagrid({
			//title: '信息分类',
			height : 360,
			striped : true,
			rownumbers : true,
			checkOnSelect : false,
			pagination : true,
			singleSelect : true,
			toolbar : '#tb',
			iconCls : 'icon-user',
			url : "${pageContext.request.contextPath}/complain/queryComplains.action?UTYPE=${type}&IDCODE=${idnumber}",
			loadMsg : "载入中...请等待.",
			onLoadSuccess : function () {
				$(this).datagrid("fixRownumber");
			},
			columns : [ [
				{
					field : "dataaccessName",
					title : "权限名称",
					width : 430,
					align : 'left'
				},
				{
					field : "createUser",
					title : "创建者",
					width : 100,
					align : 'left'
				},
				{
					field : "createTime",
					title : "创建日期",
					width : 150,
					align : 'left'
				},
				{
					field : "updateUser",
					title : "最后更新者",
					width : 100,
					align : 'left'
				},
				{
					field : "updateTime",
					title : "最后更新日期",
					width : 150,
					align : 'left'
				},
				{
					field : "opr",
					title : "操作",
					width : 100,
					align : 'left',
					formatter : function(value, row, index) {
						return "<a href='#' class='tablelink' style='color:blue' onclick='showQueryTip(&#039;"
							+ row.dataaccessId
							+ "&#039;)'>"
							+ "权限配置 "
							+ "</a>";
					}
				} ] ]});
	});
	/*
	 function showQueryTip(id){
	 $('#accessId').val(id);
	 $('#accessTree').tree("options").url = "${pageContext.request.contextPath}/dataaccess/getAccessTree.action?accessId=" + id;
	 $('#accessTree').tree("reload");
	 $('#accessEdit').window('open');
	 }
	 */

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
	
	function showQueryTip(id) {
		$("#ZddgSel").datagrid('options').queryParams = {};
		clearSearchSel();
		$('#winZdHandle').window('open');
		$('#infoId').val(id);
		$("#Zddg")
				.datagrid(
						{
							height : 350,
							striped : true,
							rownumbers : true,
							pagination : true,
							toolbar : '#zd',
							iconCls : 'icon-user',
							url : "${pageContext.request.contextPath}/dataaccess/getExistInfoList.action?id="
									+ id,
							loadMsg : "载入中...请等待.",
							columns : [ [
									{
										field : "ck",
										checkbox : true,
										width : 50
									},
									{
										field : "codedesc",
										title : "大分类名称",
										width : 130,
										align : 'center',
										editor : {
											type : 'text'
										}
									},
									{
										field : "servicename",
										title : "小分类名称",
										width : 130,
										align : 'center',
										editor : {
											type : 'text'
										}
									},
									{
										field : "entityname",
										title : "实体名",
										width : 160,
										align : 'center',
										editor : {
											type : 'text'
										}
									},
									{
										field : "opr",
										title : "操作",
										width : 100,
										align : 'left',
										formatter : function(value, row, index) {
											return "<a href='#' class='tablelink' style='color:blue' onclick='openZdSet(&#039;"
													+ row.id
													+ "&#039;,&#039;"
													+ row.entityname
													+ "&#039;)'>"
													+ "字段配置 "
													+ "</a>";
										}
									} ] ],
							onLoadSuccess : function(data) {
								if (data.total == 0) {
									var body = $(this).data().datagrid.dc.body2;
									body.find('table tbody').append(
											"<tr height='25px'><td width='"
													+ body.width()
													+ "'>暂未添加数据权限！</td></tr>");
								}
							}
						});
	}

	function openSel() {
		$('#winZdHandleSel').window('open');
		$("#ZddgSel")
				.datagrid(
						{
							height : 350,
							striped : true,
							rownumbers : true,
							pagination : true,
							toolbar : '#sel',
							iconCls : 'icon-user',
							url : "${pageContext.request.contextPath}/dataaccess/diclist.action?id="
									+ $('#infoId').val(),
							loadMsg : "载入中...请等待.",
							columns : [ [ {
								field : "ck",
								checkbox : true,
								width : 50
							},{
								field : "codedesc",
								title : "大分类名称",
								width : 130,
								align : 'center',
								editor : {
								type : 'text'
							}
							}, {
								field : "servicename",
								title : "小分类名称",
								width : 162,
								align : 'center',
								editor : {
									type : 'text'
								}
							}, {
								field : "entityname",
								title : "实体名",
								width : 200,
								align : 'center',
								editor : {
									type : 'text'
								}
							}] ]

						});
	}

	//字段配置页面
	function openZdSet(id, tableName) {
		$('#tableName').val(tableName);
		$('#winZdSet').window('open');
		$("#zdSet")
				.datagrid(
						{
							height : 350,
							striped : true,
							rownumbers : true,
							pagination : false,
							iconCls : 'icon-user',
							url : "${pageContext.request.contextPath}/dataaccess/getZdlistByName.action?name="
									+ tableName,
							loadMsg : "载入中...请等待.",
							columns : [ [ {
								field : "ck",
								checkbox : true,
								width : 50
							}, {
								field : "field",
								title : "字段",
								width : 130,
								align : 'left'
							}, {
								field : "fieldname",
								title : "字段名称",
								width : 160,
								align : 'left',
								formatter : function(value) {return "<span title='"+value+"'>"+value+"</span>";}
							}, {
								field : "deptfrom",
								title : "字段来源部门",
								width : 190,
								align : 'left',
								formatter : function(value) {return "<span title='"+value+"'>"+value+"</span>";}
							} ] ],
							onLoadSuccess : function(data) {
								$.post("getCheckedList.action?dataaccessId="
										+ $('#infoId').val() + "&tableName="
										+ tableName, {}, function(data) {
									if (data != null) {
										var rows = $("#zdSet").datagrid('getRows');
										var data = eval('(' + data + ')');
										var info = data.rows.toString();
  										for (var i = 0; i < rows.length; i++) {  
        									if (info.indexOf(rows[i]['field']) != -1) { 
        									 $("#zdSet").datagrid("selectRow", i);
       				 		}  
   						} 
									}
								});
							}

						});
	}

	function newAccess() {
		$('#fm').form('clear');
		$('#dlg').dialog('open').dialog('setTitle', '新增权限');
	}

	function newtable() {
		$('#dictionaryname').val('');
		$('#dictionarynum').val('');
		$('#dicdlg').dialog('open').dialog('setTitle', '新增字典信息');
	}
	//添加   
	function submitForm() {
		//非空验证
		if ($("#accessnameAdd").val() == "") {
			$.messager.alert('提示', "权限名称不能为空！");
			return;
		}
		addAccess();
	}

	function addAccess() {
		$('#fm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '新增权限失败，权限名称不能重复!', 'error');
				} else {
					$('#dg').datagrid('reload');
					$('#dlg').dialog('close');
				}
			}
		});
	}

	function getSelectionsIds() {
		var checkItems = $('#dg').datagrid('getSelections');
		var ids = "";
		$.each(checkItems, function(index, item) {
			ids += item.dataaccessId + ",";
		});
		ids = ids.substring(0, ids.length - 1);
		return ids;
	}

	//删除
	function destroyUser() {
		var ids = getSelectionsIds();
		if (ids.length <= 0) {
			$.messager.alert('提示', '请选择要删除的内容!', 'warning');
			return;
		}
		if (ids.length != 0) {
			$.messager
					.confirm(
							"提示",
							"确认删除该权限吗？",
							function(r) {
								if (r) {
									$
											.post(
													"${pageContext.request.contextPath}/dataaccess/a_removeList.action",
													{
														"ids" : ids
													},
													function(data) {
														if (data.result == true) {
															$.messager
																	.alert(
																			'提示',
																			"数据权限删除成功！",
																			"info",
																			function() {
																				$(
																						'#dg')
																						.datagrid(
																								'reload');
																			});
														} else if (data.result == false) {
															$.messager
																	.alert(
																			'提示',
																			"数据权限删除失败！已有角色关联该权限！");
														}
													}, "json");
								}
							});
		}
	}
	//点击修改的按钮
	function editUser() {
		var node = $('#dg').datagrid('getSelected');
		if (node != null) {
			$('#id').val(node.dataaccessId);
			$('#servicenameEdi').val(getHtmlInfo(node.dataaccessName));
			$.parser.parse('#winEdit'); 
			$('#winEdit').window('open');
		} else {
			$.messager.alert('选择', '请先选择要编辑的信息!', 'info');
		}
	}

	//点击修改保存
	function editSubmit() {
		$('#editForm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '权限名称不能重复!', 'error');
				} else {
					$('#dg').datagrid('reload');
					$('#winEdit').dialog('close');
				}

			}
		});
	}
	
	 function setFirstPage(ids){
    var opts = $(ids).datagrid('options');
var pager = $(ids).datagrid('getPager');
opts.pageNumber = 1;
    opts.pageSize = opts.pageSize;
pager.pagination('refresh',{
	    	pageNumber:1,
	    	pageSize:opts.pageSize
	});
}
	//查询
	function conditionSearch() {
		setFirstPage("#dg");
		var orgName = $.trim($('#accessSch').val());
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams["accessName"] = orgName;
		$('#dg').datagrid('options').queryParams = queryParams;
		$('#dg').datagrid('reload');
	}

	
	
	
	
</script>
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
	<div class="padT23">
	
		
		<table id="dg"></table>
	</div>
	<!-- 弹出的新增窗口 -->
	<div id="dlg" class="easyui-dialog"
		style="width:400px;height:180px;padding:10px 20px" closed="true"
		buttons="#dlg-buttons">

		<form id="fm" method="post" action="add.action">

			<div class="fitem">
				<label>权限名称:</label> <input name="accessnameAdd"
					class="easyui-validatebox"
					data-options="required:true,validType:'length[0,15]'"
					id="accessnameAdd" maxlength="15">
			</div>
		</form>
	</div>
	

	
</body>
</html>