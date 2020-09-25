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
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
 

    
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
<title>数据权限</title>
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
	
	//////////////////////////////////数据权限列表//////////////////////////////////
//　渲染数据权限列表
	$(function() {
		$("#dg")
				.datagrid(
						{
							//title: '信息分类',
							height : 450,
							striped : true,
							rownumbers : true,
							checkOnSelect : false,
							pagination : true,
							singleSelect : true,
							toolbar : '#tb',
							iconCls : 'icon-user',
							url : "${pageContext.request.contextPath}/dataaccess/getAccessList.action",
							loadMsg : "载入中...请等待.",
							 onLoadSuccess : function () {
								 $(this).datagrid("fixRownumber");
									    },
							columns : [ [
									{
										field : "dataaccessName",
										title : "权限名称",
										width : 200,
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
										width : 200,
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
										width : 200,
										align : 'left'
									},
									{
										field : "deptdesc",
										title : "部门",
										width : 120,
										align : 'left'
									},
									{
										field : "dataaccessId",
										hidden: true
									},
									{
										field : "opr",
										title : "操作",
										width : 100,
										align : 'left',
										formatter : function(value, row, index) {
											return "<a href='#' class='tablelink' style='font-size:12px;color:blue' onclick='showQueryTip(&#039;"
													+ row.dataaccessId
													+ "&#039;)'>"
													+ "权限配置 "
													+ "</a>";
										}
									} ] ]

						});
	});
	
	//新增数据权限
	function newAccess() {
		$('#fm').form('clear');
		$('#dlg').window({
    		modal:true
		});
		$('#dlg').dialog('open').dialog('setTitle', '新增权限');
	}


	//保存数据权限入口
	function submitForm() {
		//非空验证
		if ($("#accessnameAdd").val() == "") {
			$.messager.alert('提示', "权限名称不能为空！");
			return;
		}

		//非空验证
		if ($.trim($('#accessDeptment').combobox('getValue')) == "") {
			$.messager.alert('提示', "部门不能为空！");
			return;
		}
		$("#accdept").val($.trim($('#accessDeptment').combobox('getValue')));
		addAccess();
	}

	//保存数据权限－返回结果
	function addAccess() {
		$('#fm').form('submit', {
			success : function(data) {
					var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '新增权限失败，权限名称不能重复!', 'error');
				} else {
					$.messager.alert('成功', '新增权限成功!', 'info');
					$('#dg').datagrid('reload');
					$('#dlg').dialog('close');
				}
			}
		});
	}
	
	

	//获取选择的数据权限
	function getSelectionsIds() {
		var checkItems = $('#dg').datagrid('getSelections');
		var ids = "";
		$.each(checkItems, function(index, item) {
			ids += item.dataaccessId + ",";
		});
		ids = ids.substring(0, ids.length - 1);
		return ids;
	}

	//删除权限
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
			$('#winEdit').window({
    			modal:true
			});
			$('#winEdit').window('open');
			$('#editDept').combobox('setValue',node.department);
		} else {
			$.messager.alert('选择', '请先选择要编辑的信息!', 'info');
		}
	}

	//点击修改保存
	function editSubmit() {
		$("#editdeptment").val($.trim($('#editDept').combobox('getValue')));
		$('#editForm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '权限名称不能重复!', 'error');
				} else {
				$.messager.alert('成功','编辑成功!','info');
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
		var deptname = $.trim($('#accessDept').combobox('getValue'));
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams["accessName"] = orgName;
		queryParams["accessDept"] = deptname;
		$('#dg').datagrid('options').queryParams = queryParams;
		$('#dg').datagrid('reload');
	}

	//重置
	function clearSearch() {
		$('#accessSch').val('');
		$('#accessDept').combobox('setValue','');
	}
//////////////////////////////////数据权限列表//////////////////////////////////

//////////////////////////////////权限目录配置BEGIN//////////////////////////////////
	
	 //弹出权限目录配置页面  begin
	function showQueryTip(id) {
	  
		$("#Zddg").datagrid('options').queryParams = {};
	
		$('#winZdHandle').window({
			top:'0px',
    		modal:true
		});
		$('#winZdHandle').window('open');
		$('#infoId').val(id);
		
	
		// 大分类下拉框
		$('#select_dlname').combobox({
			url : '${pageContext.request.contextPath}/dataaccess/getdlname.action' ,
			valueField : 'value',
			textField : 'text',
			multiple : false,
			panelHeight : 'auto',
			editable : false,
			onSelect:function(record){
				$('#select_xlname').combobox({
					url : '${pageContext.request.contextPath}/dataaccess/getxlname.action?dlname=' + encodeURI(record.value),
					valueField : 'value',
					textField : 'text',
					multiple : false,
					panelHeight : 'auto',
					editable : false
				}).combobox('clear');

         }
		});
	//小分类下拉框
	$('#select_xlname').combobox({
		url : '${pageContext.request.contextPath}/dataaccess/getxlname.action' ,
		valueField : 'value',
		textField : 'text',
		multiple : false,
		panelHeight : 'auto',
		editable : false,
		onSelect:function(record){
			$('#select_bmname').combobox({
				url : '${pageContext.request.contextPath}/dataaccess/getbmname.action?xlname=' + encodeURI(record.value),
				valueField : 'value',
				textField : 'text',
				multiple : false,
				panelHeight : 150,
				editable : false
			}).combobox('clear');

     }
	});
	//部门下拉框
	$('#select_bmname').combobox({
		url : '${pageContext.request.contextPath}/dataaccess/getbmname.action' ,
		valueField : 'value',
		textField : 'text',
		multiple : false,
		panelHeight : 150,
		editable : false
	/* 	onSelect:function(record){
			$('#select_mlname').combobox({
				url : '${pageContext.request.contextPath}/dataaccess/getmlname.action?bmname=' + encodeURI(record.value),
				valueField : 'value',
				textField : 'text',
				multiple : false,
				panelHeight : 'auto',
				editable : false
			}).combobox('clear');

     } */
	});


	//数据授权表
		$("#Zddg")
				.datagrid(
						{ top:50,
							height : 450,
							striped : true,
							rownumbers : true,
							pagination : true,
							checkOnSelect:false,
							toolbar : '#zd',
							iconCls : 'icon-user',
							singleSelect:true ,
							pageNumber : 1,
							url : "${pageContext.request.contextPath}/dataaccess/getExistInfoList.action?id="
									+ id,
							loadMsg : "载入中...请等待.",
						    onLoadSuccess : function () {
								 $(this).datagrid("fixRownumber");
									    },
							columns : [ [
									{
										field : "dlnm",
										title : "大分类名称",
										width : 100,
										align : 'center',
										editor : {
											type : 'text'
										}
									},
									{
										field : "xlnm",
										title : "小分类名称",
										width : 150,
										align : 'center',
										editor : {
											type : 'text'
										}
									}
									,
									{
										field : "suosubumen",
										title : "来源部门",
										width : 200,
										align : 'center',
										editor : {
											type : 'text'
										}
									},
									
									{
										field : "guijixinximingcheng",
										title : "目录名称",
										width : 350,
										align : 'center',
										editor : {
											type : 'text'
										}
									},
									{
										field : "gjxxid",
										hidden: true
									},
									
									{
										field : "opr",
										title : "操作",
										width : 100,
										align : 'left',
										formatter : function(value, row, index) {
											if(row.isok=='0'){
												return "<span title='程序未处理完，暂不可配置' style='font-size:12px;color:gray;' >"
												+ "字段配置 "
												+ "</span>";
											} else{
											return "<a href='#' class='tablelink' style='font-size:12px;color:blue' onclick='openZdSet(&#039;"
													+ row.gjxxid + "&#039;)'>"
													+ "字段配置 "
													+ "</a>";
											}
										}
									} ] ],
							onLoadSuccess : function(data) {
								if (data.total == 0) {
									var body = $(this).data().datagrid.dc.body2;
									body.find('table tbody').append(
											"<tr height='25px'><td width='"
													+ body.width()
													+ "'>未添加数据权限！</td></tr>");
								}
							}
						});
		
	}
 //弹出权限目录配置页面  end
 
	//权限配置目录页面－查询
	function conditionSearchzddg() {
		
		setFirstPage("#Zddg");
		var dlname=	 $('#select_dlname').combobox('getValue');
		var xlname=	 $('#select_xlname').combobox('getValue');
		var bmname=	 $('#select_bmname').combobox('getValue');
	
       var queryParams = $('#Zddg').datagrid('options').queryParams;
		queryParams["dlname"] = dlname;
		queryParams["xlname"] = xlname;
		queryParams["bmname"] = bmname;
        $('#Zddg').datagrid('options').queryParams = queryParams;
		$('#Zddg').datagrid('reload');
	}

	////权限配置目录页面－重置
	function clearSearchzddg() {

		$('#select_dlname').combobox('setValue','');
	
	     $('#select_xlname').combobox('setValue','');
         $('#select_bmname').combobox('setValue','');

	}
	

	//删除已授权的目录
	function delmlSel() {
		var infos = getSelectionsInfos();
		if (infos.length <= 0) {
			$.messager.alert('提示', '请选择要删除的信息!', 'warning');
			return;
		}
		if (infos.length != 0) {
			$.messager
					.confirm(
							"提示",
							"确认删除该信息吗？",
							function(r) {
								if (r) {
									$
											.post(
													"${pageContext.request.contextPath}/dataaccess/delInfo.action",
													{
														"dataaccessId" : $('#infoId').val(),
														"infos" : infos
														
													},
													function(data) {
														if (data.result == true) {
															$.messager
																	.alert(
																			'提示',
																			"权限配置信息删除成功！","info",function(){
																				$('#Zddg').datagrid('clearSelections');
																				$('#Zddg').datagrid('reload');		
																			});
														
														} else if (data.result == false) {
															$.messager
																	.alert(
																			'提示',
																			"权限配置信息删除失败！");
														}
													}, "json");
								}
							});
		}
	}
	
	//勾选待删除的授权目录
	function getSelectionsInfos() {
		var checkItems = $('#Zddg').datagrid('getSelections');
		var infos = "";
		$.each(checkItems, function(index, item) {
			infos += "'" + item.gjxxid + "',";
		});
		infos = infos.substring(0, infos.length - 1);
		return infos;
	}
//////////////////////////////////权限目录配置END//////////////////////////////////

//////////////////////////////////权限目录新增BEGIN//////////////////////////////////

	//权限目录配置-添加目录
	function addmlSel() {
		$("#ZddgSel").datagrid('options').queryParams = {};

		$('#winZdHandleSel').window({
			top:'0px',
    		modal:true
		});
		$('#winZdHandleSel').window('open');
		// 大分类下拉框
		$('#add_select_dlname').combobox({
			url : '${pageContext.request.contextPath}/dataaccess/getdlname.action' ,
			valueField : 'value',
			textField : 'text',
			multiple : false,
			panelHeight : 'auto',
			editable : false,
			onSelect:function(record){
				$('#add_select_xlname').combobox({
					url : '${pageContext.request.contextPath}/dataaccess/getxlname.action?dlname=' + encodeURI(record.value),
					valueField : 'value',
					textField : 'text',
					multiple : false,
					panelHeight : 'auto',
					editable : false
				}).combobox('clear');

         }
		});
	//小分类下拉框
	$('#add_select_xlname').combobox({
		url : '${pageContext.request.contextPath}/dataaccess/getxlname.action' ,
		valueField : 'value',
		textField : 'text',
		multiple : false,
		panelHeight : 'auto',
		editable : false,
		onSelect:function(record){
			$('#add_select_bmname').combobox({
				url : '${pageContext.request.contextPath}/dataaccess/getbmname.action?xlname=' + encodeURI(record.value),
				valueField : 'value',
				textField : 'text',
				multiple : false,
				panelHeight : 150,
				editable : false
			}).combobox('clear');

     }
	});
	//部门下拉框
	$('#add_select_bmname').combobox({
		url : '${pageContext.request.contextPath}/dataaccess/getbmname.action' ,
		valueField : 'value',
		textField : 'text',
		multiple : false,
		panelHeight : 150,
		editable : false
	/* 	onSelect:function(record){
			$('#select_mlname').combobox({
				url : '${pageContext.request.contextPath}/dataaccess/getmlname.action?bmname=' + encodeURI(record.value),
				valueField : 'value',
				textField : 'text',
				multiple : false,
				panelHeight : 'auto',
				editable : false
			}).combobox('clear');

     } */
	});
	
		$("#ZddgSel")
				.datagrid(
						{
							height : 350,
							striped : true,
							rownumbers : true,
							pagination : true,
							toolbar : '#addsel',
							iconCls : 'icon-user',
							pageNumber : 1,
							url : "${pageContext.request.contextPath}/dataaccess/diclist.action?id="
									+ $('#infoId').val(),
							loadMsg : "载入中...请等待.",
							 onLoadSuccess : function () {
								 $(this).datagrid("fixRownumber");
									    },
							columns : [ [
										{
											field : "ck",
											checkbox : true,
											width : 50
										},
							             
										{
											field : "dlnm",
											title : "大分类名称",
											width : 100,
											align : 'center',
											editor : {
												type : 'text'
											}
										},
										{
											field : "xlnm",
											title : "小分类名称",
											width : 150,
											align : 'center',
											editor : {
												type : 'text'
											}
										},
										{
											field : "suosubumen",
											title : "来源部门",
											width : 200,
											align : 'center',
											editor : {
												type : 'text'
											}
										},
										
										{
											field : "guijixinximingcheng",
											title : "目录名称",
											width : 300,
											align : 'center',
											editor : {
												type : 'text'
											}
										},
										{
											field : "gjxxid",
											hidden: true
										}
							             
							             ] ]

						});
	}
	
	//权限配置目录页面-新增－查询
	function conditionSearchzddgsel() {
		
		setFirstPage("#ZddgSel");
		var dlname=	 $('#add_select_dlname').combobox('getValue');
		var xlname=	 $('#add_select_xlname').combobox('getValue');
		var bmname=	 $('#add_select_bmname').combobox('getValue');
	
       var queryParams = $('#ZddgSel').datagrid('options').queryParams;
		queryParams["dlname"] = dlname;
		queryParams["xlname"] = xlname;
		queryParams["bmname"] = bmname;
        $('#ZddgSel').datagrid('options').queryParams = queryParams;
		$('#ZddgSel').datagrid('reload');
	}

	////权限配置目录页面－新增－重置
	function clearSearchzddgsel() {

		$('#add_select_dlname').combobox('setValue','');
	
	     $('#add_select_xlname').combobox('setValue','');
         $('#add_select_bmname').combobox('setValue','');
	}

	
	//获取勾选到的目录信息
	function getInfoSelections() {
		var checkItems = $('#ZddgSel').datagrid('getSelections');
		var infos = "";
		$.each(checkItems, function(index, item) {
			infos += item.gjxxid + ";";
		});
		infos = infos.substring(0, infos.length - 1);
		return infos;
	}


	//保存权限配置目录信息
	function saveSel() {
		//　勾选目录ＩＤ
		var infos = getInfoSelections();
		if (infos.length == 0) {
			$.messager.alert('提示', '请勾选至少一项信息!', 'warning');
			return;
		}

		$('#infoIds').val(infos);
		
		$('#infoAddForm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '权限配置失败!', 'error');
				} else {
					$.messager.alert('成功', '权限配置成功!', 'info', function() {
						$('#winZdHandleSel').window('close');
						$('#Zddg').datagrid('clearSelections');
						$('#Zddg').datagrid('reload');
						
					});

				}
			}
		});
	}

