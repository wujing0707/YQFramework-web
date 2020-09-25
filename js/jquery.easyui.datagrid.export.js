function exportData(gridId) {
    var rows = $('#' + gridId).datagrid('getRows');
    var columns = $('#' + gridId).datagrid('options').columns[0];
    var titleObj = {};
    var fields = {};
    var valueTotalArr = [];
    
    var titleArr = [];
    var fieldArr = [];
    
    for (var index in columns) {
        if (columns[index].hidden == "undefined" 
            || columns[index].hidden != true) {
            titleObj[columns[index].field] = columns[index].title;
            fields[columns[index].field] = columns[index];
            
            titleArr.push(columns[index].title);
            fieldArr.push(columns[index].field);
            
        }
    }

    for (var i in rows) {
        var obj = {};
        for (var j in fields) {
            var feildVal = rows[i][fields[j].field];
            if (fields[j].formatter) {
                feildVal = fields[j].formatter(feildVal, rows[i], i)
            }
            obj[fields[j].field] = feildVal;
        }
        valueTotalArr.push(obj);
    }
    var jsonField = JSON.stringify(titleObj);
    var jsonValue = JSON.stringify(valueTotalArr);
    
    
    var jsonTitle = JSON.stringify(titleArr);
    var jsonFieldArr = JSON.stringify(fieldArr);
    
    
    document.getElementById("excelField").value = jsonField;
    document.getElementById("excelValues").value = jsonValue;
    
    document.getElementById("titleArr").value = jsonTitle;
    document.getElementById("fieldArr").value = jsonFieldArr;
    
    document.getElementById("ablg").submit();
}