<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表-最近12个月访问量趋势</title>
    <script type="text/javascript" src="../../../js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../../../js/jquery-highcharts-3.0.6/highcharts.js"></script>
	<script type="text/javascript">
	$(function () {
	    $(document).ready(function() {
	        var colors = Highcharts.getOptions().colors;
	    
	        $.post('monthData.action',function(result){
	        	if(!result){
	        		alert('系统异常');
	        		return;
	        	}
	        	var dataAry = [];
	        	$.each(result.data,function(i,val){
	        		dataAry.push(val);
	        	});
	        	
		        var chart = new Highcharts.Chart({
		            chart: {
		                renderTo: 'container',
		                type: 'line'
		            },
		            title: {
		                text: result.title
		            },
		            xAxis: {
		                categories: result.categories
		            },
		            yAxis: {
		                title: {
		                    text: '访问量'
		                }
		            },
		            tooltip: {
		                formatter: function() {
		                	return this.x +' 的访问量:<b>'+ this.y +'</b>' ;
		                }
		            },
		            plotOptions: {
		                line: {
		                	color:colors[0],
		                    dataLabels: {
		                        enabled: true
		                    },
		                    enableMouseTracking: true
		                }
		            },
		            series: [{
		                name: '最近12个月趋势',
		                data: dataAry
		            }],
		            exporting: {
		                enabled: false,
		                url:'',
		                filename:'chart'
		            },
		            credits: {
		                enabled: false
		            }
		        });
	        },'json');
	    });
	    
	});
	</script>
</head>
<body>
    <div id="container" style="min-width: 100px; height: 600px; margin: 0 auto"></div>


</body>
</html>