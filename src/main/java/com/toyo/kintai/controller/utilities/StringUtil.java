package com.toyo.kintai.controller.utilities;


import com.toyo.kintai.entity.Master;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by slip on 2015/04/09.
 */
public class StringUtil {

    /**
     * 指定文字列が空文字列であるか否かの検証
     *
     * @param value
     *            文字列
     * @return　検証結果のブール値
     */
    public static boolean isEmpty(String value) {
        return value == null || value.length() == 0;
    }

    /**
     * 指定文字列が空文字列でないか否かの検証
     *
     * @param value
     *            文字列
     * @return 検証結果のブール値
     */
    public static boolean isNotEmpty(String value) {
        return value != null && value.length() != 0;
    }

    /**
     * 文字列を結合する
     *
     * @param buff
     *            対象文字列を格納する配列
     * @return　結合後の文字列
     */
    public static String concat(String... buff) {
        StringBuffer sb = new StringBuffer("");
        for (String value : buff) {
            if (isNotEmpty(value)) {
                if (sb.length() != 0) {
                    sb.append(" ");
                }
                sb.append(value);
            }
        }
        return sb.toString();
    }

    /**
     * 文字列を結合する
     *
     * @param delimit
     *            デリミタ文字列
     * @param buff
     *            対象文字列を格納する配列
     * @return　結合後の文字列
     */
    public static String concatWithDelimit(String delimit, String... buff) {
        StringBuffer sb = new StringBuffer("");
        for (String value : buff) {
            if (isNotEmpty(value)) {
                if (sb.length() != 0) {
                    sb.append(delimit);
                }
                sb.append(value);
            }
        }
        return sb.toString();
    }
    /**
     * 文字列を結合する
     *
     * @param list
     *            対象文字列を格納する配列
     * @return　結合後の文字列
     */
    public static String concat(List<String> list) {
        StringBuffer sb = new StringBuffer("");
        for (String value : list) {
            if (isNotEmpty(value)) {
                if (sb.length() != 0) {
                    sb.append(" ");
                }
                sb.append(value);
            }
        }
        return sb.toString();
    }
    /**
     * 文字列はnullの場合は、空文字を戻す
     *
     */
    public static String nullCheck(String target){
        String tmp=target.toLowerCase();
        if(tmp.equals("null")){
            return "";
        }else{
            return target;
        }
    }

    //文字列 sort用　比べる
    public static int compareString(String s1, String s2) {
        if (s1 == null && s2 == null) return 0;
        else if (s1 == null) return -1;
        else if (s2 == null) return  1;
        else return s1.compareTo(s2);
    }

    //文字列 一部出力　シート名　31文字まで
    public static String leftString(String s1, int len) {
        if (s1 == null && len == 0) return s1;
        else if (s1.length()<(len-1)) return s1;
        else return s1.substring(0, (len-1));
    }


    //MasterデータからList作成
    public static List<String> masterAutoEnterList(List<Master> masters){
        List<String> listTemp=new ArrayList<String>();
        if(masters.size()==0 || masters==null){
        }else{
            for(int i=0;i<masters.size();i++){
                Master mastertemp=masters.get(i);
                String tempLabel="['"+mastertemp.getName()+"' ,'"+mastertemp.getRyaku()+"  "+mastertemp.getKana()+"']"; //漢字＋ひらかな＋カタカナ　　漢字のみ表示される

                listTemp.add(tempLabel);
            }
        }
        return listTemp;
    }

    //客先　MasterデータからList作成
    public static List<String> masterAutoEnterListCustom(List<Master> masters){
        List<String> listTemp=new ArrayList<String>();
        if(masters.size()==0 || masters==null){
        }else{
            for(int i=0;i<masters.size();i++){
                Master mastertemp=masters.get(i);
                String tempLabel=mastertemp.getName()+"　"+mastertemp.getKana(); //漢字＋ひらかな＋カタカナ
                tempLabel=rtrim(tempLabel);
                String tempLabelAll="['"+tempLabel+"','"+mastertemp.getRyaku()+"']"; //漢字＋ひらかな＋カタカナ　　漢字のみ表示される

                listTemp.add(tempLabelAll);
            }
        }
        return listTemp;
    }

