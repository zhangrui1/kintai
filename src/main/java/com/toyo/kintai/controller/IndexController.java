package com.toyo.kintai.controller;


import com.toyo.kintai.service.HistoryValveService;
import com.toyo.kintai.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


/**
 * Created by  on 2025/03/29.
 */

@Controller
@RequestMapping("/")
public class IndexController {

    @Autowired
    HistoryValveService historyValveService;
    @Autowired
    UserService userService;
    /**
     * ログイン後のTopページ
     *
     * @return
     *
     * */
    @RequestMapping(method = RequestMethod.GET)
    public String index(HttpSession session, ModelMap modelMap,HttpServletRequest request) throws IOException {

         return "attendance_entry";
    }

    /**
     * 詳細ページの　戻るボタン用
     * */
    @RequestMapping(value="/personal_monthly", method=RequestMethod.GET)
    public String goBack(HttpSession session,HttpServletRequest request){
        return "personal_monthly";
    }

    /**
     * ログアウト
     * */
    @RequestMapping(value="/manager_monthly", method=RequestMethod.GET)
    public String manager_monthly(HttpSession session,HttpServletRequest request){
        //historyテーブルを更新
        return "manager_monthly";
    }
}
