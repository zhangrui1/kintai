package com.toyo.kintai.controller;

import jakarta.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Created by  on 2025/03/29.
 * 共有部分を定義する
 */
public class Config {

    /**機器分類　種別*/
    public static final String LoginSession = "login";
    public static final String TLogin = "login";
    public static final String TLogout = "logout";
    public static final String TUserNull = "null";

    /**操作名　*/
    public static final String TAdd = "新規";
    public static final String TAddPage = "新規ページへ";
    public static final String TEdit = "編集";
    public static final String TDetail = "詳細";
    public static final String TDelete = "削除";
    public static final String TList = "一覧へ";
    public static final String TSearch = "検索";
    /**テーブル名　*/
    public static final String recycle_customer = "recycle_customer";
    public static final String recycle_detail = "recycle_detail";
    public static final String recycle_product = "recycle_product";
    public static final String recycle_trade = "recycle_trade";

    /**テーブル名　*/
    public static final String Ttrade_type = "買取"; //取引区分
    public static final String Ttrade_pay = "現金"; //支払区分
    public static final String Ttrade_transport = "持込"; //運搬区分
    public static final String Ttrade_tax = "税込";//税区分
    public static final String Ttrade_taxNo = "税抜";//税区分
    public static final String Tproduct_unit = "kg";//商品単位


    public static final String TcustomerTypeYes = "M";//会員場合
    public static final String TcustomerTypeNo = "N";//会員場合

    //guest　IP 取得
    public static String getIpAddr(HttpServletRequest request) {

        String ip = request.getHeader("x-forwarded-for");

        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {

            ip = request.getHeader("Proxy-Client-IP");

        }

        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {

            ip = request.getHeader("WL-Proxy-Client-IP");

        }

        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {

            ip = request.getRemoteAddr();

        }

        return ip;

    }

}
