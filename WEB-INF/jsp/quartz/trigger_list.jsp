<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务管理</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/color.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/base.js"></script>
</head>
<script type="text/javascript">
    function deleteConfirm() {
        var node = $('#triggersGrid').datagrid('getSelected');
        if (node == null) {
            $.messager.alert('选择', '请先选择要删除的任务', 'info');
            return;
        }
        $.messager.confirm('确定删除', '确认要删除的任务?', function(r) {
            if (r) {
                $.post("delete.action", {
                    triggerName : node.id.triggerName,
                    group : node.id.triggerGroup
                }, function(data) {
                    var data = eval('(' + data + ')'); // change the JSON string to javascript object
                    if (!data.result) {
                        $.messager.alert('失败', data.message, 'error');
                        return;
                    } else {
                        $.messager.alert('成功', data.message, 'success');
                    }
                    $('#triggersGrid').datagrid('reload');
                });
            }
        });
    }
    function pause() {
        var node = $('#triggersGrid').datagrid('getSelected');
        if (node == null) {
            $.messager.alert('选择', '请先选择要暂停的任务', 'info');
            return;
        }
        $.messager.confirm('确定暂停', '确认要暂停的任务?', function(r) {
            if (r) {
                $.post("pause.action", {
                    triggerName : node.id.triggerName,
                    group : node.id.triggerGroup
                }, function(data) {
                    var data = eval('(' + data + ')'); // change the JSON string to javascript object
                    if (!data.result) {
                        $.messager.alert('失败', data.message, 'error');
                        return;
                    } else {
                        $.messager.alert('成功', data.message, 'success');
                    }
                    $('#triggersGrid').datagrid('reload');
                });
            }
        });
    }
    function resume() {
        var node = $('#triggersGrid').datagrid('getSelected');
        if (node == null) {
            $.messager.alert('选择', '请先选择要恢复的任务', 'info');
            return;
        }
        $.messager.confirm('确定恢复', '确认要恢复的任务?', function(r) {
            if (r) {
                $.post("resume.action", {
                    triggerName : node.id.triggerName,
                    group : node.id.triggerGroup
                }, function(data) {
                    var data = eval('(' + data + ')'); // change the JSON string to javascript object
                    if (!data.result) {
                        $.messager.alert('失败', data.message, 'error');
                        return;
                    } else {
                        $.messager.alert('成功', data.message, 'success');
                    }
                    $('#triggersGrid').datagrid('reload');
                });
            }
        });
    }

    function schedNameFormat(value, row, index) {
        return row['id']['schedName'];
    }
    function triggerNameFormat(value, row, index) {
        return row['id']['triggerName'];
    }
    function triggerGroupFormat(value, row, index) {
        return row['id']['triggerGroup'];
    }
    function jobNameFormat(value, row, index) {
        return row['qrtzJobDetails']['id']['jobName'];
    }
    function jobGroupFormat(value, row, index) {
        return row['qrtzJobDetails']['id']['jobGroup'];
    }
    function descriptionFormat(value, row, index) {
        return row['qrtzJobDetails']['description'];
    }
    function jobClassNameFormat(value, row, index) {
        return row['qrtzJobDetails']['jobClassName'];
    }
    function dateFormat(value, row) {
        if (value > 1) {
            return new Date(value).toLocaleString();
        } else {
            return "-";
        }
    }

    $(window).resize(function() {
        $('#triggersGrid').datagrid('resize', {
            width : function() {
                return document.body.clientWidth;
            },
            height : function() {
                return document.body.clientHeight;
            }
        });
    });

    function conditionSearch() {
        var schedName = $.trim($('#conditionSchedName').val());
        var jobName = $.trim(jQuery("#conditionJobName").val());
        var triggerName = $.trim(jQuery("#conditionTriggerName").val());
        var queryParams = $('#triggersGrid').datagrid('options').queryParams;
        queryParams["schedName"] = schedName;
        queryParams["jobName"] = jobName;
        queryParams["triggerName"] = triggerName;
        $('#triggersGrid').datagrid('options').queryParams = queryParams;
        $('#triggersGrid').datagrid('options').pageNumber = 1;
        $('#triggersGrid').datagrid('getPager').pagination({pageNumber: 1});
        $("#triggersGrid").datagrid('reload');
    }

    function onAddTrigger() {
        $('#addTriggerForm').form('clear');
        $('#winAdd').window('open');
    }

    function addTrigger() {
        $('#addTriggerForm').form('submit', {
            success : function(data) {
                var data = eval('(' + data + ')'); // change the JSON string to javascript object
                if (!data.result) {
                    $.messager.alert('失败', data.message, 'error');
                } else {
                    $.messager.alert('成功', data.message, 'success');
                    $('#triggersGrid').datagrid('reload');
                    $('#winAdd').dialog('close');
                }
            }
        });
    }

    function conditionReset() {
        $('#conditionJobName').textbox('setValue', "");
        $('#conditionTriggerName').textbox('setValue', "");
    }
    
    
	   function conditionStart(){

			$.post("${pageContext.request.contextPath}/system/trigger/lvru.action",
					function(data){
				 	
				 
			      
			       
			    }
						
			);
			
		}
