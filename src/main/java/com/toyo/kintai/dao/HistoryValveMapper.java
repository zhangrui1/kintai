package com.toyo.kintai.dao;


import com.toyo.kintai.entity.HistoryValve;

/**
 * Created by slip on 2025/03/28.
 */
public interface HistoryValveMapper {

    /**historyTable 新規追加*/
    public void insertHV(HistoryValve historyValve);

}