    //客先　MasterデータからMap作成
    public static Map<String,String> masterAutoEnterListCustomMap(List<Master> masters){
        Map<String,String> listTemp=new HashMap();
        if(masters.size()==0 || masters==null){
        }else{
            for(int i=0;i<masters.size();i++){
                Master mastertemp=masters.get(i);
                String tempLabel=mastertemp.getName()+"　"+mastertemp.getKana(); //漢字＋ひらかな＋カタカナ
                tempLabel=rtrim(tempLabel);
                listTemp.put(tempLabel,mastertemp.getCode());
            }
        }
        return listTemp;
    }

    //文字列 sort用　比べる
    public static String emptyToZero(String s1) {
        if ("".equals(s1) || s1 == null){
            return "0";
        }else{
            return s1;
        }
    }

    public static String ltrim(String str)
    {
        int i = 0;
        while (i < str.length() && Character.isWhitespace(str.charAt(i))) {
            i++;
        }
        return str.substring(i);
    }

    public static String rtrim(String str)
    {
        int i = str.length() - 1;
        while (i >= 0 && Character.isWhitespace(str.charAt(i))) {
            i--;
        }
        return str.substring(0, i + 1);
    }
    /**
     * 指定されたパターン文字列の文字列を Date オブジェクトにして返します。
     * Date オブジェクトとして有効でない場合は null を返します。
     *
     * @param value 日付を表す文字列
     * @param format 日付を表す文字列のパターン書式 (yyyy/MM/dd など)
     * @return 日付を表す文字列の Date オブジェクト
     */
    public static Date toDate1(String value, String format) {

        if ( value == null || value == "" )
            return null;

        if ( format == null || format == "" )
            format = "yyyy/MM/dd";

        // 日付フォーマットを作成
        SimpleDateFormat dateFormat = new SimpleDateFormat(format);

        // 日付の厳密チェックを指定
        dateFormat.setLenient(false);

        try {
            // 日付値を返す
            return dateFormat.parse(value);
        } catch ( ParseException e ) {
            // 日付値なしを返す
            return null;
        } finally {
            dateFormat = null;
        }
    }

    /**
     * 指定されたパターン文字列の文字列を Date オブジェクトにして返します。
     * Date オブジェクトとして有効でない場合は null を返します。
     *
     * @param value 日付を表す文字列
     * @return 日付を表す文字列の Date オブジェクト
     */
    public static Date toDate(String value) {
        return toDate1(value, "yyyy/MM/dd");
    }

    // 進捗状況に基づいて進捗状況FLGの値を取得するメソッド
    public static String getItemBValue(String itemA, Map<String, String> statusMap) {
        return statusMap.getOrDefault(itemA, "-1"); // デフォルト値は-1（無効な値）とする
    }


    // nullやundefinedの場合は空文字、それ以外は文字列に変換して返す関数
    public  static String safeString(String value) {
        return value == null ? "" : value.toString().trim();
    }

    // 数字の文字列にカンマがいれる 金額場合
    public static String getformatterForString(String itemA) {
        // 文字列が数字かどうかを確認
        if (isNumeric(itemA)) {
            // 数字であれば、カンマを挿入
            DecimalFormat formatter = new DecimalFormat("#,###");
            double number = Double.parseDouble(itemA);
            itemA=formatter.format(number);
        }
        return itemA;
    }

    // 数字かどうかを確認するメソッド
    public static boolean isNumeric(String str) {
        try {
            Double.parseDouble(str);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static int parseInteger(String str) {
        if (str == null || str.trim().isEmpty()) {
            return 0;
        }

        // 数字のみかどうかを確認（正規表現を使用）
        if (str.matches("\\d+")) {
            return Integer.parseInt(str);
        }

        // 数字以外が含まれている場合は 0 を返す（または例外をスローしてもよい）
        return 0;
    }

    private BigDecimal toBigDecimal(String value) {
        try {
            return new BigDecimal(value);
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

}
