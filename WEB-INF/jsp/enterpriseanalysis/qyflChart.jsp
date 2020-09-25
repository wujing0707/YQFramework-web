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
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
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

  
$(function(){
	getEnterpriseChat();
});
  
	function getEnterpriseChat(){
		$('#toList').show();
		$("#detailList").hide();
		$("#searchForList").hide();
		var qylxCode=$("#qylx").combobox('getValues');
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		qylxCode=encodeURI(encodeURI(qylxCode, "UTF-8"), "UTF-8");
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/qyfl.action?qylxCode="+qylxCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
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
            	$('#toList').hide();
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
				 title: { text: '各企业类型失信企业统计' },
				  xAxis: {
					   categories: ret.bar.qylx 
					}, 
				  yAxis: { allowDecimals:false, //是否允许刻度有小数 
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
				    plotOptions: { pie: { allowPointSelect: true, cursor: 'pointer', 
					    dataLabels: { enabled: false, color: '#000000',
					     connectorColor: '#000000',
					      format: '<b>{point.name}</b>: {point.percentage:.1f} %' },
					      showInLegend: true //是否显示图例
					      } },
					       series: [{ 
						       type: 'pie', name: '失信等级占比 ', 
						       data: pieData }]  });
						       

   			//列表
			  var htmlStr = "<tr style='background-color:#81AACF'><td height='40px'>序号</td><td>企业类型</td>"+
              "<td>严重</td><td>较重</td><td>一般</td><td>合计</td></tr>";
          $.each(ret.list,function(i,d){
              htmlStr=htmlStr+"<tr><td height='30px'>"+(i+1)+"</td><td>"+d.企业类型+"</td><td><a href='#' onclick=\"showDetailList('"+d.企业类型+"','严重')\" style=\"text-decoration:underline;color:blue\">"+d.严重+"</a></td>"+
              "<td><a href='#' onclick=\"showDetailList('"+d.企业类型+"','较重')\" style=\"text-decoration:underline;color:blue\">"+d.较重+"</td><td><a href='#' onclick=\"showDetailList('"+d.企业类型+"','一般')\" style=\"text-decoration:underline;color:blue\">"+d.一般+"</a></td><td>"+
              "<a href='#' onclick=\"showDetailList('"+d.企业类型+"','合计')\" style=\"text-decoration:underline;color:blue\">"+d.总计+"</a></td></tr>"
          });
          var enterTable = "<span><h1>企业失信等级统计表</h1></span><br/><table border='1' style='width:900px;text-align:center;' align='center'>"+htmlStr+"</table>";
            $("#enterTable").html(enterTable);
            ajaxLoadEnd();//任务执行成功，关闭进度条   
				}
	            });

        
	           
	}

	function showPieChart(qylxCode){
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		qylxCode=encodeURI(encodeURI(qylxCode, "UTF-8"), "UTF-8");
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/qyfl.action?qylxCode="+qylxCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
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
				    plotOptions: { pie: { allowPointSelect: true, cursor: 'pointer', 
					    dataLabels: { enabled: false, color: '#000000',
					     connectorColor: '#000000',
					      format: '<b>{point.name}</b>: {point.percentage:.1f} %' },  showInLegend: true //是否显示图例
					      } },
					       series: [{ 
						       type: 'pie', name: '失信等级占比 ', 
						       data: pieData }]  });	

			 ajaxLoadEnd();//任务执行成功，关闭进度条   
		}
		});
	}

	function showDetailList(qylx,sxdj){
		  $.ajax({
	             type: "GET",
	             url: "<%=basePath%>enterpriseanalysis/getSxqyListByQylxAndSxdj.action",
	             data: {qylx:qylx,sxdj:sxdj,timeBegin:$("#timeBegin").val(),timeEnd:$("#timeEnd").val() },
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
	                        	 
	                        	 html=html+"<tr><td height='30px'>"+(i+1)+"</td><td>"+sxdj+"</td><td><a href='#' onclick=\"toDeail('"+qymc+"')\" style=\"text-decoration:underline;color:blue\"> "+qymc+"</a></td><td>"+
	                             zzjgdm+"</td><td>"+gszch+"</td><td>"+sjfsrq+"</td></tr>";
	                         });
	                         var html2 = " <table border='1' style='width:900px;text-align:center;' align='center'>"+html+"</table>";
	                         $('#detailList').html(html2);
	                         $("#detailList").show();
	                         ajaxLoadEnd();//任务执行成功，关闭进度条  
	                        // window.location.hash = "#detailList"; 
	                        
	                         $('#detailListWin').window({
	                        	 title:'失信企业列表',
	                        	 top:'80px',
	                             modal:true
	                          });
	                         
	                         $('#detailListWin').window('open');
	                         
	                         $('#sxdjForExport').val(sxdj.substring(0,2));
	                         $('#qylxForExport').val(qylx);
	                      }
	         });
		  

		}
	
	function enterpriseSearch(){
		getEnterpriseChat();
	
	}
	
	
	function enterpriseSearch2(){
		var qylxCode=$("#qylx").combobox('getValues');
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		qylxCode=encodeURI(encodeURI(qylxCode, "UTF-8"), "UTF-8");
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/qyfl.action?qylxCode="+qylxCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
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
            
			 $('#container').highcharts({ 
				 chart: { type: 'bar' }, 
				
				 credits: {
		                enabled:false
		            },
				 title: { text: '各企业类型失信企业统计' },
				  xAxis: {
					   categories: ret.bar.qylx 
					}, 
				  yAxis: { allowDecimals:false, //是否允许刻度有小数 
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
				    plotOptions: { pie: { allowPointSelect: true, cursor: 'pointer', 
					    dataLabels: { enabled: false, color: '#000000',
					     connectorColor: '#000000',
					      format: '<b>{point.name}</b>: {point.percentage:.1f} %' },
					      showInLegend: true //是否显示图例
					      } },
					       series: [{ 
						       type: 'pie', name: '失信等级占比 ', 
						       data: pieData }]  });
						       

   			//列表
			  var htmlStr = "<tr style='background-color:#81AACF'><td height='40px'>序号</td><td>企业类型</td>"+
              "<td>严重</td><td>较重</td><td>一般</td><td>合计</td></tr>";
          $.each(ret.list,function(i,d){
              htmlStr=htmlStr+"<tr><td height='30px'>"+(i+1)+"</td><td>"+d.企业类型+"</td><td><a href='#' onclick=\"showDetailList('"+d.企业类型+"','严重')\" style=\"text-decoration:underline;color:blue\">"+d.严重+"</a></td>"+
              "<td><a href='#' onclick=\"showDetailList('"+d.企业类型+"','较重')\" style=\"text-decoration:underline;color:blue\">"+d.较重+"</td><td><a href='#' onclick=\"showDetailList('"+d.企业类型+"','一般')\" style=\"text-decoration:underline;color:blue\">"+d.一般+"</a></td><td>"+
              "<a href='#' onclick=\"showDetailList('"+d.企业类型+"','合计')\" style=\"text-decoration:underline;color:blue\">"+d.总计+"</a></td></tr>"
          });
          var enterTable = "<span><h1>企业失信等级统计表</h1></span><br/><table border='1' style='width:900px;text-align:center;' align='center'>"+htmlStr+"</table>";
            $("#enterTable").html(enterTable);
            ajaxLoadEnd();//任务执行成功，关闭进度条   
				}
	            });

	
	}
	
	function toDeail(qymc){
		window.open("<%=basePath%>/creditInfo/getDetailInfo.action?qymc="+qymc+"&zzjgdm=''&gszch=''");
		
	}
	
	function clearEnterpriseSearch(){
		$("#qylx").combobox('setValues',[]);
		 $("#timeBegin").val('');
	  $("#timeEnd").val('');	
	}

	function exportExcel(){
		var sxdj=  $('#sxdjForExport').val();
        var qylx=  $('#qylxForExport').val();
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		//qylxCode=encodeURI(encodeURI(qylxCode, "UTF-8"), "UTF-8");
		window.location.href="<%=basePath%>enterpriseanalysis/qyflExport.action?qylx="+qylx+"&sxdj="+sxdj+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
	}

	function exchange(type){
if(type=='1'){//切换到列表
	$("#toList").hide();
	$("#toPicture").show();
	
	$("#searchForChart").hide();
	$("#searchForList").show();
	
	$("#container").hide();
	$("#container2").hide();
	$("#enterTable").show();
	$("#detailList").hide();
	
}
if(type=='2'){//切换到图
	$("#toList").show();
	$("#toPicture").hide();
	
	$("#searchForChart").show();
	$("#searchForList").hide();

	$("#container").show();
	$("#container2").show();
	$("#enterTable").hide();
	$("#detailList").hide();
}
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
				<label for="dept">请选择企业类型:</label> <input 
					class="easyui-combobox" id="qylx" editable="false"
					url='<%=basePath%>enterpriseanalysis/getQylxList.action' 
					data-options="valueField:'name', textField:'name',multiple:true">
				</input>
				上报起始时间:&nbsp;<input  class="Wdate" type="text"  id="timeBegin"
	   		onfocus="WdatePicker({skin:'whyGreen',maxDate:'#F{$dp.$D(\'timeEnd\')}'})"/>&nbsp; 
				上报截止时间:&nbsp;<input  class="Wdate" type="text"  id="timeEnd"
	   		onfocus="WdatePicker({skin:'whyGreen',minDate:'#F{$dp.$D(\'timeBegin\')}'})"/>&nbsp; 
				<a href="#" id="searchForChart"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="enterpriseSearch();">查询</a>
				
				<a href="#" id="searchForList"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="enterpriseSearch2();">查询</a>
					
					 <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearEnterpriseSearch();">重置</a>
					
					
					 <a href="#" id="toList"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="exchange(1);">列表</a>
					
					<a href="#" id="toPicture" style="display:none;"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="exchange(2);">图表</a>
		</div>
 <div style="min-height:600px;width: 100%">
	<div id='hint' style="display:none;"><br>
	<font color="red" size="5">&nbsp;&nbsp;&nbsp;此查询条件无统计结果，请重新选择条件后查询，谢谢！</font>
	</div>
	<input type="hidden" id="sxdjForExport"/>
  	<input type="hidden" id="qylxForExport"/> 
	
  <div id="container" style="width:55%;min-height:550px;float:left;padding-right:40px;"></div>
  <div id="container2" style="width:35%;;min-height:550px;float:left;"></div>
   <div width="600px" id="enterTable" align="center" style="margin-top:50px;margin-bottom:20px;display:none;" ></div>
  <div class="easyui-window" id="detailListWin"  style="width:960px; height:500px;padding:10px 20px;" 
  		 data-options="iconCls:'icon-add',tools:'#tool',closed:true, border:false" >
  		 <div id="detailList" style="width:900px;" ></div>
 	 	<div id="tool">
			<a href="javascript:void(0)" class="icon-export" onclick="exportExcel()"
				title="导出"></a>
		</div>
     </div>
   
   </div>
</body>
</html>




