<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>报表-24小时访问量</title>
    <script type="text/javascript" src="../../../js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../../../js/jquery-highcharts-3.0.6/highcharts.js"></script>
	<script type="text/javascript">
  	var colors = Highcharts.getOptions().colors;
	$(function () {
	    $(document).ready(function() {
	        $.post('hourData.action',function(result){
	        	if(!result){
	        		alert('系统异常');
	        		return;
	        	}
	        	$.each(result,function(i,val){
	        		if(!val.categories){//饼状图
	        			createPieChart(val);
	        		}else{//柱状图
	        			createBarChart(val);
	        		}
	        	});
	        	
	        },'json');
	    });
	});
	//创建饼状图
	function createPieChart(val){
		var data = val.data;	
		var title = val.title;
		var dataAry = [];
		var i=0;
		$.each(data,function(key,value){
    		var obj = {name:key,y:value,color:colors[i]};
    		dataAry.push(obj);
    		i = i++ == 9 ?0:i++;
    	});
		 new Highcharts.Chart({
	            chart: {
	                renderTo: 'pieContainer',
	                plotBackgroundColor: null,
	                plotBorderWidth: null,
	                plotShadow: false
	            },
	            title: {
	                text: title
	            },
	            tooltip: {
	            	formatter:function(){
	            		 return this.point.name+' <b>: '+Highcharts.numberFormat(this.percentage,2)+'%</b>';  
	            	}
	            },
	            plotOptions: {
	                pie: {
	                    allowPointSelect: true,
	                    cursor: 'pointer',
	                    dataLabels: {
	                        enabled: false
	                    },
	                    showInLegend: false
	                }
	            },
	            series: [{
	            	name:'访问量',
					type: 'pie',
	                data: dataAry
	            }],
	            exporting: {
	            	enabled:false,
	            	url:'',
	                filename:'chart'
	            },
	            credits: {
	                enabled: false
	            }
	        });
	}
	//创建柱状图
	function createBarChart(val){
		var categories = val.categories;
		var data = val.data;
		var title = val.title;
		var dataAry = [];
		$.each(data,function(i,v){
    		var obj = {y:v,color:colors[i%10]};//颜色一共10种，循环使用
    		dataAry.push(obj);
    	});
    	//柱状图
        var barchart = new Highcharts.Chart({
            chart: {
                renderTo: barContainer,
                type: 'column'
            },
            title: {
                text: title
            },
            xAxis: {
                categories: categories,
                labels:{
                	rotation:-30
                }
            },
            yAxis: {
                title: {
                    text: '访问量'
                }
            },
            plotOptions: {
                column: {
                    dataLabels: {
                        enabled: true,
                        formatter: function() {
                            return this.y;
                        }
                    }
                }
            },
            tooltip: {
                formatter: function() {
                 	return this.x +' 的访问量:<b>'+ this.y ;
                 }
            },
            legend: {
                enabled: false
            },
            series: [{
                data: dataAry,
                color: 'white'
            }],
            exporting: {
            	enabled:false,
            	url:'',
                filename:'chart'
            },
            credits: {
                enabled: false
            }
        });
	}
	</script>
</head>
<body>
    <div id="pieContainer" style="min-width: 100px; height: 400px;  width: 50%"></div>
    <div id="barContainer" style="min-width: 100px; height: 400px; margin-left: auto;margin-right: auto;"></div>
</body>
</html>