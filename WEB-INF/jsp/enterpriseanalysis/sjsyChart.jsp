<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String basePath = request.getScheme() + "://" + request.getServerName() 
			+ ":" + request.getServerPort() + request.getContextPath() + "/";
	pageContext.setAttribute("basePath", basePath);
%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.4/themes/color.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script> 
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
    <script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
  <script type="text/javascript" src="http://cdn.hcharts.cn/highcharts/highcharts.js"></script>
  <script type="text/javascript" src="http://cdn.hcharts.cn/highcharts/highcharts-more.js"></script>
  <link rel="stylesheet" type="text/css" href="<%=basePath%>js/datepicker/skin/WdatePicker.css">
	<script type="text/javascript" src="<%=basePath%>js/datepicker/WdatePicker.js"></script>
  <script>
//采用jquery easyui loading css效果
  function ajaxLoading(){
      $("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body");
      $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候...").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
   }
   function ajaxLoadEnd(){
       $(".datagrid-mask").remove();
       $(".datagrid-mask-msg").remove();            
  }
  
$(function(){
	getsjsyForDeptChart();
	getsjsyForInfoChart();
	
})
  

function getsjsyForInfoChart(){
	var deptCode=$("#dept").combobox('getValues');
	var info=$("#info").val();
	var timeBegin=$("#timeBegin").val();
	var timeEnd=$("#timeEnd").val();
	deptCode=encodeURI(encodeURI(deptCode, "UTF-8"), "UTF-8");
	info=encodeURI(encodeURI(info, "UTF-8"), "UTF-8");
	var sjsyForInfoUrl="<%=basePath%>enterpriseanalysis/sjsyForInfo.action?deptCode="+deptCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd+"&infoName="+info;
	$.ajax({
            url: sjsyForInfoUrl,
            dataType: 'json',
            beforeSend:ajaxLoading,//发送请求前打开进度条
            success:function(ret){ 
        var amounts=new Array();
        var info=new Array();
        var totalSum=0;   
        $.each(ret,function(i,d){
        	amounts.push(parseInt(d.amount));
        	info.push(d.INFOMATIONSORT);
        	totalSum= totalSum+parseInt(d.amount);
        });
        
        if(totalSum==0){	
          	$('#container').hide();
          	$('#container2').hide();
        	$('#enterTable').hide();
          	$('#enterTable2').hide();
          	$('#hint').show();
          	
          }else{
          	$('#hint').hide();
          	$('#container').show();
          	$('#container2').show();
          	$('#enterTable').show();
          	$('#enterTable2').show();
          }
       
		 $('#container').highcharts({ 
			 chart: { type: 'column' }, 
			  credits: {
	                enabled:false
	            },
			 title: { text: '数据使用统计（分信息项）' },
			  xAxis: {
				 labels: {    
			      //  rotation: -45
			    },
				   categories: info
				}, 
			  yAxis: { min: 0, title: { text: '数据使用次数' } }, 
			  legend: { backgroundColor: '#FFFFFF', reversed: true },
			   plotOptions: { series: { stacking: 'normal' } },
			    series: [
						    { name: '信息使用次数', data: amounts}
					    ]
						     });

          
          var htmlStr = "<tr style='background-color:#81AACF'><td height='40px'>序号</td><td>使用信息</td>"+
              "<td>使用次数</td></tr>";
           
          $.each(ret,function(i,d){
              htmlStr=htmlStr+"<tr><td height='30px'>"+(i+1)+"</td><td><a href='#' onclick=\"filteForInfo('"+d.INFOMATIONSORT+"')\" style=\"text-decoration:underline;color:blue\">"+d.INFOMATIONSORT+"</a></td>"+
              "<td>"+d.amount+"</td></tr>";
          });
          var enterTable = "<span>信息使用统计表</span><table border='1' style='width:400px;text-align:center;' align='center'>"+htmlStr+"</table>";
            $("#enterTable").html(enterTable);
		
            ajaxLoadEnd();//任务执行成功，关闭进度条  
			}
            });
}


