<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String basePath = request.getScheme() + "://" + request.getServerName() 
			+ ":" + request.getServerPort() + request.getContextPath() + "/";
	pageContext.setAttribute("basePath", basePath);
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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





	//归集部门下拉列表获取
	var bumenURL = "<%=basePath%>system/guijixx/getDepartment.action";
	jQuery(function() {
		$.getJSON(bumenURL, function(json) {
			$("#bmName").combobox({
				data : json.rows,
				valueField : 'value',
				textField : 'text'
			});
		});
	});

	$(function() {
		$("#dg")
				.datagrid(
						{
							//title: '信息分类',
							height : 400,
							striped : true,
							rownumbers : true,
							checkOnSelect : false,
							pagination : true,
							singleSelect : true,
							toolbar : '#tb',
							iconCls : 'icon-user',
							url : "<%=basePath%>creditInfo/getCreditBaseInGJZ.action",
							loadMsg : "载入中...请等待.",
							 onLoadSuccess : function () {
								 $(this).datagrid("fixRownumber");
								 $(this).datagrid("resize");
									    },
							columns : [ [
									{
										field : "企业注册号",
										title : "工商注册号",
										width : 320,
										align : 'left'
									},
									{
										field : "企业名称",
										title : "企业名称",
										width : 320,
										align : 'left'
									},
									{
										field : "组织机构代码",
										title : "组织机构代码",
										width : 320,
										align : 'left'
									},
									{
										field : "opr",
										title : "操作",
										width : 100,
										align : 'left',
										formatter : function(value, row, index) {
											return "<a href='#' class='tablelink' style='font-size:12px;color:blue' onclick='showQueryTip(&#039;"
													+ row.组织机构代码
													+ "&#039;,&#039;"
													+ row.企业注册号
													+ "&#039;,&#039;"
													+ row.企业名称
													+ "&#039;)'>"
													+ "查看 "
													+ "</a>";
										}
									} ] ]

						});
	});

	
	function showQueryTip(zzjgdm,gszch,qymc) {
		window.open('<%=basePath%>creditInfo/getDetailInfo.action?zzjgdm='+zzjgdm+'&gszch='+gszch+'&qymc='+qymc);
		//window.location.href = '<%=basePath%>creditInfo/getDetailInfo.action?zzjgdm='+zzjgdm+'&gszch='+gszch+'&qymc='+qymc;
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
	
	function conditionSearch(){
		setFirstPage("#dg");
		var gjz = $.trim($('#gjz').val());
		if(gjz=="-"){
			gjz="'";
		}
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams["gjz"] = gjz;
		if(gjz==''){
			queryParams["searchFlg"] = "0";
			}else{
				queryParams["searchFlg"] = "1";
				}
    	$('#dg').datagrid('options').queryParams = queryParams;
    	$("#dg").datagrid('reload');
	}
//重置
function clearSearch(){
	$('#cfrom').form('reset');
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
.pagination-page-list,
.pagination .pagination-num {
  width:50px;
}

</style>
</head>
<body style="height:450px">
	<div class="padT23">
		
		<div id="tb" style="padding:5px;height:auto">
				<form id="cfrom" >
				关键字： <input id="gjz" class="easyui-textbox" data-options="prompt:'工商注册号/企业名称/组织机构代码/法人代表/注册类型/经营范围'"
					style="width: 400px">&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="conditionSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearSearch();">重置</a>
				</form>
		</div>
		
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
		<table id="dg"></table>
	</div>
</body>
<script type="text/javascript">
function onSelect(d) {
    var issd = this.id == 'kssj', sd = issd ? d : new Date($('#kssj').datebox('getValue')), ed = issd ? new Date($('#jssj').datebox('getValue')) : d;
    //
    var y_sd = sd.getFullYear();
    var m_sd = sd.getMonth()+1;
    var d_sd = sd.getDate();
    
    var y_ed = ed.getFullYear();
    var m_ed = ed.getMonth()+1;
    var d_ed = ed.getDate();
    
    var strDate = y_sd+"-"+m_sd+"-"+d_sd;
    var endDate = y_ed+"-"+m_ed+"-"+d_ed;
    var v = $('#kssj').datebox('getValue');   
    if (v != '')
    {
	    if (endDate < strDate) {
	        $.messager.alert('选择','结束日期小于开始日期!','info');
	        //只要选择了日期，不管是开始或者结束都对比一下，如果结束小于开始，则清空结束日期的值并弹出日历选择框
	        $('#kssj').datebox('setValue', '');
	        $('#jssj').datebox('setValue', '');
	        
	    }
    }
    }
</script>
<style type="text/css">
.datagrid-cell-c1-itemid { //其中datagrid-cell是固定的。c1代表第一个表格 itemid代表第一列，具体你可用google等工具查看当前元素的class属性。特别注意的是因为变化的，所以这段代码要放到body标签里面的最后面。
width: 33px; //你需要设置的宽度。
}
</style> 
</html>