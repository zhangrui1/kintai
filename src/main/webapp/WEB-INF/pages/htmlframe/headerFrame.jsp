<%--
  Created by IntelliJ IDEA.
  Date: 2025/03/28
  Time: 2:33 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header class="header">
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-vc" role="navigation">
        <div class="container">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="/kintai/rTrade/getNewRecycleTrade">slip </a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">

                <form class="navbar-form navbar-left" role="search" action="/kintai/">

                </form>
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="/kintai/rTrade/getNewRecycleTrade">新規伝票</a></li>
                    <li><a href="/kintai/rCustomer/getAllRecycleCustomerList">取引先管理</a></li>
                    <li><a href="/kintai/rTrade/rTradeStockSearchPage">集計</a></li>
                    <li><a href="/kintai/rProduct/rProductStockSearch">在庫管理</a></li>
                    <li><a href="/kintai/rProduct/getAllRecycleProductList">品目管理</a></li>
                    <li><a href="/kintai/rTrade/rTradeSearchPage">取引履歴</a></li>
                    <li class="dropdown user user-menu">
                            <input type="hidden" id="username" value="${user.username}" />
                            <input type="hidden" id="userKengen" value="${user.kengen}" />
                    </li>
                   <li><a href="/kintai/logout">ログアウト</a></li>
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
</header>