//////////////////////////////////权限目录新增END//////////////////////////////////

//////////////////////////////////权限字段配置ＢＥＧＩＮ//////////////////////////////////
	//字段配置页面
	function openZdSet(id) {
		$('#tableid').val(id);
		$('#winZdSet').window({
			top:'0px',
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
							url : "${pageContext.request.contextPath}/dataaccess/getZdlistByName.action?id="
									+ id,
							loadMsg : "载入中...请等待.",
							 onLoadSuccess : function () {
								 $(this).datagrid("fixRownumber");
									    },
							columns : [ [ {
								field : "ck",
								checkbox : true,
								width : 50
							}, {
								field : "suosubumen",
								title : "字段来源部门",
								width : 190,
								align : 'left',
								hidden: true
							}
							, {
								field : "gjmc",
								title : "目录名称",
								width : 290,
								align : 'left',
								hidden: true
							}
							, {
								field : "excelziduan",
								title : "字段",
								width : 130,
								align : 'left'
							}, {
								field : "ziduanming",
								title : "字段名称",
								width : 260,
								align : 'left'
							}, {
								field : "zdid",
								hidden: true
							} , {
								field : "gjid",
								hidden: true
							}] ],
							onLoadSuccess : function(data) {
								if (data.total == 0) {
									var body = $(this).data().datagrid.dc.body2;
									body.find('table tbody').append(
											"<tr height='25px'><td width='"
													+ body.width()
													+ "'>暂未在信息分类页面进行配置或配置尚未完成！</td></tr>");
								}else{
								$.post("getCheckedList.action?dataaccessId="
										+ $('#infoId').val() + "&tableid="
										+ id, {}, function(data) {
									if (data != null) {
										var rows = $("#zdSet").datagrid('getRows');
										var data = eval('(' + data + ')');
										var info = data.rows.toString();
								
  										for (var i = 0; i < rows.length; i++) {  
  											
        									if (info.indexOf(rows[i]['zdid']) != -1) { 
        									 $("#zdSet").datagrid("selectRow", i);
       				 		}  
   						} 
									}
								});
								}
								
							}

						});
	}

	

	
	//保存字段
	function saveZd() {
		var infos = getZdSelections();
		if (infos.length == 0) {
			$.messager.alert('提示', '请勾选至少一项信息!', 'warning');
			return;
		}
		$('#zdId').val($('#infoId').val());
		$('#zdIds').val(infos);
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
		var infos = "";
		$.each(checkItems, function(index, item) {
			infos += item.zdid + ",";
		});
		infos = infos.substring(0, infos.length - 1);
		return infos;
	}
	
