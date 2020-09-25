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
	href="${pageContext.request.contextPath}/css/styles.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
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
<title>信息分类</title>
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
		$("#dg")
				.datagrid(
						{
							//title: '信息分类',
							height : 360,
							striped : true,
							rownumbers : true,
							checkOnSelect : false,
							pagination : true,
							singleSelect : true,
							toolbar : '#tb',
							iconCls : 'icon-user',
							url : "${pageContext.request.contextPath}/infoclass/newlist.action",
							loadMsg : "载入中...请等待.",
							 onLoadSuccess : function () {
								 $(this).datagrid("fixRownumber");
								 $(this).datagrid("resize");
									 },
							columns : [ [
									{
										field : "codedesc",
										title : "大分类名称",
										width : 130,
										align : 'left',
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}
									},
									{
										field : "servicename",
										title : "小分类名称",
										width : 140,
										align : 'left',
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}
									},
									{
										field : "entityname",
										title : "实体名",
										width : 100,
										align : 'left',
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}
									},
									{
										field : "sfqiyong",
										title : "状态",
										width : 50,
										align : 'left',
										formatter : function(value) {
											if (value == 0)
												return '启用';
											else
												return '禁用';
										}
									},
									{
										field : "sortno",
										title : "排序",
										width : 50,
										align : 'left'
									},
									{
										field : "createuser",
										title : "创建者",
										width : 60,
										align : 'left'
									},
									{
										field : "createtime",
										title : "创建日期",
										width : 150,
										align : 'left'
									},
									{
										field : "updateuser",
										title : "最后更新者",
										width : 65,
										align : 'left'
									},
									{
										field : "updatetime",
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
											return "<a href='#' class='tablelink' style='font-size:12px;color:blue' onclick='showQueryTip(&#039;"
													+ row.id
													+ "&#039;)'>"
													+ "关联资源 " + "</a>";
										}
									} ] ]
						});
		$("#ENABLEDS").combobox({
			width : 130,
			editable : false,
			panelHeight : "auto",
			data : [ {
				value : '0',
				text : '启用'
			}, {
				value : '1',
				text : '禁用'
			} ],
			valueField : "value",
			textField : "text"

		});
	});

//归集部门下拉列表获取
var bumenURL = "${pageContext.request.contextPath}/system/guijixx/getDepartment.action";
jQuery(function(){
	$.getJSON(bumenURL, function(json) {
		$("#bmName").combobox({
			data : json.rows,
			valueField:'value',
			textField:'text'
		});
	});
});

//大分类获取
var urls = "${pageContext.request.contextPath}/dictionarys/getDropDownlist.action?field=infoclass";
		jQuery(function(){
		$.getJSON(urls, function(json) {
			$("#bigservicenameSch").combobox({
				data : json.rows,
				valueField:'value',
				textField:'text'
			});
		});
});

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

