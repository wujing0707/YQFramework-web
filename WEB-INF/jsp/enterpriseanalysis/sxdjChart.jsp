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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
  <script type="text/javascript" src="<%=basePath%>js/jquery-highcharts-3.0.6/highcharts.js"></script>
  <script type="text/javascript" src="<%=basePath%>js/jquery-highcharts-3.0.6/highcharts-more.js"></script>
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
//  beforeSend:ajaxLoading,//发送请求前打开进度条
 //  ajaxLoadEnd();//任务执行成功，关闭进度条   
  
$(function(){
	getEnterpriseChat();
});
  
	function getEnterpriseChat(){
		var deptCode=$("#dept").combobox('getValues');
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		deptCode=encodeURI(encodeURI(deptCode, "UTF-8"), "UTF-8");
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/sxdj.action?deptCode="+deptCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
		$.ajax({
                url: enterpriseUrl,
                dataType: 'json',
                beforeSend:ajaxLoading,//发送请求前打开进度条
                success:function(ret){ 
            var yiban=new Array();
            var jiaozhong=new Array();
            var yanzhong =new Array();
			var yibanCount=0;
			var jiaozhongCount=0;
			var yanzhongCount=0;
            
            for(var w=0;w<ret.bar.yibanSum.length;w++){
			yiban.push(parseInt(ret.bar.yibanSum[w]));
			yibanCount=yibanCount+parseInt(ret.bar.yibanSum[w]);
                }
            for(var w=0;w<ret.bar.jiaozhongSum.length;w++){
            	jiaozhong.push(parseInt(ret.bar.jiaozhongSum[w]));
            	jiaozhongCount=jiaozhongCount+parseInt(ret.bar.jiaozhongSum[w]);
            	
                    }
            for(var w=0;w<ret.bar.yanzhongSum.length;w++){
            	yanzhong.push(parseInt(ret.bar.yanzhongSum[w]));
            	yanzhongCount=yanzhongCount+parseInt(ret.bar.yanzhongSum[w]);
                    }
            
            if(yibanCount==0&&jiaozhongCount==0&&yanzhongCount==0){
            	$('#container').hide();
            	$('#container2').hide();
            	$('#hint').show();
            }else{
            	$('#hint').hide();
            	$('#container').show();
            	$('#container2').show();
            }
			 $('#container').highcharts({ 
				 chart: { type: 'bar' }, 
				
				 credits: {
		                enabled:false
		            },
				 title: { text: '失信等级统计' },
				  xAxis: {
					   categories: ret.bar.depts 
					}, 
				  yAxis: {allowDecimals:false, //是否允许刻度有小数 
					  min: 0, title: { text: '失信企业数量' } }, 
				  legend: { backgroundColor: '#FFFFFF', reversed: true },
				   plotOptions: { series: { stacking: 'normal',events: { click: function(e) {//点击图上的值时会调用。this为series 
					   showPieChart(e.point.category);
				  } } } },
				    series: [
				             { name: '一般', data: yiban,color:"#0099FF"}, 
							    { name: '较重', data: jiaozhong,color:"yellow"}, 
							    { name: '严重', data: yanzhong,color:"black"}
						    ]
							     });
				//饼图
			  var pieData = new Array();
              //迭代，把异步获取的数据放到数组中
               pieData.push(["一般失信",yibanCount]);
               pieData.push(["较重失信",jiaozhongCount]);
               pieData.push(["严重失信",yanzhongCount]);

               
            
			 $('#container2').highcharts({ 
				 chart: { 
					  plotBackgroundColor: null,
					  plotBorderWidth: null,
					   plotShadow: false 
					   }, 
					   colors:['#0099FF','yellow','black'],
				   credits: {
		                enabled:false
		            },
		            legend: { 
		            	backgroundColor:'#ffffff',
		            	labelFormatter:function(){
		            		return this.name+'('+this.percentage.toFixed(1)+'%)';
		            	}	
		            },
				   title: { text: '失信等级占比图' }, 
				   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>' },
				    plotOptions: {series: { stacking: 'normal',events: { click: function(e) {//点击图上的值时会调用。this为series 
				    	showDetailList(null,e.point.name);
				    //alert(e.point.name);
					  } } }, 
				    	pie:
					{ size:'75%', allowPointSelect: true, cursor: 'pointer',
					    dataLabels: { enabled: false, color: '#000000',
					     connectorColor: '#000000',
					      format: '<b>{point.name}</b>: {point.percentage:.1f} %' },
					      showInLegend: true //是否显示图例
				   } },
					       series: [{ 
						       type: 'pie', name: '失信等级占比 ', 
						       data: pieData }]  
				   
			 });
   		
            ajaxLoadEnd();//任务执行成功，关闭进度条   
				}
	            });

        
	           
	}

	function showPieChart(deptName){
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		 
		deptCode=encodeURI(encodeURI(deptName, "UTF-8"), "UTF-8");
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/sxdj.action?deptCode="+deptCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
		$.ajax({
                url: enterpriseUrl,
                dataType: 'json',
                beforeSend:ajaxLoading,//发送请求前打开进度条
                success:function(ret){ 
			var yibanCount=0;
			var jiaozhongCount=0;
			var yanzhongCount=0;
		
		
            
            for(var w=0;w<ret.bar.yibanSum.length;w++){
			yibanCount=yibanCount+parseInt(ret.bar.yibanSum[w]);
                }
            for(var w=0;w<ret.bar.jiaozhongSum.length;w++){
            	jiaozhongCount=jiaozhongCount+parseInt(ret.bar.jiaozhongSum[w]);
            	
                    }
            for(var w=0;w<ret.bar.yanzhongSum.length;w++){
            	yanzhongCount=yanzhongCount+parseInt(ret.bar.yanzhongSum[w]);
                    }
			 
				//饼图
			  var pieData = new Array();
              //迭代，把异步获取的数据放到数组中
               pieData.push(["一般失信",yibanCount]);
               pieData.push(["较重失信",jiaozhongCount]);
               pieData.push(["严重失信",yanzhongCount]);

            
			 $('#container2').highcharts({ 
				 chart: { plotBackgroundColor: null,
				  plotBorderWidth: null,
				   plotShadow: false },
				   colors:['#0099FF','yellow','black'], 
				   credits: {
		                enabled:false
		            },
		            legend: { 
		            	backgroundColor:'#ffffff',
		            	labelFormatter:function(){
		            		return this.name+'('+this.percentage.toFixed(1)+'%)';
		            	}	
		            },
				   title: { text: '失信等级占比图' }, 
				   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>' },
				    plotOptions: { series: { stacking: 'normal',events: { click: function(e) {//点击图上的值时会调用。this为series 
				    	showDetailList(deptName,e.point.name);
					    //alert(e.point.name);
						  } } }, pie: { size:'75%', allowPointSelect: true, cursor: 'pointer', 
					    dataLabels: { enabled: false, color: '#000000',
					     connectorColor: '#000000',
					      format: '<b>{point.name}</b>: {point.percentage:.1f} %' },
					      showInLegend: true //是否显示图例
				    } },
					       series: [{ 
						       type: 'pie', name: '失信等级占比 ', 
						       data: pieData }]  });	

			 ajaxLoadEnd();//任务执行成功，关闭进度条  
		}
		});
	}

	function showDetailList(dept,sxdj){
		  $.ajax({
	             type: "GET",
	             url: "<%=basePath%>enterpriseanalysis/getSxqyListBydept.action",
	             data: {deptName:dept,sxdj:sxdj.substring(0,2),timeBegin:$("#timeBegin").val(),timeEnd:$("#timeEnd").val() },
	             dataType: "json",
	             beforeSend:ajaxLoading,//发送请求前打开进度条
	             success: function(data){
	                         $('#detailList').empty();   //清空detailList里面的所有内容
	                         var html = "<tr style='background-color:#81AACF'><td height='40px'>序号</td><td>失信等级</td>"+
	                         "<td>企业名称</td><td>组织机构代码</td><td>工商注册号</td><td>失信时间</td></tr>";
	                         $.each(data, function(i, d){
	                        	 	var sjfsrq=d.time;
	                        	 	var qymc=d.QYMC;
									var zzjgdm=d.ZZJGDM;
									var gszch=d.GSZCH;
									var sxdj=d.SXDJ;
									 if (!d.SXDJ) { sxdj=""}
									 if (!d.QYMC) { qymc=""} 
		                        	 if(!d.ZZJGDM){zzjgdm=""}
		                        	 if(!d.GSZCH){gszch=""}
		                        	 if(!d.time){ sjfsrq=""}
	                         
	                        	 html=html+"<tr><td height='30px'>"+(i+1)+"</td><td>"+sxdj+"</td><td>"+qymc+"</td><td>"+
	                             zzjgdm+"</td><td>"+gszch+"</td><td width='15%'>"+sjfsrq+"</td></tr>";
	                         });
	                         var html2 = " <table border='1' style='width:900px;text-align:center;' align='center'>"+html+"</table>";
	                         $('#detailList').html(html2);
	                         ajaxLoadEnd();//任务执行成功，关闭进度条 
	                         $('#detailListWin').window({
	                        	 title:'失信企业列表',
	                        	 top:'80px',
	                             modal:true
	                          });
	                         
	                         $('#detailListWin').window('open');
	                         $('#sxdjForExport').val(sxdj.substring(0,2));
	                         $('#deptForExport').val(dept);
	                         
	                      }
	         });
		 

		}
	
	function enterpriseSearch(){
		getEnterpriseChat();
	
	}
	
	function clearEnterpriseSearch(){
		$("#dept").combobox('setValues',[]);
		 $("#timeBegin").val('');
	  $("#timeEnd").val('');	
	}

	function exportExcel(){
		var sxdj=  $('#sxdjForExport').val();
        var dept=  $('#deptForExport').val();
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		window.location.href="<%=basePath%>enterpriseanalysis/sxdjExport.action?sxdj="+sxdj+"&dept="+dept+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
	}

	 
  </script>
  <style type="text/css">
  #detailList{
	margin-left:auto; margin-right:auto;
}
</style>
</head>
<body>
<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
	<div id="tb" style="padding:5px;height:auto">
				<label for="depts">&nbsp;&nbsp;部&nbsp;&nbsp;门:</label>
				 <input 
					class="easyui-combobox" id="dept" editable="false"
					url='<%=basePath%>enterpriseanalysis/getDetpList.action' 
					data-options="valueField:'name', textField:'name',multiple:true">
				
				</input>
				上报起始时间:&nbsp;<input  class="Wdate" type="text"  id="timeBegin"
	   		onfocus="WdatePicker({skin:'whyGreen',maxDate:'#F{$dp.$D(\'timeEnd\')}'})"/>&nbsp; 
				上报截止时间:&nbsp;<input  class="Wdate" type="text"  id="timeEnd"
	   		onfocus="WdatePicker({skin:'whyGreen',minDate:'#F{$dp.$D(\'timeBegin\')}'})"/>&nbsp; 
				<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="enterpriseSearch();">查询</a>
					 <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearEnterpriseSearch();">重置</a>
					
					
					
		</div>
	<div style="min-height:600px;width: 100%">
	<div id='hint' style="display:none;"><br>
	<font color="red" size="5">&nbsp;&nbsp;&nbsp;此查询条件无统计结果，请重新选择条件后查询，谢谢！</font>
	</div>
  <div id="container" style="width:55%;height:800px;float:left;padding-right:40px;"></div>
  <div id="container2" style="width:35%;height:600px;float:left;"></div>
  
     </div>
     
      <div class="easyui-window" id="detailListWin"  style="width:960px; height:500px;padding:10px 20px;" 
  		 data-options="iconCls:'icon-add',tools:'#tool',closed:true, border:false" >
  		 <input type="hidden" id="sxdjForExport"/>
  		 <input type="hidden" id="deptForExport"/> 
  		 <div id="detailList" style="width:900px;" ></div>
 	 	<div id="tool">
			<a href="javascript:void(0)" class="icon-export" onclick="exportExcel()"
				title="导出"></a>
		</div>
     </div>
</body>
</html>




