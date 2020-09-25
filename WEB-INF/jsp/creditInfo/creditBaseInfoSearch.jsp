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
							height : 440,
							striped : true,
							rownumbers : true,
							checkOnSelect : false,
							pagination : true,
							singleSelect : true,
							toolbar : '#tb',
							iconCls : 'icon-user',
							url : "<%=basePath%>creditInfo/getCreditBaseInfoList.action",
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
		var gszch = $.trim($('#gszch').val());
		var qymc = $.trim($('#qymc').val());
		var zzjgdm = $.trim($('#zzjgdm').val());
		var qyfl = $('#qyfl').combobox('getValue');
		var hyfl = $('#hyfl').combobox('getValue');
		var kssj = $('#kssj').datebox('getValue'); 
		var jssj = $('#jssj').datebox('getValue');
		var qylx = $('#qylx').combobox('getValue');
		var zcdz = $.trim($('#zcdz').val());
		var xzqy = $('#xzqy').combobox('getValue');
		var sxdj = $('#sxdj').combobox('getValue');
		var jyfw = $.trim($('#jyfw').val());
		if(gszch=="-"){
			gszch="'";
		}
		if(zzjgdm=="-"){
			zzjgdm="'";
		}
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams["gszch"] = gszch;
		queryParams["qymc"] = qymc;
		queryParams["zzjgdm"] = zzjgdm;
		queryParams["qyfl"] = qyfl;
		queryParams["hyfl"] = hyfl;
		queryParams["kssj"] = kssj;
		queryParams["jssj"] = jssj;
		queryParams["qylx"] = qylx;
		queryParams["zcdz"] = zcdz;
		queryParams["xzqy"] = xzqy;
		queryParams["sxdj"] = sxdj;
		queryParams["jyfw"] = jyfw;
		queryParams["searchFlg"] = "1";
    	$('#dg').datagrid('options').queryParams = queryParams;
    	$("#dg").datagrid('reload');
	}
//重置
function clearSearch(){
	$('#gszch').val('');
	$('#qymc').val('');
	$('#zzjgdm').val('');
	$('#qyfl').combobox('clear');
	$('#hyfl').combobox('clear');
	$('#zcdz').val('');
	$('#jyfw').val('');
	$('#qylx').combobox('clear');
	$('#xzqy').combobox('clear');
	$('#sxdj').combobox('clear');
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
		<div id="tb" style="padding:5px; height:auto">
			<form id="cfrom" >
				<table cellpadding="5" border="0" width="100%">
					<tr style="height:25px;">
						<td style="text-align:right;">工商注册号：</td>
						<td><input id="gszch" class="easyui-textbox" style="width: 204px;"></td>
						<td style="text-align:right;">企业名称：</td>
						<td><input id="qymc" class="easyui-textbox" style="width: 204px"></td>
						<td style="text-align:right;">组织机构代码：</td>
						<td><input id="zzjgdm" class="easyui-textbox" style="width: 204px"></td>
					</tr>
					<tr style="height:25px;">
						<td style="text-align:right;">行业分类：</td>
						<td><input id="hyfl"  style="width:204px;" class="easyui-combobox"  editable="false"
								url='<%=basePath%>enterpriseanalysis/getHylxList.action' 
									data-options="valueField:'code', textField:'name',multiple:false"/>
						</td>
						<td style="text-align:right;">企业分类：</td>
						<td><input id="qyfl" class="easyui-combobox" style="width:204px" class="easyui-combobox"  editable="false"
								url='<%=basePath%>enterpriseanalysis/getQylxList.action' 
									data-options="valueField:'code', textField:'name',multiple:false"/>
						</td>
						<td style="text-align:right;">注册时间：</td>
						<td>
							<input id="kssj" class="easyui-datebox"  data-options="editable:false,onSelect:onSelect,prompt:'开始时间'" 
								style="width:99px">
							<input id="jssj" class="easyui-datebox"  data-options="editable:false,onSelect:onSelect,prompt:'结束时间'"
								style="width:100px">
						</td>
					</tr>
					<tr style="height:25px;">
						<td style="text-align:right;">注册类型：</td>
						<td><input id="qylx" class="easyui-combobox" style="width:204px" class="easyui-combobox"  editable="false"
								url='<%=basePath%>creditInfo/getZclxList.action' 
									data-options="valueField:'code', textField:'name',multiple:false"/>
						</td>
						<td style="text-align:right;">注册地址：</td>
						<td><input id="zcdz" class="easyui-textbox" style="width: 204px;"></td>
						<td style="text-align:right;">行政区域：</td>
						<td><input id="xzqy" class="easyui-combobox" style="width:204px" class="easyui-combobox"  editable="false"
								url='<%=basePath%>creditInfo/getXzqhList.action' 
									data-options="valueField:'code', textField:'name',multiple:false"/>
						</td>
					</tr>
					<tr style="height:25px;">
						<td style="text-align:right;">经营范围：</td>
						<td><input id="jyfw" class="easyui-textbox" style="width: 204px;"></td>
						<td style="text-align:right;">失信等级：</td>
						<td><input id="sxdj" class="easyui-combobox" style="width:204px"   editable="false" panelHeight="auto"
								data-options="editable:false,valueField:'value',textField:'text',data:[{'value':'一般','text':'一般失信'},{'value':'较重','text':'较重失信'},{'value':'严重','text':'严重失信'}]"/></td>
						<td style="text-align:right;"><a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">查询</a></td><td>&nbsp;&nbsp;<a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="clearSearch();">重置</a></td>
					</tr>
				</table>
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
var sd;
var ed;
function onSelect(d)
{
	switch(this.id)
	{
		case 'kssj':
		  sd = d;
		  break;
		case 'jssj':
		  ed = d;
		  break;
	}
	
	if((sd != '' && sd != null && sd != 'undefined') && (ed != '' && ed != null && ed != 'undefined'))
	{
		var sdtime = sd.getTime();
		var edtime = ed.getTime();
		
		if(edtime-sdtime < 0)
		{
			$.messager.alert('选择','结束日期小于开始日期!','info');
	        //只要选择了日期，不管是开始或者结束都对比一下，如果结束小于开始，则清空结束日期的值并弹出日历选择框
	        $('#kssj').datebox('setValue', '');
	        sd = null;
	        $('#jssj').datebox('setValue', '');
	        ed = null;
		}
	}
}
</script>
</html>