//////////////////////////////////权限字段配置END//////////////////////////////////
	

	
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
				iconCls="icon-add" plain="true" onclick="newAccess()">新增</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-edit" plain="true" onclick="editUser()">编辑</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-remove" plain="true" onclick="destroyUser()">删除</a>
			<div style="float: right;">
				权限名称： <input id="accessSch" class="easyui-input"
					style="width: 150px">&nbsp;&nbsp; &nbsp;&nbsp; 
					部门：<input style="width:150px"
					class="easyui-combobox" id="accessDept" editable="false"
					url='${pageContext.request.contextPath}/system/user/getDept.action'
					data-options="valueField:'value', textField:'text',multiple:false"> &nbsp;&nbsp; &nbsp;&nbsp; 
					<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="conditionSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearSearch();">重置</a> &nbsp;&nbsp; &nbsp;&nbsp; 
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
		style="width:400px;height:180px;padding:0px;" closed="true"
		buttons="#dlg-buttons">

		<form id="fm" method="post" action="add.action">
             <input type="hidden" name="accdept" id="accdept" value="">
             <div style="padding:10px;">
			 <table width="100%" border="0" cellpadding="5">
			 	<tr>
			 		<td><label>部门:</label></td>
			 		<td>
			 			<input style="width:150px"
					class="easyui-combobox" id="accessDeptment" editable="false"
					url='${pageContext.request.contextPath}/system/user/getDept.action'
					data-options="valueField:'value', textField:'text',multiple:false" />
			 		</td>
			 	</tr>
			 	<tr><td colspan="2">&nbsp;</td></tr>
			 	<tr>
			 		<td><label>权限名称:</label></td>
			 		<td>
			 			<input name="accessnameAdd" style="width:150px;"
					class="easyui-textbox"
					data-options="required:true,validType:'length[0,15]'"
					id="accessnameAdd" maxlength="15" />
			 		</td>
			 	</tr>
			 </table>
			 </div>
		</form>
	</div>
	<div id="dlg-buttons" style="text-align:center;padding:5px">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="submitForm()">确定</a> 
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"
			style="width:66px">取消</a>
	</div>


	<!-- 弹出修改的窗口 -->
	<div id="winEdit" class="easyui-window" title="编辑数据权限"
		data-options="iconCls:'icon-add', closed:true, border:false"
		style="width:300px;height:250px;padding:10px 20px;">
		<form id="editForm" method="post" action="edit.action">
			<input type="hidden" name="id" id="id" value="">
			<input type="hidden" name="editdeptment" id="editdeptment" value="">
			<table style="border-collapse:separate; border-spacing:10px;">
				<tr style="line-height:10px;">
					<td align="right">部门:</td>
						<td><input style="width:150px"
						class="easyui-combobox" id="editDept" editable="false"
						url='${pageContext.request.contextPath}/dataaccess/getbmname.action'
						data-options="valueField:'value', textField:'text',multiple:false"> 
					</td>
				</tr>
				<tr style="line-height:10px;">
					<td align="right">权限名称:</td>
					<td><input style="width:150px" class="easyui-validatebox" type="text"
						id="servicenameEdi"
						data-options="required:true,validType:'length[0,15]'"
						name="servicenameEdi"  maxlength="15"></input></td>
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
	
	<!-- 权限目录配置 -->
	<div id="winZdHandle" class="easyui-window" title="权限配置"
		data-options="iconCls:'icon-add', closed:true, border:false"
		style="width:1000px;padding:10px 20px;">

		<div>
			<table id="Zddg" class="easyui-datagrid"></table>
			<div id="zd" style="padding:5px;height:auto">
				<a href="javascript:void(0)" class="easyui-linkbutton"
					iconCls="icon-add" plain="true" onclick="addmlSel()" id="addBtn">添加</a>
				<a href="javascript:void(0)" class="easyui-linkbutton"
					iconCls="icon-remove" plain="true" onclick="delmlSel()" id="delBtn">删除</a>
				
					<div style="float: right;">
			  <label for="select_dlname">大分类名称：</label> <input id="select_dlname" name="select_dlname" />
			  <label for="select_xlname">小分类名称：</label> <input id="select_xlname" name="select_xlname" />
		      <label for="select_bmname">部门名称：</label> <input id="select_bmname"  name="select_bmname" /> 
		     <!--  <label for="select_mlname">目录名称：</label> <input id="select_mlname"  name="select_mlname" />--> 
		     <a href="javascript:void(0);"  onclick="conditionSearchzddg();" class="easyui-linkbutton" iconCls="icon-search" >查询</a>
		     <a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="clearSearchzddg();">重置</a>
		</div>
			</div>
			
		</div>
		
	</div>

	<!-- 权限目录新增 -->
	<div id="winZdHandleSel" class="easyui-window" title="选择资源 "
		data-options="iconCls:'icon-add', tools:'#addTool',closed:true, border:false"
		style="width:900px;padding:10px 20px;">
		<form id="infoAddForm" method="post" action="saveAccessInfo.action">
		
			<input type="hidden" name="infoIds" id="infoIds" value=""> <input
				type="hidden" name="infoId" id="infoId" value="">
			<div>
				<table id="ZddgSel" class="easyui-datagrid"></table>
				<div id="addsel" style="padding:5px;height:auto;" >
	　　　　　　                                                 <label for="add_select_dlname">大分类名称：</label> <input id="add_select_dlname" name="add_select_dlname" />
						  <label for="add_select_xlname">小分类名称：</label> <input id="add_select_xlname" name="add_select_xlname" />
					      <label for="add_select_bmname">部门名称：</label> <input id="add_select_bmname"  name="add_select_bmname" /> 
					    
					     <a href="javascript:void(0);"  onclick="conditionSearchzddgsel();" class="easyui-linkbutton" iconCls="icon-search" >查询</a>
					     <a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="clearSearchzddgsel();">重置</a>
				
				</div>
			</div>
		</form>
		<div id="addTool">
			<a href="javascript:void(0)" class="icon-save" onclick="saveSel()"
				title="保存配置"></a>
		</div>
		
	</div>
	

	<!-- 字段配置 -->
	<div id="winZdSet" class="easyui-window" title="字段配置 "
		data-options="iconCls:'icon-add', tools:'#zdTool',closed:true, border:false"
		style="width:660px;height:400px;padding:10px 20px;">
		<form id="zdSetForm" method="post" action="saveZdInfo.action">
			<input type="hidden" name="zdId" id="zdId" value=""> <input
				type="hidden" name="zdIds" id="zdIds" value=""> <input
				type="hidden" name="tableid" id="tableid" value="">
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