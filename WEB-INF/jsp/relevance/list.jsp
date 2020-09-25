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
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css"/>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/icon.css"/>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/icon-suit-a.css"/>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/autocomplete.css"/>
	<style type="text/css">
		.easyui-combobox {
			overflow: hidden; /*自动隐藏文字*/
			text-overflow: ellipsis; /*文字隐藏后添加省略号*/
			white-space: nowrap; /*强制不换行*/
			width: 15em; /*不允许出现半汉字截断*/
			color: #6699ff;
			border: 1px #ff8000 dashed;
		}

		.datagrid-btable .datagrid-cell {
			/* padding: 6px 4px; */
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.autocomplete.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/browser.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/extandsEasyUiValidate.js"></script>
<title>规则关联管理</title>
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
    	height: 390,
		striped: true,
		rownumbers: true,
		singleSelect: false,
		checkOnSelect: false,
		pagination: true,
		toolbar :'#td',
        loadMsg: "载入中...请等待.",
        onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
			 $(this).datagrid("resize");
				    },
        columns:[[
            {field:"ck",checkbox:true,width:'5%'},
            {field:"deptname",title:"部门",width:'15%',	formatter:function(value) {return "<span title='"+value+"'>"+value+"</span>";}},
            {field:"tablename",title:"表名",width:'15%',formatter:function(value) {return "<span title='"+value+"'>"+value+"</span>";}},
            {field:"tablexp",title:"信息分类",width:'20%',formatter:function(value) {return "<span title='"+value+"'>"+value+"</span>";}},
            {field:"ziduanming",title:"字段名",width:'20%',formatter:function(value) {return "<span title='"+value+"'>"+value+"</span>";}},
            {field:"col",title:"字段",width:'15%',formatter:function(value) {return "<span title='"+value+"'>"+value+"</span>";}},
            {field:"opr",title:"操作",width:'10%',align:'left',formatter: function (value, row, index) {
            	var html =""; 
            	html +="<a href='#' class='tablelink' style='font-size:12px;color:blue' onclick='rlueManage(\""+row.zdid+"\");'>"+" 规则维护"+"</a>";
              	if(row.rcou>0 && row.stat>0){
            		html +=" |<a href='#' class='tablelink' onclick='disable(\""+row.zdid+"\");'>"+"  禁用"+"</a>";
            	}
            	if(row.rcou>0 && row.stat==0){
            		html +=" |<a href='#' class='tablelink' onclick='enable(\""+row.zdid+"\");'>"+"  启用"+"</a>";
            	}  
            	return  html;
                }
            }
        ]],
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('unselectRow', rowIndex);
        }
    });
    $("#dg").datagrid({url: "${pageContext.request.contextPath}/relevance/pageList.action"});
   // $("#dg").datagrid("load"); 

    
    })
        
