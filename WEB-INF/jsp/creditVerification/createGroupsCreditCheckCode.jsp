<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.idTabs.min.js"></script>
<title>信用核查</title>
<script type="text/javascript">
//确定生成
	function savecode(){
	
	        	$('#checkCodeForm').submit();
		
	}
	
	
	function printcode(printpage)
	{
	var headstr = "<html><head><title></title></head><body>";
	var footstr = "</body>";
	var newstr = document.all.item(printpage).innerHTML;
	var oldstr = document.body.innerHTML;
	document.body.innerHTML = headstr+newstr+footstr;
	window.print(); 
	document.body.innerHTML = oldstr;
	return false;
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

.clear{height:30px}
</style>
</head>
<body style="overflow:auto;">
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li>信用核查</li>
			<li>信用核查凭证单</li>
		</ul>
	</div>
	<div class="rightinfo">
	<div style="width:90%;margin:0 auto;text-align:center"> 
	<div id="div_print">   
	   <p>
       	<font style="font-size:30px;">${baseInfo.XM}</font><br /><br />
       	<font style="font-size:25px;float:left">一、重点人群标识信息</font><br />
       </p>
       
	      <table bordercolor="black" border="1" cellspacing="1" style="table-layout:fixed;word-break:break-all word-wrap:break-word;width:100%;text-align:center;margin-top:30px;margin:0  auto;">
			    	<tr height="60px">
			    		<th width="40%" style="font-size:20px">姓名</th>
			    		<th width="20%" style="font-size:20px">身份证号</th>
			    		<th width="20%" style="font-size:20px">注册证书号</th>
			    		<th width="20%" style="font-size:20px">执业类别</th>
			    	</tr>
			      	<tr height="60px">
			    		<td width="40%" style="font-size:18px">${baseInfo.XM}</td>
			    		<td width="20%" style="font-size:18px">${baseInfo.SFZH}</td>
			    		<td width="20%" style="font-size:18px">${baseInfo.ZCZSH}</td>
			    		<td width="20%" style="font-size:18px">${baseInfo.ZYLB}</td>
			    	</tr> 	
	      </table>
	      <div class="clear"></div>
	      
	      <div style="width:100%;height:140px">
	      	<p style="height:30px">
       			<font style="font-size:25px;float:left">二、信用核查授权码</font>
       		</p>
 			<div class="clear"></div>
	      	<div style="float:left;font-size:20px">
				&nbsp;信用核查授权码：<font style="font-size:22px;font-weight:700">${ccode}</font><br /><br />
				有效期：<font style="font-size:22px;font-weight:700">${creattime}~${validtime}</font>
			</div>
	      </div>  
	      
		  <div class="clear"></div>
	      
	      <div>
	      	<p style="height:30px">
       			<font style="font-size:25px;float:left">使用说明：</font>
       		</p>
 			<div class="clear"></div>
	      	<div style="float:left;font-size:20px">
				<span style="float:left;font-size:20px">1、在信用核查码有效期内，被授权个人可以通过“XX通”在线核查授权个人的信用核查结果信息。</span><br />
				<span style="float:left;font-size:20px">2、超过信用核查授权码有效期，信用核查凭证单自动失效。</span><br />
				<span style="float:left;font-size:20px">3、授权个人对各自授权负责，请个人谨慎进行授权操作。</span>
			</div>
	      </div>  
	      
	      
	      <div style="margin-top:200px">
	      	<div style="float:right;font-size:20px;margin-right:200px">
				　授权人名称：（盖章）  <br />         
				日期：
			</div>
	      </div> 
	     </div>      
	      <div class="clear"></div>
	     <div style="margin-top:50px">
	     
			<a id="" class="easyui-linkbutton l-btn l-btn-small" onclick="window.history.back()" iconcls="icon-cancel" href="javascript:void(0)" group="">
			    <span class="l-btn-left l-btn-icon-left">返回</span>
			</a>	     
	     
			<a id="" class="easyui-linkbutton l-btn l-btn-small" onclick="savecode()" iconcls="icon-save" href="javascript:void(0)" group="">
			    <span class="l-btn-left l-btn-icon-left">保 存</span>
			</a>
			
			<a id="" class="easyui-linkbutton l-btn l-btn-small" onclick="printcode('div_print')" iconcls="icon-print" href="javascript:void(0)" group="">
			    <span class="l-btn-left l-btn-icon-left">打印</span>
			</a>
	     </div>   
	      
      </div>
      
      
      	<div id="winEdit" class="easyui-window" title="生成查询码"
		data-options="modal:true, iconCls:'icon-add', closed:true, tools:'#tt',minimizable:false"
		style="width:680px;height:200px;padding:10px;">
		
		<form id="checkCodeForm" method="post" action="<%=basePath%>creditVerification/creditgroupsSaveCheckCode.action">

			<input type="hidden" id="ckcode" name="ckcode" value="${ccode}">
			<input type="hidden" name="sfzhm" id="sfzhm" value="${baseInfo.SFZH}">
			<input type="hidden" name="zdrqxm" id="zdrqxm" value="${baseInfo.XM}">	
			<input type="hidden" name="creattime" id="createtime" value="${createtime}">
			<input type="hidden" name="validtime" id="validtime" value="${validtime}">	
			<textarea rows="20" cols="20" style="display:none" name="tableinfo" id="tableinfo">
				<div style="width:100%;margin:0 auto;text-align:center"> 
					<div id="div_print">   
					   <p>
				       	<font style="font-size:30px;">${baseInfo.XM}</font><br /><br />
				       	<font style="font-size:25px;float:left">一、重点人群标识信息</font><br />
				       </p>
				       
					      <table bordercolor="black" border="1" cellspacing="1" style="table-layout:fixed;word-break:break-all word-wrap:break-word;width:100%;text-align:center;margin-top:30px;margin:0  auto;">
							    	<tr height="60px">
							    		<th width="20%" style="font-size:20px">姓名</th>
							    		<th width="35%" style="font-size:20px">身份证号</th>
							    		<th width="25%" style="font-size:20px">注册证书号</th>
							    		<th width="20%" style="font-size:20px">执业类别</th>
							    	</tr>
							      	<tr height="60px">
							    		<td width="40%" style="font-size:18px">${baseInfo.XM}</td>
							    		<td width="20%" style="font-size:18px">${baseInfo.SFZH}</td>
							    		<td width="20%" style="font-size:18px">${baseInfo.ZCZSH}</td>
							    		<td width="20%" style="font-size:18px">${baseInfo.ZYLB}</td>
							    	</tr> 	
					      </table>
					      <div class="clear"></div>
					      
					      <div style="width:100%;height:140px">
					      	<p style="height:30px">
				       			<font style="font-size:25px;float:left">二、信用核查授权码</font>
				       		</p>
				 			<div class="clear"></div>
					      	<div style="float:left;font-size:20px">
								&nbsp;信用核查授权码：<font style="font-size:22px;font-weight:700">${ccode}</font><br /><br />
								有效期：<font style="font-size:22px;font-weight:700">${creattime}~${validtime}</font>
							</div>
					      </div>  
					      
						  <div class="clear"></div>
					      
					      <div>
					      	<p style="height:30px">
				       			<font style="font-size:25px;float:left">使用说明：</font>
				       		</p>
				 			<div class="clear"></div>
					      	<div style="float:left;font-size:20px">
								<span style="float:left;font-size:20px">1、在信用核查码有效期内，被授权个人可以通过“XX通”在线核查授权个人的信用核查结果信息。</span><br />
								<span style="float:left;font-size:20px">2、超过信用核查授权码有效期，信用核查凭证单自动失效。</span><br />
								<span style="float:left;font-size:20px">3、授权个人对各自授权负责，请个人谨慎进行授权操作。</span>
							</div>
					      </div>  
					      
					      
					      <div style="margin-top:200px">
					      	<div style="float:right;font-size:20px;margin-right:200px">
								　授权人名称：（盖章）  <br />         
								日期：
							</div>
					      </div> 
					     </div>        	      
				      </div>
			</textarea>		
		</form>
		<div style="text-align:center;padding:15px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				onclick="saveCheckCode();">确定</a> <a href="javascript:void(0)"
				class="easyui-linkbutton" onclick="closeWin()">关闭</a>
		</div>

	</div>
	</div>
</body>
</html>