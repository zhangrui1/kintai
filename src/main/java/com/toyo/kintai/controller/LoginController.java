package com.toyo.kintai.controller;

import com.toyo.kintai.entity.User;
import com.toyo.kintai.service.UserService;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

/**
 * Created by  on 2025/03/29.
 */

@Controller
@RequestMapping("/login")
public class LoginController {

    @Autowired
    UserService userService;



//    @GetMapping("/")
//    public String loginPageTo(HttpSession session){
//        User user = (User) session.getAttribute("user");
//        session.setAttribute("user",user);
//        if(user != null){
//            return "redirect:/";
//        } else {
//            return Config.LoginSession;
//        }
//    }
//
//
//    /**
//     * ユーザ名とパスワードにより、ログイン
//     *
//     * @param userid ユーザ名
//     * @param password パスワード
//     *
//     * @return String　ユーザ名とパスワードは正しい場合はIndex画面へ遷移、
//     * 　　　　　　　　　間違えた場合は、ログイン画面に戻す
//     * */
////    @RequestMapping(method = RequestMethod.POST)
//    @RequestMapping(value = "/",method = RequestMethod.POST)
//    public String loginByUserid(@RequestParam("userid")String userid,
//                                @RequestParam("password")String password,
//                                HttpSession session){
//        //password暗号化 SHA256でハッシュ
//        String passwordSHA= DigestUtils.sha256Hex(password);
//        User user = userService.getUserByUseridAndPassword(userid,passwordSHA);
//        session.setAttribute("imageRoot","http://storage.googleapis.com/valdacconstruction/");
//        if(user == null){
//            session.setAttribute("message","ユーザー名またはパスワードが違います。");
//            return Config.LoginSession;
//        } else {
//            session.setAttribute("message",null);
//            session.setAttribute("user",user);
//            return "redirect:/rTrade/getNewRecycleTrade";
//        }
//    }
}