var st = [{value:'true',text:'启用'},{value:'false',text:'禁用'}];


	//条件查询

	
	function query() {
		var queryParams = $('#dg').datagrid('options').queryParams;
		var deptcode = $("#select_dept").combobox('getValue');
		var tablename = $("#select_kind").combobox('getValue');
		var col = $("#select_column").combobox('getValue');
		queryParams.deptname = deptcode;
		queryParams.tablename = tablename;
		queryParams.col = col;
		$('#dg').datagrid('options').queryParams = queryParams;
		$("#dg").datagrid("reload");
	}

	function conditionReset() {
		$('#select_dept').combobox("setValue","").combobox("setText",""); 
		$('#select_kind').combobox("setValue","").combobox("setText",""); 
		$('#select_column').combobox("setValue","").combobox("setText",""); 
		$('#queryFormID').form("reset");
		location.reload() ;
	}

	function rlueManage(p) {
		$('#fieldID').val(p);
		$('#addtable').datagrid({
			url : '../../relevance/getAllRule.action',
			onLoadSuccess : function(row) {
				$.post('../../relevance/getSelectRule.action', {
					fieldid : p
				}, function(d) {
					var rowData = row.rows;
					$.each(rowData, function(idx, val) {//遍历JSON
						if (d.indexOf(val.id) >= 0){
							$("#addtable").datagrid("selectRow", idx);//如果数据行为已选中则选中改行
						}
					})
				}, 'text');
			}
		});
		$('#addtable').datagrid('reload');
		$('#ruleWin').window('open');
	}

	function deleteRule() {
		var rows = $('#dg').datagrid('getSelections');
		if (rows.length == 0) {
			$.messager.alert("提示", "请先选择要删除映射配置的行!");
			return;
		}
		$.messager.confirm("确认", "确认删除选择字段配置规则吗？", function(r) {
			if (r) {
				var ids = [];
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].zdid);
				}
				$.ajax({
					type : 'POST',
					url : '../../relevance/deleteRule.action',
					data : {
						'ids' : ids
					},
					error : function() {
						$.messager.alert("提示", "网络错误", "error");
					},
					success : function(data, status) {
						var json = eval('(' + data + ')');
						if (json.success) {
							$.messager.alert("提示", json.msg, "info",
									function() {
										$("#dg").datagrid("load");
									});
						} else {
							$.messager.alert("提示", json.msg, "error");
						}
					}
				});
				$("#dg").datagrid("reload");
			}
		});
	}

	function disable(f) {
		if (f != null) {
			$.ajax({
				type : 'POST',
				url : '../../relevance/disableRule.action',
				data : {
					'ids' : f
				},
				error : function() {
					$.messager.alert("提示", "网络错误", "error");
				},
				success : function(data, status) {
					var json = eval('(' + data + ')');
					if (json.success) {
						$.messager.alert("提示", json.msg, "info", function() {
							$("#dg").datagrid("reload");
						});
					} else {
						$.messager.alert("提示", json.msg, "error");
					}
				}
			});
		} else {
			var ids = [];
			var rows = $('#dg').datagrid('getSelections');
			if (rows.length == 0) {
				$.messager.alert("提示", "请先选择要禁用用的行!");
				return;
			}
			for ( var i = 0; i < rows.length; i++) {
				ids.push(rows[i].zdid);
			}
			$.ajax({
				type : 'POST',
				url : '../../relevance/disableRule.action',
				data : {
					'ids' : ids
				},
				error : function() {
					$.messager.alert("提示", "网络错误", "error");
				},
				success : function(data, status) {
					var json = eval('(' + data + ')');
					if (json.success)
						$.messager.alert("提示", json.msg, "info", function() {
						$("#dg").datagrid("reload");
						});
					else
						$.messager.alert("提示", json.msg, "error");

				}
			});
		}
	}

	function enable(f) {
		if (f != null) {
			$.ajax({
				type : 'POST',
				url : '../../relevance/enableRule.action',
				data : {
					'ids' : f
				},
				error : function() {
					$.messager.alert("提示", "网络错误");
				},
				success : function(data, status) {
					var json = eval('(' + data + ')');
					if (json.success) {
						$.messager.alert("提示", json.msg, "info", function() {
							$("#dg").datagrid("reload");
						});
					} else {
						$.messager.alert("提示", json.msg, "error");
					}
				}
			});
		} else {
			var ids = [];
			var rows = $('#dg').datagrid('getSelections');
			if (rows.length == 0) {
				$.messager.alert("提示", "请先选择要启用的行!");
				return;
			}
			for ( var i = 0; i < rows.length; i++) {
				ids.push(rows[i].zdid);
			}
			$.ajax({
				type : 'POST',
				url : '../../relevance/enableRule.action',
				data : {
					'ids' : ids
				},
				error : function() {
					$.messager.alert("提示", "网络错误");
				},
				success : function(data, status) {
					var json = eval('(' + data + ')');
					if (json.success) {
						$.messager.alert("提示", json.msg, "info", function() {
							$("#dg").datagrid("reload");
						});
					} else {
						$.messager.alert("提示", json.msg, "error");
					}
				}
			});
		}
	}
	function saveRule() {
		var field = $('#fieldID').val();
		var ids = [];
		var rows = $('#addtable').datagrid('getSelections');
		if(rows.length==0){
			$.messager.alert("提示", "规则映射配置未做关联");
			return;
		}
		for ( var i = 0; i < rows.length; i++) {
			ids.push(rows[i].id);
		}
		$.ajax({
			type : 'POST',
			url : '../../relevance/saveSelectRule.action',
			data : {
				'ids' : ids,
				'fieldid' : field
			},
			error : function() {
				$.messager.alert("提示", "网络错误");
			},
			success : function(data, status) {
				var json = eval('(' + data + ')');
				if (json.success) {
					$.messager.alert("提示", json.msg);
					$('#addtable').datagrid('loadData', {
						total : 0,
						rows : []
					});
					$('#ruleWin').dialog('close');
					$("#dg").datagrid("load");
				} else {
					$.messager.alert("提示", json.msg);
				}
			}
		});
	}
	function getColumn() {
		var value = $('#select_kind').combobox('getValue');
		$('#select_column').combobox({
			url : '../../dataupload/getColumn.action?kind=' + encodeURI(value),
			valueField : 'code',
			textField : 'name',
			multiple : false,
			panelHeight : '200',
			editable : false
		}).combobox('clear');

	}
	function getKind() {
		var value = $('#select_dept').combobox('getValue');
		value = encodeURI(value,'UTF-8');
		value = encodeURI(value,'UTF-8');
		$('#select_kind').combobox({
			url : '../../dataupload/getKind.action?dept=' + value,
			valueField : 'code',
			textField : 'name',
			multiple : false,
			panelHeight : '200',
			editable : false
		}).combobox('clear');
	}