</script>
</head>
<body>
   <div>
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
						<li><%=request.getAttribute("path") %></li>
				</ul>
			</div>
    <table id="triggersGrid" class="easyui-datagrid" style="height: 360px" width="100%"
        data-options="rownumbers:true, pagination:true, 
            singleSelect:true, collapsible:true,  
            pageSize:10, url:'list.action', method:'post', 
            iconCls:'icon-user', toolbar:'#tb'">
        <thead>
            <tr>
                <th field="triggerName" formatter="triggerNameFormat" width="120">触发器名称</th>
                <th field="triggerGroup" formatter="triggerGroupFormat" width="120">触发器分组</th>
                <th field="triggerState" width="120">触发器状态</th>
                <th field="jobName" formatter="jobNameFormat" width="120">任务名称</th>
                <th field="jobGroup" formatter="jobGroupFormat" width="120">任务分组</th>
                <th field="description" formatter="descriptionFormat" width="120">任务描述</th>
                <th field="nextFireTime" formatter="dateFormat" width="120">下次执行时间</th>
                <th field="prevFireTime" formatter="dateFormat" width="120">上次执行时间</th>
                <th field="startTime" formatter="dateFormat" width="120">开始时间</th>
                <th field="endTime" formatter="dateFormat" width="120">结束时间</th>
            </tr>
        </thead>
    </table>
    </div>
    <div id="tb" style="padding: 5px; height: auto">
        <div style="margin-bottom: 5px">
            <a class="easyui-linkbutton" data-options="iconCls:'icon-add', plain:true" onclick="onAddTrigger();">新增</a> <a class="easyui-linkbutton"
                data-options="iconCls:'icon-remove', plain:true" onclick="deleteConfirm();">删除</a> <a class="easyui-linkbutton"
                data-options="iconCls:'icon-disable', plain:true" onclick="pause();">暂停</a> <a class="easyui-linkbutton"
                data-options="iconCls:'icon-redo', plain:true" onclick="resume();">恢复</a> 任务名称：<input id="conditionJobName" class="easyui-textbox" style="width: 80px"> 触发器名称：<input
                id="conditionTriggerName" class="easyui-textbox" style="width: 80px"> <a href="#" class="easyui-linkbutton"
                iconCls="icon-search" onclick="conditionSearch();">查询</a> <a href="#" class="easyui-linkbutton" iconCls="icon-refresh"
                onclick="conditionReset();">重置</a>  <a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="conditionStart();">开始</a>
        </div>
    </div>

    <div id="winAdd" class="easyui-window" title="新增触发器" data-options="iconCls:'icon-add', closed:true, border:false"
        style="width: 350px; height: 220px; padding: 0px;">
        <form id="addTriggerForm" method="post" action="create.action">
            <table style="padding: 10px;">
                <tr>
                    <td align="right">触发器名称:</td>
                    <td><input class="easyui-textbox" type="text" name="triggerName" data-options="required:true,validType:'length[0,50]'"></input></td>
                </tr>
                <tr>
                    <td align="right">作业:</td>
                    <td><input id="jobNamecom" class="easyui-combobox" name="jobId"
                        data-options="required:true,editable:false,url:'jobNames.action',method:'post',valueField:'id',textField:'text', panelHeight:'auto'">
                    </td>
                </tr>
                <tr>
                    <td align="right">cron表达式:</td>
                    <td><input class="easyui-textbox" name="cronExpression" data-options="required:true"></input></td>
                </tr>
            </table>
        </form>
        <div style="text-align: center; padding: 5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="addTrigger()">确定</a> <a href="javascript:void(0)"
                class="easyui-linkbutton" onclick="$('#winAdd').dialog('close');">取消</a>
        </div>
    </div>
</body>
</html>