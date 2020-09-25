$.extend($.fn.validatebox.defaults.rules, {
    minLength : { // 判断最小长度
        validator : function(value, param) {
            return value.length >= param[0];
        },
        message : "最少输入 {0} 个字符"
    },
    
    
     maxLength : { // 判断最小长度
        validator : function(value, param) {
            return value.length <= param[0];
        },
        message : "最多输入 {0} 个字符"
    },
  //邮政编码验证
    postCodecheck:{
   validator:function(value) {
	   return /^[1-9]\d{5}$/.test(value);

   },message:"邮编应为6位邮政编码"
   },

   
   //特殊字符过滤验证允许/.
   notillegalChar:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^&*()=|{}':;',.////\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符"
   },
   
   
   //特殊字符过滤验证允许/.
   illegalChar:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^&*()=|{}':;',\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符,只允许/."
   },
   
   
   //特殊字符过滤验证允许/.,
   illegalCharTwo:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^&*()=|{}':;'\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符,只允许/.,"
   },
    
   
   
   //特殊字符过滤验证允许.
   illegalCharThree:{
	   validator:function(value) {
		   var pattern = new RegExp("[`~!@@#$^&*()=|{}':;',////\[\\]<>?~！@#￥……&*（）——|{}【】‘；：”“'．，、？\\\\＼＼。。%％％%]");
		   return !pattern.test(value);
		   
	   },message:"含有非法特殊字符,只允许."
   },
    
   //验证数字且去空格
   num:{
	   validator:function(value) {
		    return /^[1-9]\d*$/.test($.trim(value));
	   },message:"必须为非0开始的数字整数"
   },
   
    
    length:{validator:function(value,param){
        var len=$.trim(value).length;
            return len>=param[0]&&len<=param[1];
        },
            message:"输入内容长度必须介于{0}和{1}之间."
        },
        
      //电话号码验证//        
        phone : {// 验证电话号码  
            validator : function(value) {  
//                return /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i.test(value);  
                return /^(^0\d{2}-?\d{8}$)|(^0\d{2}-?\d{7}$)|(^0\d{3}-?\d{7}$)|(^0\d{3}-?\d{8}$)|(^1[3,5,8]\d{9}$)$/i.test(value);
            },  
            message : '格式须为固定电话或手机号码如0512-12345678或13012345678'  
        }, 
        
    mobile : {// 验证手机号码
        validator : function(value) {
            return /^(13|15|18)d{9}$/i.test(value);
        },
        message : "手机号码格式不正确"
    },
    
    idcard : {// 验证身份证
        validator : function(value) {
            return /^\d{17}([0-9]|X$)/i.test(value);
//            return /(^\d{15}$)|(^\d{17}([0-9]|X)$)/i.test(value);
        },
        message : "身份证号码格式应为18位数字或最后位可为X"
    },
    
    intOrFloat : {// 验证整数或小数
        validator : function(value) {
            return /^d+(.d+)?$/i.test(value);
        },
        message : "请输入数字，并确保格式正确"
    },
    
    currency : {// 验证货币
        validator : function(value) {
            return /^d+(.d+)?$/i.test(value);
        },
        message : "货币格式不正确"
    },
    
    qq : {// 验证QQ,从10000开始
        validator : function(value) {
            return /^[1-9]d{4,9}$/i.test(value);
        },
        message : "QQ号码格式不正确"
    },
    
    integer : {// 验证整数
        validator : function(value) {
            return /^[+]?[1-9]+d*$/i.test(value);
        },
        message : "请输入整数"
    },
    
    chinese : {// 验证中文
        validator : function(value) {
            return /^[u0391-uFFE5]+$/i.test(value);
        },
        message : "请输入中文"
    },
    
    notchinese : {// 验证含中文
    	validator : function(value) {
    		
    		return !/^[\Α-\￥]+$/igm.test(value); 
    	},
    	message : "不能含有中文"   
    },
    notchineseG : {// 验证含中文
    	validator : function(value) {
    		var reg = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
    		/*return !/^[\u0391-\uFFE5]?$/i.test(value);*/
    		   return !reg.test(value);
    		/*return !/^[\u4e00-\u9fa5]+$/i.test(value); */
    	},
    	message : "禁止含有中文"   
    },
    
    english : {// 验证英语
        validator : function(value) {
            return /^[A-Za-z]+$/i.test(value);
        },
        message : "请输入英文"
    },
    
    unnormal : {// 验证是否包含空格和非法字符
        validator : function(value) {
            return /.+/i.test(value);
        },
        message : "输入值不能为空和包含其他非法字符"
    },
    
    username : {// 验证用户名
        validator : function(value) {
            return /^[a-zA-Z][a-zA-Z0-9_]{5,15}$/i.test(value);
        },
        message : "用户名不合法（字母开头，允许6-16字节，允许字母数字下划线）"
    },
    
    faxno : {// 验证传真
        validator : function(value) {
//            return /^[+]{0,1}(d){1,3}[ ]?([-]?((d)|[ ]){1,12})+$/i.test(value);
            return /^(((d{2,3}))|(d{3}-))?((0d{2,3})|0d{2,3}-)?[1-9]d{6,7}(-d{1,4})?$/i.test(value);
        },
        message : "传真号码不正确"
    },
    
    zip : {// 验证邮政编码
        validator : function(value) {
            return /^[1-9]d{5}$/i.test(value);
        },
        message : "邮政编码格式不正确"
    },
    
    ip : {// 验证IP地址
        validator : function(value) {
            return /d+.d+.d+.d+/i.test(value);
        },
        message : "IP地址格式不正确"
    },
    
    name : {// 验证姓名，可以是中文或英文
            validator : function(value) {
                return /^[u0391-uFFE5]+$/i.test(value)|/^w+[ws]+w+$/i.test(value);
            },
            message : "请输入姓名"
    },
    
    carNo:{
        validator : function(value){
            return /^[u4E00-u9FA5][da-zA-Z]{6}$/.test(value);
        },
        message : "车牌号码无效（例：粤J12350）"
    },
    
    carenergin:{
        validator : function(value){
            return /^[a-zA-Z0-9]{16}$/.test(value);
        },
        message : "发动机型号无效(例：FG6H012345654584)"
    },
    
    email:{//验证邮箱
        validator : function(value){
        return /^[a-z]([a-z0-9]*[-_]?[a-z0-9]+)*@([a-z0-9]*[-_]?[a-z0-9]+)+[\.][a-z]{2,3}([\.][a-z]{2})?$/.test(value);
//        return /^w+([-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*$/.test(value);
    },
    message : "请输入有效的电子邮件账号(例：abc@126.com)"   
    },
    
    msn:{
        validator : function(value){
        return /^w+([-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*$/.test(value);
    },
    message : "请输入有效的msn账号(例：abc@hotnail(msn/live).com)"
    },
    
    same:{
        validator : function(value, param){
            if($("#"+param[0]).val() != "" && value != ""){
                return $("#"+param[0]).val() == value;
            }else{
                return true;
            }
        },
        message : "两次输入的密码不一致！"   
    }
});