</script>
</head>
<body id="homepage" class="bodyBG" >
<div  class="padT23">
	<div class="con" id="con">
		<div id="tab_zzjs_1">
			<span class="positon">
			</span>
			<div class="indexSearchBox push"  id="td"style="padding:10px;">
				<div>
				<a href="javascript:deleteRule();" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除配置规则</a>
				<a href="javascript:enable();" class="easyui-linkbutton" iconCls="icon-check" plain="true">启用配置规则</a>
				<a href="javascript:disable() ;" class="easyui-linkbutton" iconCls="icon-disable" plain="true">禁用配置规则</a>
				</div>
				<form id="queryFormID">
			      <label for="dept">请选择部门:</label> <input id="select_dept" class="easyui-combobox" name="dept" url='../../dataupload/getDept.action' editable="false" data-options="valueField:'code',textField:'name',multiple:false,onSelect:getKind"/>
				  <label for="kind">请选择信息类别:</label> <input id="select_kind" class="easyui-combobox" name="kind" editable="false" data-options="valueField:'code',textField:'name',multiple:false,onSelect:getColumn"/>
			      <label for="column">字段名称:</label> <input id="select_column" class="easyui-combobox" name="column" editable="false" data-options="valueField:'code', textField:'name',multiple:false"/>
			     <a href="javascript:void(0);"  onclick="query();" class="easyui-linkbutton" iconCls="icon-search" >查询</a>
			     <a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="conditionReset();">重置</a>
			     </form>
		    </div>
		    <div class="place">
				<span>位置：</span>
				<ul class="placeul">
						<li><%=request.getAttribute("path") %></li>
				</ul>
			</div>
			<table id="dg" style="width:100%;"></table>
			<div id="ruleWin" class="easyui-dialog" title="规则配置" style="width:600px;height:400px;padding:10px 20px" closed="true" buttons="#dlg-buttons">
				<div class="padT23">
					<input type="hidden" id="fieldID"/>
					<table id="addtable" style="width:auto;height: auto; padding: 5px" 
				data-options="rownumbers:true,singleSelect:false,checkOnSelect:true,collapsible:true,selectOnCheck:true,fitColumns:true, method:'post', iconCls:'icon-user'">
								<thead>
					<tr>
						<th field="ck" checkbox="true" width="10%"></th>
						<th field="name"  width="20%" align="left" >规则名称</th>
						<th field="id" data-options="hidden:true"></th>
						<th field="formula"  width="30%" align="left" >规则公式</th>
						<th field="dsc" width="40%" align="left" >规则描述</th>	
					</tr>
				</thead>
				</table>
				</div>
				<div id="dlg-buttons">
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-save"  onclick="saveRule();" style="width:66px">提交</a>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="$('#ruleWin').dialog('close');" style="width:66px">取消</a>
				</div>
			</div>
		</div>
	</div>
	</div>
</body>
</html>