//选择资源页面查询
function conditionSearchSel(){
	setFirstPage("#ZddgSel");
	var gjxxmc = $.trim($('#conditionName').val());
	var codeId = $.trim($('#bmName').combobox('getValue'));
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams["bmName"] = codeId;
	queryParams["conditionName"] = gjxxmc;
    $("#ZddgSel").datagrid('options').queryParams = queryParams;
    $("#ZddgSel").datagrid('reload');
}
	
	//重置资源选择页面
	function clearSearchSel() {
		$('#conditionName').val('');
		$('#bmName').combobox('clear');
	}
	

	function saveSel() {
		var infoIds = getInfoSelectionsIds();
		if(infoIds.length == 0){
        		$.messager.alert('提示','至少选择一项资源进行关联!','warning');
        		return;
        	}
		$('#infoIdSel').val($('#infoId').val());
		$('#infoIds').val(infoIds);
		$('#infoAddForm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '关联失败!', 'error');
				} else {
					$.messager.alert('成功', '关联成功!', 'info',function(){
						$('#winZdHandleSel').window('close');
						$('#Zddg').datagrid('clearSelections');
						$('#Zddg').datagrid('reload');
					});
				}
			}
		});
	}
	
	function getHtmlInfo(s){
	s = s.replace(/&#92;/g, "\\"); 
	s = s.replace(/&amp;/g, "&");  
	s = s.replace("&quot;", "\"");  
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
		$('#winZdHandle').window({
    		modal:true
		});
		$('#winZdHandle').window('open');
		$('#infoId').val(id);
		$("#Zddg")
				.datagrid(
						{
							height : 345,
							striped : true,
							checkOnSelect : false,
							rownumbers : true,
							pagination : true,
							singleSelect : true,
							toolbar : '#zd',
							iconCls : 'icon-user',
							url : "${pageContext.request.contextPath}/infoclass/getExistInfoList.action?id="
									+ id,
							loadMsg : "载入中...请等待.",
							columns : [ [ {
								field : "codedesc",
								title : "归集部门",
								width : 142,
								align : 'center',
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}
							}, {
								field : "guijixinximingcheng",
								title : "归集信息名称",
								width : 142,
								align : 'center',
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}
							}, {
								field : "biaomingshiti",
								title : "实体名",
								width : 142,
								align : 'center',
								editor : {
									type : 'text'
								}
							},{
										field : "opr",
										title : "操作",
										width : 100,
										align : 'left',
										formatter : function(value, row, index) {
											return "<a href='#' class='tablelink' style='font-size:12px;color:blue' onclick='openZdSet(&#039;"
													+ id
													+ "&#039;,&#039;"
													+ row.id
													+ "&#039;)'>"
													+ "字段配置 "
													+ "</a>";
										}
									}] ],
							onLoadSuccess : function (data) {
								 $(this).datagrid("fixRownumber");
									    if (data.total == 0) {
									   		var body = $(this).data().datagrid.dc.body2; 
									    	body.find('table tbody').append("<tr height='25px'><td width='" + body.width() + "'>该信息分类暂未关联任何数据！</td></tr>");
									    }
									}
						});
	}

