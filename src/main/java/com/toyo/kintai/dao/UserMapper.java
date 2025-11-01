package com.toyo.kintai.dao;

import com.toyo.kintai.entity.User;

import java.util.List;

/**
 * Created by slip on 2025/03/28.
 */
public interface UserMapper {
    /**useridからユーザを取得*/
    public User findByUserId(User user);

    /**useridからユーザを取得*/
    public User findByUserIdOnly(String userId);

    /**user権限からユーザ名を取得*/
    public List<String> findUserByKengen(String kengen);
}
