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
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script> 
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
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
							url : "<%=basePath%>creditApplication/getCreditBaseInfoList.action",
							loadMsg : "载入中...请等待.",
							 onLoadSuccess : function () {
								 $(this).datagrid("fixRownumber");
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
		window.open('<%=basePath%>creditApplication/getDetailInfo.action?zzjgdm='+zzjgdm+'&gszch='+gszch+'&qymc='+qymc);
		//window.location.href = '<%=basePath%>creditApplication/getDetailInfo.action?zzjgdm='+zzjgdm+'&gszch='+gszch+'&qymc='+qymc;
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
		var gszch = $.trim($('#gszch').val());
		var qymc = $.trim($('#qymc').val());
		var zzjgdm = $.trim($('#zzjgdm').val());
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams["gszch"] = gszch;
		queryParams["qymc"] = qymc;
		queryParams["zzjgdm"] = zzjgdm;
		if(gszch!=''||qymc!=''||zzjgdm!=''){
			queryParams["searchFlg"] = "1";
		}else{
			queryParams["searchFlg"] = "0";
			}
    	$('#dg').datagrid('options').queryParams = queryParams;
    	$("#dg").datagrid('reload');
	}
//重置
function clearSearch(){
	$('#gszch').val('');
	$('#qymc').val('');
	$('#zzjgdm').val('');
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
				工商注册号： <input id="gszch" class="easyui-input"
					style="width: 100px">&nbsp; 
				企业名称： <input id="qymc" class="easyui-input"
					style="width: 100px">&nbsp;
				组织机构代码： <input id="zzjgdm" class="easyui-input"
					style="width: 100px">&nbsp; 
					<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="conditionSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearSearch();">重置</a>
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
</html>