<!-- ポップアップ用　　　end -->
<script type="text/javascript">
    $(document).ready(function(){
        //ユーザ権限
        var userKengen=$("#userKengen").val();
        if(userKengen=="6"){
            $(".kengen-operation").show();
        }else if(userKengen.length>0){
            $(".kengen-operation").hide();
        }else{
        }
    });

    //図面アップための変数  本番
   var BUCKET = 'slip'; //本番

    // 英数字　全角英数字文字列を半角文字列に変換する
    String.prototype.toOneByteAlphaNumeric = function(){
        return this.replace(/[Ａ-Ｚａ-ｚ０-９]/g, function(s) {
            return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
        });
    }
    // カタカナ　全角を半角に変換する
    function tozenkaku(val){
        //配列を用意する
        hankaku = new Array("ｶﾞ", "ｷﾞ", "ｸﾞ", "ｹﾞ", "ｺﾞ", "ｻﾞ", "ｼﾞ", "ｽﾞ", "ｾﾞ", "ｿﾞ", "ﾀﾞ", "ﾁﾞ", "ﾂﾞ", "ﾃﾞ", "ﾄﾞ", "ﾊﾞ", "ﾊﾟ", "ﾋﾞ", "ﾋﾟ", "ﾌﾞ", "ﾌﾟ", "ﾍﾞ", "ﾍﾟ", "ﾎﾞ", "ﾎﾟ", "ｳﾞ", "ｧ", "ｱ", "ｨ", "ｲ", "ｩ", "ｳ", "ｪ", "ｴ", "ｫ", "ｵ", "ｶ", "ｷ", "ｸ", "ｹ", "ｺ", "ｻ", "ｼ", "ｽ", "ｾ", "ｿ", "ﾀ", "ﾁ", "ｯ", "ﾂ", "ﾃ", "ﾄ", "ﾅ", "ﾆ", "ﾇ", "ﾈ", "ﾉ", "ﾊ", "ﾋ", "ﾌ", "ﾍ", "ﾎ", "ﾏ", "ﾐ", "ﾑ", "ﾒ", "ﾓ", "ｬ", "ﾔ", "ｭ", "ﾕ", "ｮ", "ﾖ", "ﾗ", "ﾘ", "ﾙ", "ﾚ", "ﾛ", "ﾜ", "ｦ", "ﾝ");
        zenkaku  = new Array("ガ", "ギ", "グ", "ゲ", "ゴ", "ザ", "ジ", "ズ", "ゼ", "ゾ", "ダ", "ヂ", "ヅ", "デ", "ド", "バ", "パ", "ビ", "ピ", "ブ", "プ", "ベ", "ペ", "ボ", "ポ", "ヴ", "ァ", "ア", "ィ", "イ", "ゥ", "ウ", "ェ", "エ", "ォ", "オ", "カ", "キ", "ク", "ケ", "コ", "サ", "シ", "ス", "セ", "ソ", "タ", "チ", "ッ", "ツ", "テ", "ト", "ナ", "ニ", "ヌ", "ネ", "ノ", "ハ", "ヒ", "フ", "ヘ", "ホ", "マ", "ミ", "ム", "メ", "モ", "ャ", "ヤ", "ュ", "ユ", "ョ", "ヨ", "ラ", "リ", "ル", "レ", "ロ", "ワ", "ヲ", "ン");

        //変換開始
        for (i=0; i<=80; i++) { //80文字あるのでその分だけ繰り返す
            while (val.indexOf(hankaku[i]) >= 0){ //該当する半角カナがなくなるまで繰り返す
                val = val.replace(hankaku[i], zenkaku[i]); //半角カナに対応する全角カナに置換する
            }
        }
        return val;
    }

    // 半角数字とハイフ-のみ  電話番号　fax  郵便番号
    function validateNumericAndHaInput(event) {
        event.target.value = event.target.value.replace(/[^0-9\-]/g, '');
    }
    // 半角数字のみ  車番
    function validateNumericInput(event) {
        event.target.value = event.target.value.replace(/[^0-9]/g, '');
    }
    // 半角数字のみ  金額
    function validateNumericInputForMoney(event) {
        const input = event.target;

        // 数字以外を除去
        let rawValue = input.value.replace(/[^\d]/g, '');

        // カンマ付きで表示
        input.value = formatNumberWithComma(rawValue);
    }
    // 半角英数字のみ  登録番号
    function validateAlphaNumericInput(event) {
        event.target.value = event.target.value.replace(/[^0-9a-zA-Z]/g, '');
    }
    // select 項目設定
    function checkSelect(obj,val){
        for(var i=0;i<obj.length;i++){
            if(obj[i].value==val){
                obj[i].selected=true;
                break;
            }
        }
    }
    //Logout 関数
    function logoutFun(){
        var href = window.location.href ;
        console.log("href="+href);
        var tmp=href.split("slip");
        var newURL="";

        if(tmp.length>=1){
            newURL= tmp[0]+"slip";
        }else{
            newURL="https://example.com/kintai/";
        }
        console.log("newURL="+newURL);
        window.location.href =newURL;
    }

    // 配列内のすべての改行コードを置換する関数
    function replaceNewlinesInArray(data) {
        var newData = []; // 新しい配列を作成
        for (var i = 0; i < data.length; i++) {
            var row = data[i];
            var newRow = {}; // 行ごとに新しいオブジェクトを作成

            for (var key in row) {
                if (row.hasOwnProperty(key)) {
                    var value = row[key];
                    // 文字列かつ改行コードがある場合のみ置換
                    if (typeof value === 'string') {
                        newRow[key] = value.replaceAll('\\n', '<br>');
                    } else {
                        newRow[key] = value; // 文字列以外はそのまま
                    }
                }
            }

            newData.push(newRow); // 新しいデータを追加
        }
        return newData;
    }
    // カンマ付き表示用関数
    function formatNumberWithComma(value) {
        const num = value.replace(/[^\d]/g, ''); // 数字以外除去
        return num.replace(/\B(?=(\d{3})+(?!\d))/g, ","); // カンマ挿入
    }
    // カンマを除去して数値に変換する関数
    function parseNumber(value) {
        return parseFloat(value.replace(/,/g, '')) || 0;
    }

    /**
     * 数値の3桁カンマ区切り
     * 入力値をカンマ区切りにして返却
     * [引数]   numVal: 入力数値
     * [返却値] String(): カンマ区切りされた文字列
     */
    function addFigure(numVal) {
        // 空の場合そのまま返却
        if (numVal == ''){
            return '';
        }
        // 全角から半角へ変換し、既にカンマが入力されていたら事前に削除
        numVal = toHalfWidth(numVal).replace(/,/g, "").trim();
        // 数値でなければそのまま返却
        // チェック条件パターン
        var pattern = /^[+,-]?([1-9]\d*|0)$/;
        if (! pattern.test(numVal) ){
            alert("数字のみ入力してください");
            return 0;
        }
        // 整数部分と小数部分に分割
        var numData = numVal.toString().split('.');
        // 整数部分を3桁カンマ区切りへ
        numData[0] = Number(numData[0]).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        // 小数部分と結合して返却
        return numData.join('.');
    }

    /**
     * 数値かどうかチェック
     */
    function isSuji(numVal){
        // 空の場合そのまま返却
        if (numVal == ''){
            return '';
        }
        // 全角から半角へ変換し、既にカンマが入力されていたら事前に削除
        numVal = toHalfWidth(numVal).replace(/,/g, "").trim();
        // 数値でなければそのまま返却
        if ( !/^[+|-]?(\d*)(\.\d+)?$/.test(numVal) ){
            return 1;//数字ではない
//            window.alert("数字のみ入力してください");
        }else{
            return 0;//数字
        }
    }

    /**
     * カンマ外し
     * 入力値のカンマを取り除いて返却
     * [引数]   strVal: 半角でカンマ区切りされた数値
     * [返却値] String(): カンマを削除した数値
     */
    function delFigure(strVal){
        return strVal.replace( /,/g , "" );
    }
    /**
     * 全角から半角への変革関数
     * 入力値の英数記号を半角変換して返却
     * [引数]   strVal: 入力値
     * [返却値] String(): 半角変換された文字列
     */
    function toHalfWidth(strVal){
        // 半角変換
        var halfVal = strVal.replace(/[！-～]/g,
                function( tmpStr ) {
                    // 文字コードをシフト
                    return String.fromCharCode( tmpStr.charCodeAt(0) - 0xFEE0 );
                }
        );
        return halfVal;
    }

