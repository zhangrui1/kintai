package com.toyo.kintai.service;

import com.toyo.kintai.controller.Config;
import com.toyo.kintai.dao.HistoryValveMapper;
import com.toyo.kintai.entity.HistoryValve;
import com.toyo.kintai.entity.User;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by  on 2025/3/28.
 */
@Service
public class HistoryValveService {

    @Resource
    HistoryValveMapper historyValveMapper;


    /**ics 新規追加*/
    public HistoryValve addHistoryValve(String hTablename,String hTargetId,String hDetail,String hHost,String hUpdateBefore,String hUpdateAfter,HttpSession session,HttpServletRequest request){
        User user=(User)session.getAttribute("user");
        HistoryValve historyValve=new HistoryValve();
        if(user != null){
            historyValve.sethUsername(user.getUsername());
            historyValve.sethTablename(hTablename);
            if(hTargetId.length()>255){
                hTargetId=hTargetId.substring(0,254);//項目の長さに制限があるため
            }
            if(hHost.length()>254){
                hHost=hHost.substring(0,250);//項目の長さに制限があるため
            }
            if(hUpdateBefore.length()>1999){
                hUpdateBefore=hUpdateBefore.substring(0,1990);//項目の長さに制限があるため
            }
            if(hUpdateAfter.length()>1999){
                hUpdateAfter=hUpdateAfter.substring(0,1990);//項目の長さに制限があるため
            }
            historyValve.sethTargetId(hTargetId);
            historyValve.sethDetail(hDetail);
            historyValve.sethHost(hHost);
            historyValve.sethUpdateAfter(hUpdateAfter);
            historyValve.sethUpdateBefore(hUpdateBefore);

            String ipTmp="unKonwn";
            historyValve.sethIp(Config.getIpAddr(request));
            System.out.println("ip config="+ Config.getIpAddr(request));

            //append Date
            Date date = new Date();
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            historyValve.sethTrkDate(sdf1.format(date));

            historyValveMapper.insertHV(historyValve);
        }
        return historyValve;

    }


}
