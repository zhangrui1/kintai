<%--
  Created by IntelliJ IDEA.
  User:
  Date: 25/03/29
  Time:
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>slip</title>
<%--    <link rel="shortcut icon" href="/kintai/img/valdac32.ico" type="image/vnd.microsoft.icon">--%>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <!-- jQuery より先に datetimepicker を読み込んでないか？ -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />


    <!-- Morris chart -->
    <link href="/kintai/css/morris/morris.css" rel="stylesheet" type="text/css" />
    <!-- jvectormap -->
    <link href="/kintai/css/jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet" type="text/css" />
    <%--<!-- Date Picker -->--%>
    <link href="/kintai/css/datepicker/datepicker3.css" rel="stylesheet" type="text/css" />
    <%--<!-- Daterange picker -->--%>
    <link href="/kintai/css/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" type="text/css" />
    <link href="/kintai/css/slip.css" rel="stylesheet" type="text/css" />
    <!--テーブルそっと用-->
    <link href="/kintai/js/themes/blue/style.css" rel="stylesheet" type="text/css" media="print, projection, screen" />
    <link href="/kintai/css/layui.css" rel="stylesheet" type="text/css" />
    <%--lightbox--%>
    <link href="/kintai/css/lightbox2/css/lightbox.css" rel="stylesheet" type="text/css" />
    <%--helper--%>
    <link href="/kintai/css/helper.css" rel="stylesheet" type="text/css" />
    <link href="/kintai/css/backToTop.css" rel="stylesheet" type="text/css" />
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="/kintai/js/respond.min.js"></script>
    <![endif]-->
    <script src="https://code.jquery.com/ui/1.11.1/jquery-ui.min.js" type="text/javascript"></script>
    <script>window.jQuery || document.write('<script src="/kintai/js/plugins/google/jquery-ui-1.11.4.min.js"><\/script>')</script>
    <%--for google upload images--%>
    <script src="https://apis.google.com/js/client.js"></script>
    <%--<!-- daterangepicker -->--%>
    <script src="/kintai/js/plugins/daterangepicker/daterangepicker.js" type="text/javascript"></script>
    <%--<!-- datepicker -->--%>
    <script src="/kintai/js/plugins/datepicker/bootstrap-datepicker.js" type="text/javascript"></script>
    <script src="/kintai/js/plugins/datepicker/locales/bootstrap-datepicker.ja.js" type="text/javascript"></script>
    <!-- Latest compiled and minified JavaScript -->
    <script src="/kintai/js/bootstrap.min.js"></script>
<%--    <script src="/kintai/js/addKouji.js"></script>--%>
    <script src="/kintai/js/jQueryRotate.js" type="text/javascript"></script>

    <script src="/kintai/js/jquery.tablesorter.min.js" type="text/javascript"></script>

    <script src="/kintai/js/layui/layui.js" type="text/javascript"></script>
    <script src="/kintai/css/lightbox2/js/lightbox.js" type="text/javascript"></script>
    <%--helper--%>
    <script type="text/javascript" src="/kintai/js/help_wide.js"></script>
    <script type="text/javascript" src="/kintai/js/iepngfix.js"></script>

    <!-- datetimepicker用のCSSとJSを正しく読み込んでるか？ -->
<%--    <script src="/kintai/js/plugins/datetimepicker/jquery.datetimepicker.js"></script>--%>
<%--    <link rel="stylesheet" href="/kintai/css/datetimepicker/jquery.datetimepicker.css">--%>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <!-- moment.js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <!-- datetimepicker CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/css/bootstrap-datetimepicker.min.css"/>
    <!-- datetimepicker JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js"></script>


</head>
