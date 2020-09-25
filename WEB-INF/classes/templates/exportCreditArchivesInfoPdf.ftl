<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style type="text/css">
			body {font-family: SimSun;}
			.clear{height:8px}
			
			table {table-layout:fixed;width:100%; color:black; text-align:center; border-collapse:collapse;font-size:15px;}
			td {border:1px solid black; height:25px;font-size:10px;}
		</style>
	</head>
	
	<body>
		<div>
			<div style="font-size:32px;padding:150px 0 500px 0;text-align:center;font-weight:700">
				企业信用查询报告
			</div>
			<div style="font-size:22px; padding:0 0 250px 0; text-align:center">
				苏州市工业园区信用办<br/><br/>
				查询日期:${archivesinfo.downtime}
			</div>
		</div>
		
		<div>
			<font style="font-size:18px;"><center>${archivesinfo.qymc}</center></font><br/><br/>
			<font style="font-size:15px;">一、企业标识信息</font>
			<div class="clear"></div>
			<table style="table-layout:fixed;">
				<tr>
					<td>企业名称</td>
			    	<td>组织机构代码</td>
			    	<td>工商注册号</td>
			    	<td>纳税人识别号</td>
				</tr>
				<tr>
					<td>${archivesinfo.qymc}</td>
					<td>${archivesinfo.zzjgdm}</td>
					<td>${archivesinfo.gszch}</td>
					<td>${archivesinfo.nsrbsh}</td>
				</tr>
			</table>
		</div>
		<div class="clear"></div>
		<div>
			<#list archivesinfo.tablelist as info>
				<font style="font-size:15px;">
					<#if (info_index + 2) == 2>二、</#if>
					<#if (info_index + 2) == 3>三、</#if>
					<#if (info_index + 2) == 4>四、</#if>
					<#if (info_index + 2) == 5>五、</#if>
					<#if (info_index + 2) == 6>六、</#if>
					<#if (info_index + 2) == 7>七、</#if>
					<#if (info_index + 2) == 8>八、</#if>
					<#if (info_index + 2) == 9>九、</#if>
					${info.name}
				</font>
				<div class="clear"></div>
				<#if (info.list?size > 0)>
					<#list info.list as deptInfo>
						<font>${deptInfo.deptName}-${deptInfo.tableName}</font>
						<div class="clear"></div>
						<table>
							<tr>
								<#list deptInfo.columnName as titleInfo>
					    			<td style="margin-bottom:10px;">${titleInfo}</td>
								</#list>
							</tr>
							<#if (deptInfo.columnVal?size > 0)>
								<#list deptInfo.columnVal as vals>
				      				<tr>
					      				<#list vals as val>
						    				<td>${val}</td>
					      				</#list>
				    				</tr>
								</#list>
							<#else>
								<tr>
									<td colspan="${deptInfo.columnName?size}">暂无信息</td>
								</tr>
							</#if>
						</table>
						<div class="clear"></div>
					</#list>
				</#if>
			</#list>
		</div>
	</body>
</html>