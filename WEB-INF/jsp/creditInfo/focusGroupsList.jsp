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


	//$(function() {
	function getData(){	
		var zylx=$('#zylx').combobox('getValue');
		zylx=encodeURI(encodeURI(zylx,'utf-8'),'utf-8');
	
		$("#dg").datagrid({
							height : 370,
							striped : true,
							rownumbers : true,
							checkOnSelect : false,
							pagination : true,
							singleSelect : true,
							toolbar : '#tb',
							iconCls : 'icon-user',
							url : '<%=basePath%>creditInfo/getFocusGroupsInfoList.action?zylx='+zylx,
							loadMsg : "载入中...请等待.",
							 onLoadSuccess : function () {
								 $(this).datagrid("fixRownumber");
								 $(this).datagrid("resize");
									    },
						    onLoadError:function(data){
						        alert("没有配置相应的基本信息表或配置的表中没有与查询条件对应的字段，请重新配置！");
						    },  
							columns : [ [
									{
										field : "XM",
										title : "姓名",
										width : 280,
										align : 'left'
									},
									{
										field : "SFZH",
										title : "身份证号",
										width : 300,
										align : 'left'
									},
									{
										field : "ZCZSH",
										title : "注册证书号",
										width : 280,
										align : 'left'
									},
									{
										field : "opr",
										title : "操作",
										width : 200,
										align : 'left',
										formatter : function(value, row, index) {
											return "<a href='#' class='tablelink' style='font-size:12px;color:blue' onclick='showDetail(&#039;"
													+ row.SFZH
													+ "&#039;)'>"
													+ "查看 "
													+ "</a>";
										}
									} ] ]

						});
//	});
	}
  

	function showDetail(id) {
		var zylx=$('#zylx').combobox('getValue');
		zylx=encodeURI(encodeURI(zylx,'utf-8'),'uft-8');
		window.open('<%=basePath%>creditInfo/getFocusGroupsDetail.action?sfzh='+id+'&zylx='+zylx);
		//window.location.href = '<%=basePath%>creditInfo/getFocusGroupsDetail.action?sfzh='+id+'&zylx='+zylx;
		}
	
	
	function showQueryTip(id) {
				$.ajax({
					url:"<%=basePath%>creditInfo/getFocusGroupsDetail.action?ID="+id,
					success:function(ret){
					var	data=eval("("+ret+")");
						//alert(data.HHRXM);
					$("#detail_name").text(data.XM);
					$("#detail_idNo").text(data.SFZH);
					$("#detail_zyzsbh").text(data.ZCZSH);

					$("#detail_DQ").text(data.DQ==null?"":data.DQ);
					$("#detail_BZNR").text(data.BZNR==null?"":data.BZNR);
					$("#detail_RYCH").text(data.RYCH==null?"":data.RYCH);
				 
					
					}
					});
		
	               $.parser.parse('#winEdit'); 
	               $('#winDetail').window({
	    			modal:true
				});
					$('#winDetail').window('open');
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
		var name = $.trim($('#name').val());
		var idNo = $.trim($('#idNo').val());
		var zylx = $.trim($('#zylx').combobox('getValue'));
		if(name=='&'){
			name="'";
		}
		if(idNo=='&'){
			idNo="'";
		}
		zylx=encodeURI(encodeURI(zylx,'utf-8'),'utf-8');
		name=encodeURI(encodeURI(name,'utf-8'),'utf-8');
		var urlStr='<%=basePath%>creditInfo/getFocusGroupsInfoList.action?name='+name+'&sfzhm='+idNo+'&zylx='+zylx;
		 $('#dg').datagrid('options').url=urlStr;
		
    	$("#dg").datagrid('reload');
	    
	}
//重置
function clearSearch(){
	$('#name').val('');
	$('#idNo').val('');
	$('#zylx').combobox({
		url:'<%=basePath%>creditArchives/getAllZylx.action',
		editable:false,valueField:'value',textField:'text',
        onLoadSuccess:function(data){
	         $('#zylx').combobox('setValue',data[0].value);
        }
		});
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
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
		
		<div id="tb" style="padding:5px;height:auto">
				姓名： <input id="name" class="easyui-input"
					style="width: 100px">&nbsp; 
				身份证号： <input id="idNo" class="easyui-input"
					style="width: 150px">&nbsp;
				职业类别：<input	id="zylx" style="width:100px" class="easyui-combobox"
				panelHeight="auto"	data-options="editable:false,valueField:'value',textField:'text',
				url:'<%=basePath%>creditInfo/getAllZylx.action',  
                onLoadSuccess:function(data){ $('#zylx').combobox('setValue',data[0].value);
                getData();
                }" /> 
				<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="conditionSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearSearch();">重置</a>
		</div>
		
		<table id="dg"></table>
	</div>
	
	
</body>
</html>