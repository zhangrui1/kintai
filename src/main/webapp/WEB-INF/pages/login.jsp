<%--
  Created by IntelliJ IDEA.
  User:
  Date: 11/14/14
  Time: 2:37 PM
  To change this template use File | Settings | File Templates.
--%>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:import url="htmlframe/headFrame.jsp" />
<link href="/kintai/css/main.css" rel="stylesheet" />
<html class="bg-black">
<meta charset="UTF-8">
<title>kintai</title>
<%--<link rel="shortcut icon" href="/kintai/img/valdac32.ico" type="image/vnd.microsoft.icon">--%>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">


<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->
</head>
<body class="bg-black">

<div class="form-box" id="login-box">
<%--    <div class="row">--%>
<%--        <div id="errorMessage" style="color:#ff0000; text-align: center;font-size: 15pt;">${message}</div><br>--%>
<%--    </div>--%>
    <div class="header bg-black-gradient" style="color:#ffffff;text-align:center;font-size:xx-large">&nbsp;<strong>kintaiシステム</strong></div>
    <form id="userForm" name="userForm"  action="/kintai/login/" onclick="return check()" method="post">
        <div class="body bg-black-gradient">
            <div class="form-group">
                <input type="text" name="userid" class="form-control" placeholder="User ID">
            </div>
            <div class="form-group">
                <input type="password" name="password" class="form-control" placeholder="Password">
            </div>
        </div>
        <div class="footer bg-black">
            <button type="submit" class="btn bg-blue-gradient btn-block">ログイン</button>
        </div>
    </form>
</div>


<!-- jQuery 2.0.2 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
<!-- Bootstrap -->
<script src="/kintai/js/bootstrap.min.js" type="text/javascript"></script>
<script type="text/javascript">
    function check(){
        var flag=0;
        var msg=document.getElementById("errorMessage");
        msg.innerHTML="   ";
        //必須項目設定
        if(document.userForm.userid.value==""){flag=1;}
        if(document.userForm.password.value==""){flag=1;}
        if(flag){
            msg.innerHTML="ユーザ名とパスワードを両方入力ください";
            return false;
        }else{
            return true;
        }
    }

</script>

</body></html>