//字段配置页面
	function openZdSet(viewId,entityId) {
		$('#viewId').val(viewId);
		$('#entityId').val(entityId);
		$('#winZdSet').window({
    		modal:true
		});
		$('#winZdSet').window('open');
		$("#zdSet")
				.datagrid(
						{
							height : 350,
							striped : true,
							rownumbers : true,
							pagination : false,
							iconCls : 'icon-user',
							url : "${pageContext.request.contextPath}/infoclass/getZdlistByName.action?viewId="
									+ viewId+"&entityId="+entityId,
							loadMsg : "载入中...请等待.",
								
							columns : [ [ {
								field : "ck",
								checkbox : true,
								width : 50
							}, {
								field : "excelziduan",
								title : "字段",
								width : 130,
								align : 'left'
							}, {
								field : "ziduanming",
								title : "字段名称",
								width : 160,
								align : 'left',
								formatter : function(value) {return "<span title='"+value+"'>"+value+"</span>";}
							} , {
								field : "gjzdid",
								hidden: true
						   }] ],
							onLoadSuccess : function(data) {
								 $(this).datagrid("fixRownumber");
								$.post("getCheckedList.action?viewId="
									+ viewId+"&entityId="+entityId, {}, function(data) {
								
									if (data != null) {
										var rows = $("#zdSet").datagrid('getRows');
										var data = eval('(' + data + ')');
										var info = data.rows.toString();
										//var strs= new Array();
										//strs = info.split(",");
  										for (var i = 0; i < rows.length; i++) {  
  											
        									if (info.indexOf(rows[i]['gjzdid']) != -1) { 
        									 $("#zdSet").datagrid("selectRow", i);
       				 		}  
   						} 
									}
								});
							}
							

						});
	}
	
	function newUser() {
		$('#fm').form('clear');
		var urls = "${pageContext.request.contextPath}/dictionarys/getDropDownlist.action?field=infoclass";
		jQuery(function(){
		$.getJSON(urls, function(json) {
			$("#bigservicename").combobox({
				data : json.rows,
				valueField:'value',
				textField:'text'
			});
		});
		});
		$('#dlg').window({
    			modal:true
			});
		$('#dlg').dialog('open').dialog('setTitle', '新增信息分类信息');
		$("#ENABLEDS").combobox("setValue", "0");
	}

	function openSel() {
		$("#ZddgSel").datagrid('options').queryParams = {};
		clearSearchSel();
		$('#winZdHandleSel').window({
    		modal:true
		});
		$('#winZdHandleSel').window('open');
		$("#ZddgSel")
				.datagrid(
						{
							height : 350,
							striped : true,
							rownumbers : true,
							checkOnSelect : true,
							pagination : true,
							toolbar : '#sel',
							iconCls : 'icon-user',
							url : "${pageContext.request.contextPath}/infoclass/diclist.action?id="+$('#infoId').val(),
							loadMsg : "载入中...请等待.",
							columns : [ [  {
								field : "codedesc",
								title : "归集部门",
								width : 180,
								align : 'center',
								editor : {
									type : 'text'
								}
							}, {
								field : "guijixinximingcheng",
								title : "归集信息名称",
								width : 380,
								align : 'center',
								editor : {
									type : 'text'
								}
							}] ],
							onLoadSuccess : function() {
							}
						});
	}
	//添加   
	function submitForm() {
		//非空验证
		//if ($("#servicename").val() == "") {
			//$.messager.alert('提示', "信息分类名称不能为空！");
			//return;
		//}
		addDepartment();
	}

	function addDepartment() {
		$('#fm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '信息分类以及实体名都不能重复!', 'error');
				}else{
					$.messager.alert('成功', '信息分类添加成功!', 'info');
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
			ids += item.id + ",";
		});
		ids = ids.substring(0, ids.length - 1);
		return ids;
	}

	//字典管理获取
	function getDicSelectionsIds() {
		var checkItems = $('#Zddg').datagrid('getSelections');
		var ids = "";
		$.each(checkItems, function(index, item) {
			ids += item.id + ",";
		});
		ids = ids.substring(0, ids.length - 1);
		return ids;
	}

	function getInfoSelectionsIds() {
		var checkItems = $('#ZddgSel').datagrid('getSelections');
		var ids = "";
		$.each(checkItems, function(index, item) {
			ids += item.id + ",";
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
			$.messager.confirm(	"提示","确认删除信息分类吗？",function(r) {
								if (r) 	{
									$.post("${pageContext.request.contextPath}/infoclass/a_removeList.action",
													{
														"ids" : ids
													},
													function(data) {
														if (data.result == true) {
															$.messager.alert(
																			'提示',
																			"信息分类删除成功！","info",
																			function() {
																					$('#dg').datagrid(
																	'reload');

																			});
															
														} else if (data.result == false) {
															$.messager.alert('提示',
																			"信息分类删除失败！已有数据权限关联该信息，请先删除数据权限关联信息，然后再删除信息分类！","warning");
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
			$('#id').val(node.id);
			$('#bigservicenameH').val(getHtmlInfo(node.codedesc));
			$('#entitynameH').val(getHtmlInfo(node.entityname));
			$('#bigservicenameEdi').val(getHtmlInfo(node.codedesc));
			$('#servicenameEdi').val(getHtmlInfo(node.servicename));
			$('#entitynameEdi').val(getHtmlInfo(node.entityname));
			$('#sortnoEdit').val(node.sortno);
			$('#sfq').combobox("setValue", node.sfqiyong);
			$.parser.parse('#winEdit'); 
			$('#winEdit').window({
    			modal:true
			});
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
					$.messager.alert('失败', '信息分类名称不能重复!', 'error');
				} else {
					$.messager.alert('成功', '信息分类修改成功!', 'info');
					$('#dg').datagrid('reload');
					$('#winEdit').dialog('close');
				}

			}
		});
	}
	//查询
	function conditionSearch() {
		setFirstPage("#dg");
		var bigorgName = $.trim($('#bigservicenameSch').combobox('getValue'));
		var orgName = $.trim($('#servicenameSch').val());
		var status = $.trim($('#statusSch').combobox('getValue'));
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams["bigservicename"] = bigorgName;
		queryParams["servicename"] = orgName;
		queryParams["status"] = status;
		$('#dg').datagrid('options').queryParams = queryParams;
		$('#dg').datagrid('reload');
	}

	//重置
	function clearSearch() {
		$('#bigservicenameSch').combobox('clear');
		$('#servicenameSch').val('');
		$('#statusSch').combobox('clear');
	}

	//添加   
	function submitDicForm() {
		//非空验证
		if ($("#dictionaryname").val() == "") {
			$.messager.alert('提示', "字典名称不能为空！");
			return;
		} else if ($("#dictionarynum").val() == "") {
			$.messager.alert('提示', "字典编码不能为空！");
			return;
		}
		addDic();
	}

	function addDic() {
		$('#dicfm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '新增信息分类失败，信息分类名称不能重复!', 'error');
				} else {
					$.messager.alert('成功', '新增信息分类成功!', 'info');
					$('#Zddg').datagrid('reload');
					$('#dicdlg').dialog('close');
				}

			}
		});
	}

	function delSel() {
		var entityId = getDicSelectionsIds();
		if (entityId.length <= 0) {
			$.messager.alert('提示', '请选择要删除的内容!', 'warning');
			return;
		}

		if (entityId.length != 0) {
			$.messager
					.confirm(
							"提示",
							"确认删除关联信息吗？",
							function(r) {
								if (r) {
									$.post(
													"${pageContext.request.contextPath}/infoclass/delInfoRelevance.action",
													{
														"entityId" : entityId,"infoIdSel" :$('#infoId').val()
													},
													function(data) {
														if (data.result == true) {
															$.messager
																	.alert(
																			'提示',
																			"关联信息删除成功！","info",function(){
																				$('#Zddg').datagrid('clearSelections');
																				$('#Zddg').datagrid('reload');		
																			});
														
														} else if (data.result == false) {
															$.messager
																	.alert(
																			'提示',
																			"关联信息删除失败！");
														}
													}, "json");
								}
							});
		}
	}

	//字典编辑
	function edittable() {
		var node = $('#Zddg').datagrid('getSelected');
		if (node != null) {
			$('#dicId').val(node.id);
			$('#infoIdEdi').val(node.infoId);
			$('#dictionarynameEdi').val(node.dictionaryname);
			$('#dictionarynumEdi').val(node.dictionarynum);
			$('#winDicEdit').window({
    			modal:true
			});
			$('#winDicEdit').window('open');
		} else {
			$.messager.alert('选择', '请先选择要编辑的信息!', 'info');
		}
	}

	//点击修改保存
	function dicEditSubmit() {
		$('#dicEditForm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '字典名称或者编码不能重复!', 'error');
				} else {
					$('#Zddg').datagrid('reload');
					$('#winDicEdit').dialog('close');
				}
			}
		});
	}

	//启用禁用
	function userEnable() {
		var node = $('#dg').datagrid('getSelected');
		if (node != null) {
			$
					.post(
							"${pageContext.request.contextPath}/infoclass/enable.action",
							{
								"id" : node.id
							},
							function(data) {
								if (!data) {
									$.messager.alert('失败', '启用/禁用失败!', 'error');
								} else {
									$.messager.alert('成功', '启用/禁用成功!', 'info');
									$('#dg').datagrid('reload');
								}
							});
		} else {
			$.messager.alert('选择', '请先选择要启用/禁用的信息分类!', 'warning');
		}
	}
	
	//保存字段
	function saveZd() {
		var infos = getZdSelections();
		if (infos.length == 0) {
			$.messager.alert('提示', '请勾选至少一项信息!', 'warning');
			return;
		}
        $('#zds').val(infos);
		$('#zdSetForm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '字段配置失败!', 'error');
				} else {
					$.messager.alert('成功', '字段配置成功!', 'info', function() {
						$('#winZdSet').window('close');
					});
				}
			}
		});
	}
	
	//获取勾选到的字段信息 
	function getZdSelections() {
		var checkItems = $('#zdSet').datagrid('getSelections');
		var zds = "";
		
		$.each(checkItems, function(index, item) {
			zds+= item.gjzdid+"#"+item.excelziduan +"#"+item.ziduanming+",";	
		});

		zds = zds.substring(0, zds.length - 1);
		return zds;
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
		<div id="tb" style="padding:5px;height:auto">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-add" plain="true" onclick="newUser()">新增</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-edit" plain="true" onclick="editUser()">编辑</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-remove" plain="true" onclick="destroyUser()">删除</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-disable" plain="true" onclick="userEnable()">启用/禁用</a>
			<div style="float: right;">
					大分类名称：<input id="bigservicenameSch" class="easyui-combobox" style="width:120px"
					data-options="editable:false">&nbsp;&nbsp; 
					小分类名称： <input id="servicenameSch" class="easyui-input"
					style="width: 120px">&nbsp;&nbsp; 
					状态：<input id="statusSch" class="easyui-combobox" panelHeight="auto" data-options="editable:false,valueField:'value',textField:'text',data:[{'value':'0','text':'启用'},{'value':'1','text':'禁用'}]"/>
					<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="conditionSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearSearch();">重置</a>
			</div>
		</div>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
		<table id="dg"></table>
	</div>
	<!-- 弹出的新增窗口 -->
	<div id="dlg" class="easyui-dialog"
		style="width:400px;height:280px;padding:10px 20px" closed="true"
		buttons="#dlg-buttons">

		<form id="fm" method="post" action="add.action">
			<div class="fitem">
				<label>大分类名称:</label> <input name="bigservicename" class="easyui-textbox"
					id="bigservicename" data-options="required:true,editable:false"
					data-options="editable:false" style="width:164px">
			</div>
			<div class="fitem">
				<label>小分类名称:</label> <input name="servicename"
					class="easyui-validatebox"
					data-options="required:true,validType:'length[0,15]'"
					id="servicename" maxlength="15">
			</div>
			<div class="fitem">
				<label>实体名:</label> <input name="entityname"
					class="easyui-validatebox" id="entityname"
					data-options="required:true,validType:['length[0,38]','englishCheckSub']"
					maxlength="15">
			</div>
			<div class="fitem">
				<label>排序:</label> <input id="sortno" name="sortno"  type="text"	class="easyui-numberbox"
					data-options="required:true,validType:'length[0,15]'"
				 maxlength="15"></input>
			</div>
			<div class="fitem">
				<label>状态:</label> <input id="ENABLEDS" name="sfqiyong" class="easyui-combobox"
					panelHeight="auto"></input>
			</div>
		
		</form>
	</div>
	<div id="dlg-buttons" style="text-align:center;padding:5px">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="submitForm()">确定</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"
			style="width:66px">取消</a>
	</div>

	<!-- 弹出修改的窗口 -->

	<div id="winEdit" class="easyui-window" title="编辑信息分类信息"
		data-options="iconCls:'icon-add', closed:true, border:false"
		style="width:300px;height:250px;padding:10px 20px;">
		<form id="editForm" method="post" action="edit.action">
			<input type="hidden" name="id" id="id" value="">
			<input type="hidden" name="bigservicenameH" id="bigservicenameH" value="">
			<input type="hidden" name="entitynameH" id="entitynameH" value="">
			<table style="border-collapse:separate; border-spacing:10px;">
				<tr style="line-height:10px;">
					<td align="right">大分类名称:</td>
					<td><input class="easyui-validatebox" type="text"
						id="bigservicenameEdi" disabled="true"
						data-options="editable:false" 
						name="bigservicenameEdi"></input></td>
				</tr>
				<tr style="line-height:10px;">
					<td align="right">小分类名称:</td>
					<td><input class="easyui-validatebox" type="text"
						id="servicenameEdi"
						data-options="required:true,validType:'length[0,15]'" maxlength="15"
						name="servicenameEdi"></input></td>
				</tr>
				<tr style="line-height:10px;">
					<td align="right">实体名:</td>
					<td><input class="easyui-validatebox" type="text"
						id="entitynameEdi" disabled="true"
						data-options="editable:false" 
						name="entitynameEdi"></input></td>
				</tr>
				<tr style="line-height:10px;">
					<td align="right">排序:</td>
					<td> <input id="sortnoEdit" name="sortnoEdit"  type="text"	class="easyui-validatebox"
					data-options="required:true,validType:'length[0,15]'"
				 maxlength="15"></input></td>
				</tr>
				<tr>
					<td align="right">状态:</td>
					<td><select id="sfq" class="easyui-combobox"
						style="width:80px;" name="sfqiyong" panelHeight="auto">
							<option type="radio" value="0">启用</option>
							<option type="radio" value="1">禁用</option>
					</select>
					</td>
				</tr>
			</table>
		</form>

		<div id="edit-buttons" style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="editSubmit()">确定</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#winEdit').dialog('close');"
				style="width:66px">取消</a>
		</div>
	</div>
	<!-- 关联资源 -->
	<div id="winZdHandle" class="easyui-window" title="关联资源"
		data-options="iconCls:'icon-add', closed:true, border:false"
		style="width:600px;height:390px;padding:5px;">

		<div>
			<table id="Zddg" class="easyui-datagrid" style="width:575px;"></table>
			<div id="zd" style="padding:5px;height:auto">
				<a href="javascript:void(0)" class="easyui-linkbutton"
					iconCls="icon-add" plain="true" onclick="openSel()" id="addBtn">新增</a>
					
				<a href="javascript:void(0)" class="easyui-linkbutton"
					iconCls="icon-remove" plain="true" onclick="delSel()" id="delBtn">删除</a>
			</div>
		</div>
	</div>

	<!-- 选择资源 -->
	<div id="winZdHandleSel" class="easyui-window" title="选择资源 "
		data-options="iconCls:'icon-add', tools:'#addTool',closed:true, border:false"
		style="width:700px;height:400px;padding:10px 20px;">
		<form id="infoAddForm" method="post" action="addInfo.action">
			<input type="hidden" name="infoIdSel" id="infoIdSel" value="">
			<input type="hidden" name="infoIds" id="infoIds" value=""> 
			<input type="hidden" name="infoId" id="infoId" value="">
			<div>
				<table id="ZddgSel" class="easyui-datagrid" width="100%"></table>
			</div>
		</form>
		<div id="addTool">
			<a href="javascript:void(0)" class="icon-save" onclick="saveSel()"
				title="保存配置"></a>
		</div>
		<div id="sel">
				归集部门：<input id="bmName" class="easyui-combobox" style="width:120px"
					data-options="editable:false">&nbsp;&nbsp; 归集信息名称：<input
					id="conditionName" class="easyui-input" style="width:120px">&nbsp;&nbsp; 
					<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="conditionSearchSel();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearSearchSel();">重置</a>
		</div>
	</div>
	
	<!-- 字段配置 -->
	<div id="winZdSet" class="easyui-window" title="字段配置 "
		data-options="iconCls:'icon-add', tools:'#zdTool',closed:true, border:false"
		style="width:460px;height:400px;padding:10px 20px;">
		<form id="zdSetForm" method="post" action="saveZdInfo.action">
			<input
				type="hidden" name="zds" id="zds" value=""> <input
				type="hidden" name="viewId" id="viewId" value="">
				<input
				type="hidden" name="entityId" id="entityId" value="">
			<div>
				<table id="zdSet" class="easyui-datagrid"></table>
			</div>
		</form>
		<div id="zdTool">
			<a href="javascript:void(0)" class="icon-save" onclick="saveZd()"
				title="保存配置"></a>
		</div>
	</div>
</body>
</html>