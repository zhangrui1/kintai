/**
 * Created by slip on 2024/05/23.
 */
//=====================================
// スペックヘルプポップアップ表示
//=====================================

var isWMSIE;
var nowWHelpId;
var SpecWBalloonObj;
var SpecWInboxObj;
var BlWMidObj;
var IframeWObj;

function initWideBalloon(){
    var uaidx;
    var version;
    this.SpecWBalloonObj = document.getElementById('SpecBalloonWide');
    this.BlWMidObj = document.getElementById('BlWMid');

    uaidx = navigator.userAgent.indexOf('MSIE');

    if(uaidx >= 0)
    {
        version = navigator.userAgent.substring(uaidx+5,uaidx+7);
        version = version.replace(".","");
    }

    if(uaidx >= 0 &&
        version <= 6 &&
        navigator.userAgent.indexOf('Opera') < 0){
        this.isWMSIE = true;
    }else{
        this.isWMSIE = false;
    }

    // IE6の場合にヘルプポップアップがプルダウンの裏側にならないようにIFRAMEの上に描画する
    if(this.isWMSIE){
        this.IframeWObj = document.createElement('IFRAME');
        this.IframeWObj.setAttribute('frameborder','no');
        this.IframeWObj.setAttribute('src','about:blank');
        this.IframeWObj.style.position = 'absolute';
        this.IframeWObj.style.left = '2px';
        this.IframeWObj.style.width = '530px';
        this.IframeWObj.style.height = '0px';
        this.BlWMidObj.appendChild(this.IframeWObj);
    }

    this.SpecWInboxObj = document.createElement('div');
    this.SpecWInboxObj.className = 'Inbox';
    this.BlWMidObj.appendChild(this.SpecWInboxObj);

    this.addWideEvent(this.SpecWBalloonObj, 'click', function(){ hideWideHelp(); });
}

function showWideHelp(obj, helpId){
    var posX;
    var posY;

    if(!SpecWInboxObj){
        initWideBalloon();
    }

    if(this.SpecWBalloonObj.style.display == 'block' && this.nowWHelpId == helpId) {
        // 今表示しているポップアップなら閉じる
        this.hideWideHelp();
    } else {

        if(window.SpecBalloonObj != undefined && window.SpecBalloonObj.style.display == 'block') {
            // 通常のポップアップが表示されていたら閉じる
            if(typeof(window.hideHelp) == 'function') hideHelp();
        }

        this.nowWHelpId = helpId;
        this.SpecWInboxObj.innerHTML = document.getElementById(helpId).innerHTML;
        this.SpecWBalloonObj.style.display = 'block';

        posX = getWideLocation(obj, 'X');
        posY = getWideLocation(obj, 'Y');

        document.getElementById('BlWTop').style.display  = 'none';
        document.getElementById('BlWTopL').style.display = 'none';
        document.getElementById('BlWTopR').style.display = 'none';
        document.getElementById('BlWBtm').style.display  = 'none';
        document.getElementById('BlWBtmL').style.display = 'none';
        document.getElementById('BlWBtmR').style.display = 'none';

        if(posX - SpecWBalloonObj.offsetWidth > 0){
            //左はめり込まない
            if(posY - SpecWBalloonObj.offsetHeight - 27 - 49 - 220 > 0){
                //右上
                document.getElementById('BlWTop').style.display  = 'block';
                document.getElementById('BlWBtmL').style.display = 'block';
                this.SpecWBalloonObj.style.top = posY - SpecWBalloonObj.offsetHeight - 3 + 'px';
            }else{
                //右下
                document.getElementById('BlWTopL').style.display = 'block';
                document.getElementById('BlWBtm').style.display  = 'block';
                this.SpecWBalloonObj.style.top = posY + 15 + 'px';
            }
            this.SpecWBalloonObj.style.left = posX - SpecWBalloonObj.offsetWidth + 120 + 'px';
        }else{
            if(posY - SpecWBalloonObj.offsetHeight - 27 - 49 - 220 > 0){
                //左上
                document.getElementById('BlWTop').style.display  = 'block';
                document.getElementById('BlWBtmR').style.display = 'block';
                this.SpecWBalloonObj.style.top = posY - SpecWBalloonObj.offsetHeight - 3 + 'px';
            }else{
                //左下
                document.getElementById('BlWTopR').style.display = 'block';
                document.getElementById('BlWBtm').style.display  = 'block';
                this.SpecWBalloonObj.style.top = posY + 13 + 'px';
            }
            //めり込みを考慮
            if(posX > 100){
                this.SpecWBalloonObj.style.left = posX - 100 + 'px';
            }
        }

        if(this.isWMSIE){
            this.IframeWObj.style.height = SpecWBalloonObj.offsetHeight - 33 + 'px';
        }
    }
}

