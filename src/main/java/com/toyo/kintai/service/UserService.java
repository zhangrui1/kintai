package com.toyo.kintai.service;

import com.toyo.kintai.dao.UserMapper;
import com.toyo.kintai.entity.User;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * Created by slip on 14/11/14.
 */
@Service
public class UserService {

    @Resource
    UserMapper userMapper;

    /**userid,passwordからユーザを取得*/
    public User getUserByUseridAndPassword(String userid,String password){
        User userTem=new User();
        userTem.setUserid(userid);
        userTem.setPassword(password);

        User user = userMapper.findByUserId(userTem);

        if(user!=null){
            return user;
        } else {
            return null;
        }
    }

    /**権限からユーザ名リストを取得*/
    public List<String> getUserByKengen(String kengen){
        List<String> username=userMapper.findUserByKengen(kengen);
        return  username;
    }

    /**useridからユーザを取得*/
    public User getUserByUserId(String userId){
        User user=userMapper.findByUserIdOnly(userId);
        return  user;
    }
}