//ポップアップの閉じるボタン　ロールオーバー用
    function initRollovers() {
        if (!document.getElementById) return

        var aPreLoad = new Array();
        var sTempSrc;
        var aImages = document.getElementsByTagName('img');

        for (var i = 0; i < aImages.length; i++) {
            if (aImages[i].className == 'imgover') {
                var src = aImages[i].getAttribute('src');
                var ftype = src.substring(src.lastIndexOf('.'), src.length);
                var hsrc = aImages[i].getAttribute('hsrc');

                aImages[i].setAttribute('hsrc', hsrc);

                aPreLoad[i] = new Image();
                aPreLoad[i].src = hsrc;

                aImages[i].onmouseover = function() {
                    sTempSrc = this.getAttribute('src');
                    this.setAttribute('src', this.getAttribute('hsrc'));
                }

                aImages[i].onmouseout = function() {
                    if (!sTempSrc) sTempSrc = this.getAttribute('src').replace('_o'+ftype, ftype);
                    this.setAttribute('src', sTempSrc);
                }
            }
        }
    }
    // ページ上部に戻る　
    document.addEventListener("DOMContentLoaded", function() {
        // Get the button
        var mybutton = document.getElementById("scrollToTopBtn");

        // When the user scrolls down 20px from the top of the document, show the button
        window.onscroll = function() {
            scrollFunction();
        };

        function scrollFunction() {
            if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                mybutton.style.display = "block";
            } else {
                mybutton.style.display = "none";
            }
        }

        // When the user clicks on the button, scroll to the top of the document
        mybutton.addEventListener("click", function(event) {
            event.preventDefault();
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
        });
    });

window.onload = initRollovers;
</script>