function initWideBalloonAdvLeft(){
    //広告の左側表示用
    var uaidx;
    var version;

    this.SpecWBalloonObj = document.getElementById('S_SpecBalloonWide');
    this.BlWMidObj = document.getElementById('S_BlWMid');

    uaidx = navigator.userAgent.indexOf('MSIE');

    if(uaidx >= 0)
    {
        version = navigator.userAgent.substring(uaidx+5,uaidx+7);
        version = version.replace(".","");
    }

    if(uaidx >= 0 &&
        version <= 6 &&
        navigator.userAgent.indexOf('Opera') < 0){
        this.isWMSIE = true;
    }else{
        this.isWMSIE = false;
    }

    // IE6の場合にヘルプポップアップがプルダウンの裏側にならないようにIFRAMEの上に描画する
    if(this.isWMSIE){
        this.IframeWObj = document.createElement('IFRAME');
        this.IframeWObj.setAttribute('frameborder','no');
        this.IframeWObj.setAttribute('src','about:blank');
        this.IframeWObj.style.position = 'absolute';
        this.IframeWObj.style.left = '2px';
        this.IframeWObj.style.width = '530px';
        this.IframeWObj.style.height = '0px';
        this.BlWMidObj.appendChild(this.IframeWObj);
    }

    this.SpecWInboxObj = document.createElement('div');
    this.SpecWInboxObj.className = 'Inbox';
    this.BlWMidObj.appendChild(this.SpecWInboxObj);

    this.addWideEvent(this.SpecWBalloonObj, 'click', function(){ hideWideHelp(); });
}

function showWideHelpAdvLeft(obj, helpId){
    //広告の左側表示用
    var posX;
    var posY;

    if(!SpecWInboxObj){
        initWideBalloonAdvLeft();
    }

    if(this.SpecWBalloonObj.style.display == 'block' && this.nowWHelpId == helpId) {
        // 今表示しているポップアップなら閉じる
        this.hideWideHelp();
    } else {

        if(window.SpecBalloonObj != undefined && window.SpecBalloonObj.style.display == 'block') {
            // 通常のポップアップが表示されていたら閉じる
            if(typeof(window.hideHelp) == 'function') hideHelp();
        }

        this.nowWHelpId = helpId;
        this.SpecWInboxObj.innerHTML = document.getElementById(helpId).innerHTML;
        this.SpecWBalloonObj.style.display = 'block';

        posX = getWideLocation(obj, 'X');
        posY = getWideLocation(obj, 'Y');

        document.getElementById('S_BlWTop').style.display  = 'none';
        document.getElementById('S_BlWTopL').style.display = 'none';
        document.getElementById('S_BlWTopR').style.display = 'none';
        document.getElementById('S_BlWBtm').style.display  = 'none';
        document.getElementById('S_BlWBtmL').style.display = 'none';
        document.getElementById('S_BlWBtmR').style.display = 'none';

        if(posX - SpecWBalloonObj.offsetWidth > 0){
            if(posY - SpecWBalloonObj.offsetHeight - 27 - 49 - 220 > 0){
                //右上
                document.getElementById('S_BlWTop').style.display  = 'block';
                document.getElementById('S_BlWBtmL').style.display = 'block';
                this.SpecWBalloonObj.style.top = posY - SpecWBalloonObj.offsetHeight - 3 + 'px';
            }else{
                //右下
                document.getElementById('S_BlWTopL').style.display = 'block';
                document.getElementById('S_BlWBtm').style.display  = 'block';
                this.SpecWBalloonObj.style.top = posY + 15 + 'px';
            }
            this.SpecWBalloonObj.style.left = posX - SpecWBalloonObj.offsetWidth + 120 + 'px';
        }else{
            if(posY - SpecWBalloonObj.offsetHeight - 27 - 49 - 220 > 0){
                //左上
                document.getElementById('S_BlWTop').style.display  = 'block';
                document.getElementById('S_BlWBtmL').style.display = 'block';
                this.SpecWBalloonObj.style.top = posY - SpecWBalloonObj.offsetHeight - 3 + 'px';
            }else{
                //左下
                document.getElementById('S_BlWTopR').style.display = 'block';
                document.getElementById('S_BlWBtm').style.display  = 'block';
                this.SpecWBalloonObj.style.top = posY + 13 + 'px';
            }

            this.SpecWBalloonObj.style.left = posX - 400 + 'px';
        }

        if(this.isWMSIE){
            this.IframeWObj.style.height = SpecWBalloonObj.offsetHeight - 33 + 'px';
        }
    }
}

function hideWideHelp(){
    this.SpecWBalloonObj.style.display = 'none';
}

function getWideLocation(elem, XorY){
    var offset = (XorY.toUpperCase() == 'Y') ? 'offsetTop' : 'offsetLeft';
    var ret = elem[offset];
    var pa = elem.offsetParent;
    while(pa){
        if(pa[offset]) ret += pa[offset];
        pa = pa.offsetParent;
    }
    return ret;
}

function addWideEvent(elm, eventType, functionName)
{
    if(elm.attachEvent){
        elm['e'+eventType+functionName] = functionName;
        elm[eventType+functionName] = function(){elm['e'+eventType+functionName]( window.event );}
        elm.attachEvent( 'on'+eventType, elm[eventType+functionName] );
    } else {
        elm.addEventListener(eventType, functionName, false);
    }
}