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
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
<title>重点人群信用核查</title>
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
							url : "<%=basePath%>creditVerification/getgroupsCreditBaseVerificationList.action",
							loadMsg : "载入中...请等待.",
							 onLoadSuccess : function () {
								 $(this).datagrid("fixRownumber");
									    },
							columns : [ [
									{
										field : "姓名",
										title : "姓名",
										width : 150,
										align : 'center'
									},
									{
										//field : "身份证号码",
										field : "身份证号码",
										title : "身份证号码",
										width : 150,
										align : 'center'
									},							
									{
										field : "生成时间",
										title : "生成时间",
										width : 150,
										align : 'center'
									},
									{
										field : "查询码",
										title : "查询码",
										width : 120,
										align : 'center'
									},									
									{
										field : "有效期",
										title : "有效期",
										width : 100,
										align : 'center'
									} ] ]

						});
	});


		
	function setFirstPage(ids){
    	var opts = $(ids).datagrid('options');
		var pager = $(ids).datagrid('getPager');
		opts.pageNumber = 1;
    	opts.pageSize = opts.pageize;
		pager.pagination('refresh',{
	    	pageNumber:1,
	    	pageSize:opts.pageSize
		});
	}
	
//查询
function cvInfoSearch(){
   var checkcode=document.getElementById('checkcode').value;
	if(checkcode==""){
	alert("核查码不能为空！");
	return false;
	 }
	//$('#ccform').submit();
	   var check = '${check}';
   if (check == 'Y') {
	  window.open("<%=basePath%>creditVerification/getgroupsDetailVerificationInfo.action?checkcode=" + checkcode, 'newwindow','height=900,width=1000,top='+(window.screen.availHeight-30-900)/2+
	            ',left='+(window.screen.availWidth-10-1000)/2+
	            ',toolbar=no,menubar=no,scrollbars=yes,resizable=yes,location=no,status=no');
	} else {
	  window.location.href = "<%=basePath%>creditVerification/getgroupsDetailVerificationInfo.action?checkcode=" + checkcode;
	}
	
}

 function showError(){
  var msg = document.getElementById('Msg').value;
   if(msg != ""){
     alert(msg);
   }
 
 }


//自查
function selfSearch(){

	var zylx = "律师";
	zylx=encodeURI(encodeURI(zylx,'utf-8'),'utf-8');
		var check = '${check}';
	if (check == 'Y') {
	  window.open("<%=basePath%>creditVerification/getgroupsSelfDetailVerificationInfo.action?&zylx="+zylx, 'newwindow','height=900,width=1000,top='+(window.screen.availHeight-30-900)/2+
	            ',left='+(window.screen.availWidth-10-1000)/2+
	            ',toolbar=no,menubar=no,scrollbars=yes,resizable=yes,location=no,status=no');
	} else {
	     window.location.href = "<%=basePath%>creditVerification/getgroupsSelfDetailVerificationInfo.action?&zylx="+zylx;
	}
}

 function createCheckCode(){
     var zylx = "律师";
     zylx=encodeURI(encodeURI(zylx,'utf-8'),'utf-8');
     $.ajax({
	    type:"post",
	    url:"<%=basePath%>creditVerification/togroupsCreateCheckCode.action?zylx="+zylx,
	    async:false,
	   	data:{},
	   	dataType:"json",
	   	success:function(data){
	   		if(data != null){
			    $("#dg").datagrid('reload');
		   		$.messager.confirm("提示","信用核查码生成成功，确定保存吗？", function(r){
			   		if(r){
						var zdrqxm = data.zdrqxm;
			   			zdrqxm=encodeURI(zdrqxm,"UTF-8");
			   			zdrqxm=encodeURI(zdrqxm,"UTF-8");
			   			var zczsh = data.zczsh;
			   			zczsh=encodeURI(zczsh,"UTF-8");
			   			zczsh=encodeURI(zczsh,"UTF-8");
			   			var ccode = data.ccode;
			   			var zylb = data.zylb;
			   			zylb=encodeURI(zylb,"UTF-8");
			   			zylb=encodeURI(zylb,"UTF-8");
			   			var creattime2 = data.creattime2;
			   			var validtime = data.validtime;
			   			window.location.href = "<%=basePath%>creditVerification/togroupsCreatePDF.action?zdrqxm="+zdrqxm+"&zczsh="+zczsh+"&ccode="+ccode+"&zylb="+zylb+"&creattime2="+creattime2+"&validtime="+validtime;
			   		}
		   		});
	   			} else{
	            return false;
	          }
	    }
	});
	$('#win').window('close');
}

 function openWin(){
	$('#win').window('open');  
}

//重置
function clearSearch(){
	$('#checkcode').val('');
}
//关闭
function closeWin(){
	$('#win').window('close');
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
<body style="height:450px" onload="showError();">
	<div class="padT23">
		<div id="tb" style="padding:5px;height:auto;">
				<form id="ccform" name="ccform" action="<%=basePath%>creditVerification/getgroupsDetailVerificationInfo.action" method="post">
				<input type="hidden" id="Msg" value="${Msg }">
				<input type="hidden" id="zylx" name="zylx" value="%25E5%25BE%258B%25E5%25B8%2588">
				<!--  核查查询码： <input id="checkcode" name ="checkcode" type="text" class="easyui-validatebox" data-options="required:true" 
					style="width: 100px">&nbsp; 
					<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="cvInfoSearch();">查询重点人群信用报告</a>&nbsp;&nbsp;
					<a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearSearch();">重置</a>&nbsp;&nbsp;-->
					<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="selfSearch();">自查信用报告</a>&nbsp;&nbsp;
					<a href="#" id="ccd"
					class="easyui-linkbutton" iconCls="icon-add"
					onclick="createCheckCode();">生成并保存查询码</a>
				
					</form>									
		</div><!--  
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>-->
		<table id="dg"  width="698px"></table>
	</div>
</body>
</html>