function getsjsyForDeptChart(){
	var deptCode=$("#dept").combobox('getValues');
	var info=$("#info").val();
	var timeBegin=$("#timeBegin").val();
	var timeEnd=$("#timeEnd").val();
	deptCode=encodeURI(encodeURI(deptCode, "UTF-8"), "UTF-8");
	info=encodeURI(encodeURI(info, "UTF-8"), "UTF-8");
	var sjsyForDeptUrl="<%=basePath%>enterpriseanalysis/sjsyForDept.action?deptCode="+deptCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd+"&infoName="+info;
	$.ajax({
            url: sjsyForDeptUrl,
            dataType: 'json',
            beforeSend:ajaxLoading,//发送请求前打开进度条
            success:function(ret){ 
        var amount=new Array();
        var dept=new Array();
        for(var w=0;w<ret.length;w++){
        	amount.push(parseInt(ret[w].amount));
            }
        for(var w=0;w<ret.length;w++){
        	dept.push(ret[w].dept);
                }
       
		 $('#container2').highcharts({ 
			 chart: { type: 'column' }, 
			  credits: {
	                enabled:false
	            },
			 title: { text: '数据使用统计（分部门）' },
			  xAxis: {
				   categories:dept
				}, 
			  yAxis: { min: 0, title: { text: '数据使用次数' } }, 
			  legend: { backgroundColor: '#FFFFFF', reversed: true },
			   plotOptions: { series: { stacking: 'normal' } },
			    series: [
						    { name: '信息使用次数', data: amount}
					    ]
						     });

          
          var htmlStr = "<tr style='background-color:#81AACF'><td height='40px'>序号</td><td>使用部门</td>"+
              "<td>使用次数</td></tr>";
           
          $.each(ret,function(i,d){
              htmlStr=htmlStr+"<tr><td height='30px'>"+(i+1)+"</td><td><a href='#' onclick=\"filteForDept('"+d.dept+"')\" style=\"text-decoration:underline;color:blue\">"+d.dept+"</a></td>"+
              "<td>"+d.amount+"</td></tr>";
          });
          var enterTable = "<span>部门使用统计表</span><table border='1' style='width:400px;text-align:center;' align='center'>"+htmlStr+"</table>";
            $("#enterTable2").html(enterTable);
		
            ajaxLoadEnd();//任务执行成功，关闭进度条 
			}
            });
}
 
	
	function enterpriseSearch(){
		getsjsyForDeptChart();
		getsjsyForInfoChart();
	
	}


	function filteForInfo(info){
		 $("#info").val(info);
		 getsjsyForDeptChart();
		}

	function filteForDept(dept){
		var depts=new Array();
		depts.push(dept);
		 $("#dept").combobox('setValues',depts);
		 getsjsyForInfoChart();
		}
	
	function clearEnterpriseSearch(){
	  $("#dept").combobox('setValues',[]);
	  $("#timeBegin").val('');
	  $("#timeEnd").val('');	
	  $("#info").val('');
	}

	function exportExcel(){

		var deptCode=$("#dept").combobox('getValues');
		var info=$("#info").val();
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		deptCode=encodeURI(encodeURI(deptCode, "UTF-8"), "UTF-8");
		info=encodeURI(encodeURI(info, "UTF-8"), "UTF-8");
		window.location.href="<%=basePath%>enterpriseanalysis/sjsyExport.action?deptName="+deptCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd+"&infoName="+info;
	}


	 
  </script>
</head>
<body>
<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
	<div id="tb" style="padding:5px;height:auto">
				<label for="depts">使用部门:</label> <input 
					class="easyui-combobox" id="dept" editable="false"
					url='<%=basePath%>enterpriseanalysis/getDetpList.action' 
					data-options="valueField:'name', textField:'name',multiple:true">
				</input>
				使用信息:&nbsp;<input  class="easyui-input"   id="info" style="width: 150px"/>&nbsp; 
				上报起始时间:&nbsp;<input  class="Wdate" type="text"  id="timeBegin"
	   		onfocus="WdatePicker({skin:'whyGreen',maxDate:'#F{$dp.$D(\'timeEnd\')}'})"/>&nbsp; 
				上报截止时间:&nbsp;<input  class="Wdate" type="text"  id="timeEnd"
	   		onfocus="WdatePicker({skin:'whyGreen',minDate:'#F{$dp.$D(\'timeBegin\')}'})"/>&nbsp; 
				<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="enterpriseSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearEnterpriseSearch();">重置</a>
					 <a href="#"
					class="easyui-linkbutton" iconCls="icon-export"
					onclick="exportExcel();">导出</a>
		</div>
		<div style="min-height:600px;width: 100%">
	<div id='hint' style="display:none;"><br>
	<font color="red" size="5">&nbsp;&nbsp;&nbsp;此查询条件无统计结果，请重新选择条件后查询，谢谢！</font>
	</div>	
  <div id="container" style="width:45%;height:500px;float:left;padding-right:40px;"></div>
  <div id="container2" style="width:45%;height:500px;float:left;"></div>
   <div  id="enterTable" align="center"style="width:45%;float:left;margin-right:30px"  ></div>
   <div  id="enterTable2" align="center" style="width:45%;float:left;"  >  
    </div>
  </div>
</body>
</html>




