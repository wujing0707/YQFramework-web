<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>日志报表试图展示</title>
</head>
<body>
<div style="margin:10px 10px;">日志统计报表</div>
	<table>
		<tr>
			<td><a href="ip.action" target="mainFrame">IP地址统计</a>&nbsp;&nbsp;</td>
			<td><a href="url.action" target="mainFrame">访问URL地址统计</a>&nbsp;&nbsp;</td>
			<td><a href="hour.action" target="mainFrame">24小时时间段统计</a>&nbsp;&nbsp;</td>
			<td><a href="week.action" target="mainFrame">周时间段统计</a>&nbsp;&nbsp;</td>
			<td><a href="day.action" target="mainFrame">最近10天趋势</a>&nbsp;&nbsp;</td>
			<td><a href="month.action" target="mainFrame">最近12个月趋势</a>&nbsp;&nbsp;</td>
		</tr>
	</table>
	<iframe name="mainFrame" frameborder="0" marginheight="0" marginwidth="0" height="700" width="100%"></iframe>
    
</body>
</html>