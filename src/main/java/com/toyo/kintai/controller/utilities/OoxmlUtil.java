package com.toyo.kintai.controller.utilities;


import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.usermodel.CreationHelper;

import java.awt.Color;
import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by slip on 2015/04/09.
 */
public class OoxmlUtil {
    /** デフォルトFontファイル名 */
    private static final String DEFAULT_FONT_NAME = "ＭＳ Ｐゴシック";

    public static Map<String,XSSFCellStyle> createCellStyle(XSSFWorkbook wb){
        Map<String,XSSFCellStyle> styleMap=new HashMap<String, XSSFCellStyle>();
        Color color=new Color(255, 255, 255);
        Short fontSize8=7;
        Short fontSize11=11;
        Short fontSize10=10;
        Short fontSize12=12;
        Short fontSize16=16;
        styleMap.put("normal", OoxmlUtil.createTableDataCellStyle(wb,false,false,false,false,color,fontSize10,false));
        styleMap.put("normalSize8", OoxmlUtil.createTableDataCellStyle(wb,false,false,false,false,color,fontSize8,false));
        styleMap.put("normalSize11", OoxmlUtil.createTableDataCellStyle(wb,false,false,false,false,color,fontSize11,false));
        styleMap.put("normalSize12", OoxmlUtil.createTableDataCellStyle(wb,false,false,false,false,color,fontSize12,false));
        styleMap.put("normalSize16", OoxmlUtil.createTableDataCellStyle(wb,false,false,false,false,color,fontSize16,true));
        styleMap.put("normalSizeFalse16", OoxmlUtil.createTableDataCellStyle(wb,false,false,false,false,color,fontSize16,false));
        styleMap.put("isTop", OoxmlUtil.createTableDataCellStyle(wb,true,false,false,false,color,fontSize10,false));
        styleMap.put("isTopSize16", OoxmlUtil.createTableDataCellStyle(wb,true,false,false,false,color,fontSize16,true));
        styleMap.put("isBottom", OoxmlUtil.createTableDataCellStyle(wb,false,true,false,false,color,fontSize10,false));
        styleMap.put("isLeft", OoxmlUtil.createTableDataCellStyle(wb,false,false,true,false,color,fontSize10,false));
        styleMap.put("isLeftSize16", OoxmlUtil.createTableDataCellStyle(wb,false,false,true,false,color,fontSize16,true));
        styleMap.put("isRight", OoxmlUtil.createTableDataCellStyle(wb,false,false,false,true,color,fontSize10,false));
        styleMap.put("isTopAndLeft", OoxmlUtil.createTableDataCellStyle(wb,true,false,true,false,color,fontSize10,false));
        styleMap.put("isTopAndLeftSize16", OoxmlUtil.createTableDataCellStyle(wb,true,false,true,false,color,fontSize16,true));
        styleMap.put("isTopAndRight", OoxmlUtil.createTableDataCellStyle(wb,true,false,false,true,color,fontSize10,false));
        styleMap.put("isTopAndRightSize16", OoxmlUtil.createTableDataCellStyle(wb,true,false,false,true,color,fontSize16,true));
        styleMap.put("isBottomAndLeft", OoxmlUtil.createTableDataCellStyle(wb,false,true,true,false,color,fontSize10,false));
        styleMap.put("isBottomAndLeftSize12", OoxmlUtil.createTableDataCellStyle(wb,false,true,true,false,color,fontSize12,true));
        styleMap.put("isBottomAndLeftSize16", OoxmlUtil.createTableDataCellStyle(wb,false,true,true,false,color,fontSize16,true));
        styleMap.put("isBottomAndRight", OoxmlUtil.createTableDataCellStyle(wb,false,true,false,true,color,fontSize10,false));
        styleMap.put("isBottomAndRightSize12", OoxmlUtil.createTableDataCellStyle(wb,false,true,false,true,color,fontSize12,true));
        styleMap.put("isBottomAndRightSize16", OoxmlUtil.createTableDataCellStyle(wb,false,true,false,true,color,fontSize16,true));
        styleMap.put("isLeftAndRight", OoxmlUtil.createTableDataCellStyle(wb,false,false,true,true,color,fontSize10,false));

        return  styleMap;
    }

    /**
     * xlsxファイルを読み込み<b>XSSFWorkbook</b>を生成する
     *
     * @param filePath
     *            ファイルパス
     * @return <b>XSSFWorkbook</b>
     */
    public static XSSFWorkbook load(String filePath) {
        try {
            InputStream inputStream = new FileInputStream(filePath);
            XSSFWorkbook workbook = new XSSFWorkbook(inputStream);
            return workbook;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * xlsxファイルのファイル出力
     *
     * @param workbook
     *            ワークブック
     * @param filePath
     *            ファイルパス
     * @return ファイル出力の成否
     */
    public static boolean saveAs(XSSFWorkbook workbook, String filePath) {
        boolean result = true;
        FileOutputStream out = null;
        try {
            out = new FileOutputStream(filePath);
            workbook.write(out);
        } catch (IOException e) {
            result = false;
        } finally {
            try {
                out.close();
            } catch (IOException e) {
                result = false;
            }
        }
        return result;
    }

    /**
     * 指定した行番号の<b>XSSFRow</b>を取得する。有効範囲外の行の場合は新規作成する。
     *
     * @param sheet
     *            <b>XSSFSheet</b>
     * @param nRow
     *            取得したい行の行番号
     * @return <b>XSSFRow</b>
     */
    public static XSSFRow getRowAnyway(XSSFSheet sheet, int nRow) {
        assert sheet != null;
        XSSFRow row = sheet.getRow(nRow);
        if (row == null) {
            row = sheet.createRow(nRow);
        }
        return row;
    }

    /**
     * 指定した列番号の<b>XSSFCell</b>を取得する。有効範囲外のセルの場合は新規作成する。
     *
     * @param row
     *            <b>XSSFRow</b>
     * @param nColumn
     *            取得したいセルの列番号
     * @return <b>XSSFCell</b>
     */
    public static XSSFCell getCellAnyway(XSSFRow row, int nColumn) {
        assert row != null;
        XSSFCell cell = row.getCell(nColumn);
        if (cell == null) {
            cell = row.createCell(nColumn);
        }
        return cell;
    }

    /**
     * デフォルトのセルスタイルを作成
     *
     * @param workbook
     *            ワークブック
     * @param bold
     *            太字設定フラグ
     * @param centering
     *            センタリングフラグ
     * @param fontSize
     *            フォントサイズ
     * @return <b>CellStyle</b>
     */
    public static XSSFCellStyle createDefaultCellStyle(XSSFWorkbook workbook,
                                                       boolean bold, boolean centering, int fontSize) {
        XSSFFont font = workbook.createFont();
        if (bold) {
            font.setBold(true);
        }
        font.setFontHeightInPoints((short) fontSize);
        font.setFontName(DEFAULT_FONT_NAME);
        XSSFCellStyle style = workbook.createCellStyle();
        style.setFont(font);
        if (centering) {
            style.setAlignment(HorizontalAlignment.CENTER);
        }
        return style;
    }

    /**
     * デフォルトのテーブルヘッダースタイルを作成
     *
     * @param workbook
     *            ワークブック
     * @param bold
     *            太字設定フラグ
     * @param fontSize
     *            フォントサイズ
     * @param backgroundColor
     *            背景色
     * @return <b>CellStyle</b>
     */
    public static XSSFCellStyle createDefaultTableHeaderCellStyle(
            XSSFWorkbook workbook, boolean bold, boolean center, int fontSize,
            Color backgroundColor) {
        XSSFFont font = workbook.createFont();
        if (bold) {
            font.setBold(true);
        }
        font.setFontHeightInPoints((short) fontSize);
        font.setFontName(DEFAULT_FONT_NAME);
        XSSFCellStyle style = workbook.createCellStyle();
        if (center) {
            style.setAlignment(HorizontalAlignment.CENTER);
        }
        style.setFont(font);
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);// 必ずsetFillForegroundColorの直前に記述すること
        style.setFillForegroundColor(new XSSFColor(backgroundColor,null));
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    /**
     * 罫線スタイルの<b>CellStyle</b>を生成
     *
     * @param workbook
     *            ワークブック
     * @return <b>CellStyle</b>
     */
    public static XSSFCellStyle createTableDataCellStyle(XSSFWorkbook workbook) {
        XSSFCellStyle style = workbook.createCellStyle();
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    /**
     * 罫線スタイルの<b>CellStyle</b>を生成
     *
     * @param workbook
     *            ワークブック
     * @param backgroundColor
     *            背景色
     * @return <b>CellStyle</b>
     */
    public static XSSFCellStyle createTableDataCellStyle(XSSFWorkbook workbook,
                                                         Color backgroundColor) {
        XSSFCellStyle style = workbook.createCellStyle();
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);// 必ずsetFillForegroundColorの直前に記述すること
        style.setFillForegroundColor(new XSSFColor(backgroundColor,null));
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }

    /**
     * 罫線スタイルの<b>CellStyle</b>を生成
     *
     * @param workbook
     *            ワークブック
     * @param backgroundColor
     *            背景色
     * @return <b>CellStyle</b>
     */
    public static XSSFCellStyle createTableDataCellStyle(XSSFWorkbook workbook,boolean isTop,boolean isBottom,boolean isLeft,boolean isRight,
                                                         Color backgroundColor,short fontSize,boolean bold) {
        XSSFCellStyle style = workbook.createCellStyle();
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);// 必ずsetFillForegroundColorの直前に記述すること
        style.setFillForegroundColor(new XSSFColor(backgroundColor,null));
        style.setAlignment(HorizontalAlignment.CENTER);//水平方法の位置
        style.setVerticalAlignment(VerticalAlignment.TOP);
        style.setWrapText(true);//折り返して全体を表示する
//        style.setShrinkToFit(true);//縮小して全体を表示する

        //文字サイズ設定
        XSSFFont font = workbook.createFont();
        font.setFontHeightInPoints(fontSize);
        if (bold) {
            font.setBold(true);
        }
        style.setFont(font);

        if(isTop){
            style.setBorderTop(BorderStyle.MEDIUM);
        }else{
            style.setBorderTop(BorderStyle.THIN);
        }
        if(isBottom){
            style.setBorderBottom(BorderStyle.MEDIUM);
        }else{
            style.setBorderBottom(BorderStyle.THIN);
        }
        if(isLeft){
            style.setBorderLeft(BorderStyle.MEDIUM);
        }else{
            style.setBorderLeft(BorderStyle.THIN);
        }
        if(isRight){
            style.setBorderRight(BorderStyle.MEDIUM);
        }else{
            style.setBorderRight(BorderStyle.THIN);
        }
        return style;
    }

    /**
     * 罫線スタイルの<b>CellStyle</b>を生成
     *
     * @param workbook
     *            ワークブック
     * @param isBorder
     *            罫線描画フラグ
     * @param backgroundColor
     *            背景色
     * @return <b>CellStyle</b>
     */
    public static XSSFCellStyle createTableDataCellStyle(XSSFWorkbook workbook,
                                                         boolean isBorder, Color backgroundColor) {
        XSSFCellStyle style = workbook.createCellStyle();
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);// 必ずsetFillForegroundColorの直前に記述すること
        style.setFillForegroundColor(new XSSFColor(backgroundColor,null));
        if (isBorder) {
            style.setBorderTop(BorderStyle.THIN);
            style.setBorderBottom(BorderStyle.THIN);
            style.setBorderLeft(BorderStyle.THIN);
            style.setBorderRight(BorderStyle.THIN);
        }
        return style;
    }

    /**
     * 罫線スタイルの<b>CellStyle</b>を生成
     *
     * @param workbook
     *            ワークブック
     * @param isBorder
     *            罫線描画フラグ
     * @return <b>CellStyle</b>
     */
    public static XSSFCellStyle createTableDataCellStyle(XSSFWorkbook workbook,
                                                         boolean isBorder) {
        XSSFCellStyle style = workbook.createCellStyle();
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);// 必ずsetFillForegroundColorの直前に記述すること
        if (isBorder) {
            style.setBorderTop(BorderStyle.THIN);
            style.setBorderBottom(BorderStyle.THIN);
            style.setBorderLeft(BorderStyle.THIN);
            style.setBorderRight(BorderStyle.THIN);
        }
        return style;
    }

    /**
     * 罫線スタイルの<b>CellStyle</b>を生成
     * 四角の範囲に周囲太線、中は細線を描画する
     *
     * @param workbook
     *            ワークブック
     * @param sheet
     *            シート
     * @param  nRowStart
     *             開始行
     * @param  nRowEnd
     * 　　　　　　終了行
     * @param  nColumnStart
     * 　　　　　　開始列
     * @param  nColumnEnd
     * 　　　　　　終了列
     * @param isBorder
     *            罫線描画フラグ
     * @param  styleMap
     *          罫線style
     */
    public static void setTableDataCellStyle(XSSFWorkbook workbook,XSSFSheet sheet, int nRowStart,int nRowEnd,
                                                          int nColumnStart,int nColumnEnd, boolean isBorder,Map<String,XSSFCellStyle> styleMap) {
        assert sheet != null;

        //Range内のすべてセルに罫線を描画
        for(int rIndex=nRowStart;rIndex<=nRowEnd;rIndex++){
            XSSFRow row = getRowAnyway(sheet, rIndex);
            for(int cIndex=nColumnStart;cIndex<=nColumnEnd;cIndex++){
                XSSFCell cell=getCellAnyway(row,cIndex);
                cell.setCellStyle(styleMap.get("normal"));
            }
        }
        //初行のTopのみ太罫線
        XSSFRow row = getRowAnyway(sheet, nRowStart);

        XSSFCell cell=getCellAnyway(row,nColumnStart);
        cell.setCellStyle(styleMap.get("isTopAndLeft"));
        for(int cIndex=nColumnStart+1;cIndex<nColumnEnd;cIndex++){
            cell=getCellAnyway(row,cIndex);
            cell.setCellStyle(styleMap.get("isTop"));
        }
        cell=getCellAnyway(row,nColumnEnd);
        cell.setCellStyle(styleMap.get("isTopAndRight"));

        //間の行
        for(int cIndexCenter=nRowStart+1;cIndexCenter<nRowEnd;cIndexCenter++){
            row = getRowAnyway(sheet, cIndexCenter);

            cell=getCellAnyway(row,nColumnStart);
            cell.setCellStyle(styleMap.get("isLeft"));

            cell=getCellAnyway(row,nColumnEnd);
            cell.setCellStyle(styleMap.get("isRight"));

        }

        //最後の行のBottomのみ太罫線
        XSSFRow rowEnd = getRowAnyway(sheet, nRowEnd);
        cell=getCellAnyway(rowEnd,nColumnStart);
        cell.setCellStyle(styleMap.get("isBottomAndLeft"));

        for(int cIndex=nColumnStart+1;cIndex<nColumnEnd;cIndex++){
            cell=getCellAnyway(rowEnd,cIndex);
            cell.setCellStyle(styleMap.get("isBottom"));
        }
        cell=getCellAnyway(rowEnd,nColumnEnd);
        cell.setCellStyle(styleMap.get("isBottomAndRight"));

//        CellRangeAddress region=new CellRangeAddress(nRowStart,nRowEnd,nColumnStart,nColumnEnd);
//        short border=BorderStyle.MEDIUM;//太罫線
//        RegionUtil.setBorderTop(border,region,sheet,workbook);
//        RegionUtil.setBorderBottom(border,region,sheet,workbook);
//        RegionUtil.setBorderLeft(border, region, sheet, workbook);
//        RegionUtil.setBorderRight(border, region, sheet, workbook);

    }

    /**
     * 罫線スタイルの<b>CellStyle</b>を生成
     * 1行のみ描画する
     *
     * @param workbook
     *            ワークブック
     * @param sheet
     *            シート
     * @param  nRowStart
     *             開始行
     * @param  nRowEnd
     * 　　　　　　終了行
     * @param  nColumnStart
     * 　　　　　　開始列
     * @param  nColumnEnd
     * 　　　　　　終了列
     * @param isBorder
     *            罫線描画フラグ
     * @param  style
     *          罫線style
     */
    public static void setRowDataCellStyle(XSSFWorkbook workbook,XSSFSheet sheet, int nRowStart,int nRowEnd,
                                           int nColumnStart,int nColumnEnd, boolean isBorder,XSSFCellStyle style) {
        assert sheet != null;

        //Range内のすべてセルに罫線を描画
        for(int rIndex=nRowStart;rIndex<=nRowEnd;rIndex++){
            XSSFRow row = getRowAnyway(sheet, rIndex);
            for(int cIndex=nColumnStart;cIndex<=nColumnEnd;cIndex++){
                XSSFCell cell=getCellAnyway(row,cIndex);
                cell.setCellStyle(style);
            }
        }
    }
    /**
     * 罫線スタイルの<b>CellStyle</b>を生成
     * 1行のみ描画する
     *
     * @param workbook
     *            ワークブック
     * @param sheet
     *            シート
     * @param  nRow
     *             行
     * @param  nColumn
     * 　　　　　　列
     * @param isBold
     *            太字フラグ
     * @param fontSize
     *            文字サイズ
     * @param  fontHeight
     *             行高
     */
    public static void setCellStyleForLabel(XSSFWorkbook workbook,XSSFSheet sheet, int nRow,int nColumn,
                                            boolean isBold,short fontSize,float fontHeight) {
        assert sheet != null;

        //style設定
        XSSFCellStyle style = workbook.createCellStyle();
        XSSFFont font = workbook.createFont();
        if (isBold) {
            font.setBold(true);//文字太字
        }
        font.setFontHeightInPoints((short)fontSize);//文字サイズ
        font.setFontName(DEFAULT_FONT_NAME);
        style.setFont(font);//文字太字　と　文字サイズ

        style.setAlignment(HorizontalAlignment.GENERAL);//水平方向の標準
        style.setVerticalAlignment(VerticalAlignment.TOP);//垂直方向の上詰め
        style.setWrapText(true);//折り返して全体を表示する


        //セルに罫線を描画
        XSSFRow row = getRowAnyway(sheet, nRow);
        XSSFCell cell=getCellAnyway(row,nColumn);
        cell.setCellStyle(style);
        row.setHeightInPoints(fontHeight);//行高設定
    }
    /**
     * 罫線スタイルの<b>CellStyle</b>を生成
     * セル結合
     *
     * @param workbook
     *            ワークブック
     * @param sheet
     *            シート
     * @param  nRowStart
     *             開始行
     * @param  nRowEnd
     * 　　　　　　終了行
     * @param  nColumnStart
     * 　　　　　　開始列
     * @param  nColumnEnd
     * 　　　　　　終了列
     * @param  style
     *          罫線style
     */
    public static void setMerger(XSSFWorkbook workbook,XSSFSheet sheet, int nRowStart,int nRowEnd,
                                 int nColumnStart,int nColumnEnd,XSSFCellStyle style) {
        assert sheet != null;
        sheet.addMergedRegion(new CellRangeAddress(nRowStart,nRowEnd,nColumnStart,nColumnEnd));
        XSSFRow row = getRowAnyway(sheet, nRowStart);
        XSSFCell cell=getCellAnyway(row,nColumnStart);
        cell.setCellStyle(style);
    }
    /**
     * 指定セルのセルスタイルを取得
     *
     * @param sheet
     *            シート
     * @param nRow
     *            行番号
     * @param nColumn
     *            列番号
     * @return <b>CellStyle</b>
     */
    public static XSSFCellStyle getCellStyle(XSSFSheet sheet, int nRow,
                                             int nColumn) {
        assert sheet != null;
        XSSFRow row = getRowAnyway(sheet, nRow);
        XSSFCell cell = getCellAnyway(row, nColumn);
        return cell.getCellStyle();
    }

    /**
     * 行方向のセルの値を合算する
     *
     * @param sheet
     *            編集対象シート
     * @param nRow
     *            行番号
     * @param nStartColumn
     *            開始列番号
     * @param nEndColumn
     *            終了列番号
     * @return 合算値
     */
    public static int sumRow(XSSFSheet sheet, int nRow, int nStartColumn,
                             int nEndColumn) {
        XSSFRow row = sheet.getRow(nRow);
        assert row != null;
        int sum = 0;
        for (int nIndex = nStartColumn; nIndex <= nEndColumn; nIndex++) {
            XSSFCell cell = row.getCell(nIndex);
            assert cell != null;
            if (cell.getCellType() == CellType.NUMERIC) {
                sum += cell.getNumericCellValue();
            }
        }
        return sum;
    }

    /**
     * 列方向のセルの値を合算する
     *
     * @param sheet
     *            編集対象シート
     * @param nColumn
     *            行番号
     * @param nStartRow
     *            開始列番号
     * @param nEndRow
     *            終了列番号
     * @return 合算値
     */
    public static int sumColumn(XSSFSheet sheet, int nColumn, int nStartRow,
                                int nEndRow) {
        int sum = 0;
        for (int nIndex = nStartRow; nIndex <= nEndRow; nIndex++) {
            XSSFRow row = sheet.getRow(nIndex);
            assert row != null;
            XSSFCell cell = row.getCell(nColumn);
            assert cell != null;
            if (cell.getCellType() == CellType.NUMERIC) {
                sum += cell.getNumericCellValue();
            }
        }
        return sum;
    }

    /**
     * 指定行を0で埋める
     *
     * @param sheet
     *            編集対象シート
     * @param nRow
     *            行番号
     * @param nStartColumn
     *            開始列番号
     * @param nEndColumn
     *            終了列番号
     */
    public static void setZero(XSSFSheet sheet, int nRow, int nStartColumn,
                               int nEndColumn) {
        XSSFRow row = getRowAnyway(sheet, nRow);
        for (int nIndex = nStartColumn; nIndex <= nEndColumn; nIndex++) {
            XSSFCell cell = getCellAnyway(row, nIndex);
            cell.setCellType(CellType.NUMERIC);
            cell.setCellValue((double) 0);
        }
    }

    /**
     * 全てのシートの先頭セルにフォーカスをあてる
     *
     * @param workbook
     *            ワークブック
     */
    public static void setFocusFistCell(XSSFWorkbook workbook) {
        assert workbook != null;
        for (int nIndex = 0; nIndex < workbook.getNumberOfSheets(); nIndex++) {
            XSSFSheet sheet = workbook.getSheetAt(nIndex);
            XSSFCell cell = getFirstCell(sheet);
            assert cell != null;
            cell.setAsActiveCell();
        }
    }

    /**
     * 全てのシートの計算式を強制的に再評価させる
     *
     * @param workbook
     *            ワークブック
     */
    public static void setForceFormulaRecalculation(XSSFWorkbook workbook) {
        assert workbook != null;
        for (int nIndex = 0; nIndex < workbook.getNumberOfSheets(); nIndex++) {
            XSSFSheet sheet = workbook.getSheetAt(nIndex);
            sheet.setForceFormulaRecalculation(true);
        }
    }

    /**
     * シートの先頭セルを取得
     *
     * @param sheet
     *            シート
     * @return 先頭<b>Cell</b>
     */
    public static XSSFCell getFirstCell(XSSFSheet sheet) {
        XSSFRow row = getRowAnyway(sheet, 0);
        XSSFCell cell = getCellAnyway(row, 0);
        return cell;
    }

    /**
     * セルの値を取得する
     *
     * @param row
     *            行データ
     * @param nColumn
     *            列番号
     * @return セルの値
     */
    public static Object getData(XSSFRow row, int nColumn) {
        if (row != null) {
            XSSFCell cell = row.getCell(nColumn);
            if (cell != null) {
                if (CellType.NUMERIC == cell.getCellType()) {
                    return cell.getNumericCellValue();
                } else if (CellType.STRING == cell.getCellType()) {
                    return cell.getStringCellValue();
                }
            }
        }
        return null;
    }

    /**
     * セルの値を取得する
     *
     * @param nRow
     *            行番号
     * @param nColumn
     *            列番号
     * @return セルの値
     */
    public static Object getData(XSSFSheet sheet, int nRow, int nColumn) {
        assert sheet != null;
        XSSFRow row = getRowAnyway(sheet, nRow);
        return getData(row, nColumn);
    }

    /**
     * セルに設定された計算式を評価して値を取得する
     *
     * @param nRow
     *            行番号
     * @param nColumn
     *            列番号
     * @return セルの値
     */
    public static Object getDataByEvaluateFormula(XSSFSheet sheet, int nRow,
                                                  int nColumn) {
        assert sheet != null;
        XSSFRow row = getRowAnyway(sheet, nRow);
        if (row != null) {
            XSSFCell cell = row.getCell(nColumn);
            if (cell != null) {
                FormulaEvaluator eval = sheet.getWorkbook().getCreationHelper()
                        .createFormulaEvaluator();
                if (eval != null) {
                    CellValue value = eval.evaluate(cell);
                    if (value != null) {
                        return value.getNumberValue();
                    }
                }
            }
        }
        return null;
    }

    /**
     * セルに文字列を出力する
     *
     * @param row
     *            行
     * @param nColumn
     *            列番号
     * @param object
     *            出力データ
     * @param style
     *            セルスタイル
     * @param zeroValue
     *            値が0の時に設定する文字列
     */
    public static void setData(XSSFRow row, int nColumn, Object object,
                               XSSFCellStyle style, String zeroValue) {
        if (row != null) {
            XSSFCell cell = getCellAnyway(row, nColumn);
            setData(cell, object, style, zeroValue);
        }
    }

    /**
     * セルに文字列を出力する
     *
     * @param sheet
     *            シート
     * @param nRow
     *            出力行番号
     * @param nColumn
     *            出力列番号
     * @param object
     *            出力データ
     * @param style
     *            セルスタイル
     */
    public static void setData(XSSFSheet sheet, int nRow, int nColumn,
                               Object object, XSSFCellStyle style) {
        setData(sheet, nRow, nColumn, object, style, "0");
    }

    /**
     * セルに文字列を出力する
     *
     * @param sheet
     *            シート
     * @param nRow
     *            出力行番号
     * @param nColumn
     *            出力列番号
     * @param object
     *            出力データ
     * @param style
     *            セルスタイル
     * @param zeroValue
     *            値が0の時に設定する値
     */
    public static void setData(XSSFSheet sheet, int nRow, int nColumn,
                               Object object, XSSFCellStyle style, String zeroValue) {
        assert sheet != null && object != null;
        XSSFRow row = getRowAnyway(sheet, nRow);
        XSSFCell cell = getCellAnyway(row, nColumn);
        setData(cell, object, style, zeroValue);
    }

    /**
     * セルに文字列を出力する
     *
     * @param cell
     *            対象セル
     * @param object
     *            出力データ
     * @param style
     *            セルスタイル
     * @param zeroValue
     *            値が0の時に設定する値
     */
    private static void setData(XSSFCell cell, Object object,
                                XSSFCellStyle style, String zeroValue) {
        if((object==null) || (object=="null")){
            object="";
        }
        if (style != null) {
            cell.setCellStyle(style);
        }
        if (object instanceof String) {
            cell.setCellType(CellType.STRING);
            cell.setCellValue((String) object);
        } else if (object instanceof Integer) {
            Integer integer = (Integer) object;
            if (0 == integer) {
                cell.setCellType(CellType.STRING);
                cell.setCellValue(zeroValue);
            } else {
                cell.setCellType(CellType.NUMERIC);
                cell.setCellValue((Integer) object);
            }
        } else if (object instanceof Double) {
            cell.setCellType(CellType.NUMERIC);
            if (Double.isNaN((Double) object)) {
                cell.setCellValue(zeroValue);
            } else {
                Double value = (Double) object;
                if (0 == value.compareTo((Double) 0.0)) {
                    cell.setCellValue(zeroValue);
                } else {
                    cell.setCellValue((Double) object);
                }
            }
        }
    }

    /**
     * 指定範囲にセルを新規作成
     *
     * @param sheet
     *            シート
     * @param startRow
     *            開始行番号
     * @param endRow
     *            終了行番号
     * @param startColumn
     *            開始列番号
     * @param endColumn
     *            終了列番号
     * @param style
     *            セルスタイル
     */
    public static void setStyle(XSSFSheet sheet, int startRow, int endRow,
                                int startColumn, int endColumn, XSSFCellStyle style) {
        for (int nRow = startRow; nRow <= endRow; nRow++) {
            XSSFRow row = getRowAnyway(sheet, nRow);
            for (int nColumn = startColumn; nColumn <= endColumn; nColumn++) {
                XSSFCell cell = getCellAnyway(row, nColumn);
                cell.setCellStyle(style);
            }
        }
    }

    /**
     * シートを生成する
     *
     * @param workbook
     *            ワークブック
     * @param names
     *            シート名を格納する<b>List</b>
     */
    public static void createSheet(XSSFWorkbook workbook, List<String> names) {
        assert workbook != null && names != null;
        for (String name : names) {
            workbook.createSheet(name);
        }
    }

    /**
     * ハイパーリンクの設定
     *
     * @param sheet
     *            シート
     * @param nRow
     *            対象行番号
     * @param nColumn
     *            対象列番号
     * @param value
     *            ハイパーリンクテキスト
     * @param url
     *            ハイパーリンク先URL
     */
    public static void setHyperLink(XSSFSheet sheet, int nRow, int nColumn,
                                    String value, String url) {
        assert sheet != null;
        XSSFWorkbook workbook = sheet.getWorkbook();
        CreationHelper helper = workbook.getCreationHelper();
//        XSSFHyperlink hyperlink = (XSSFHyperlink) helper.createHyperlink(Hyperlink.Type.URL);
//        hyperlink.setAddress(url);
        XSSFRow row = getRowAnyway(sheet, nRow);
        XSSFCell cell = getCellAnyway(row, nColumn);
        cell.setCellValue(value);
//        cell.setHyperlink(hyperlink);
        // ハイパーリンクテキストの装飾
        XSSFFont font = workbook.createFont();
        XSSFCellStyle style = workbook.createCellStyle();
        // font.setColor(new XSSFColor(new Color(0, 0, 255)));
        font.setUnderline(XSSFFont.U_SINGLE);
        style.setFont(font);
        cell.setCellStyle(style);
    }

    /**
     * 指定セルの削除
     *
     * @param sheet
     *            シート
     * @param startRow
     *            開始行番号
     * @param endRow
     *            終了行番号
     * @param startColumn
     *            開始列番号
     * @param endColumn
     *            終了列番号
     */
    public static void removeCell(XSSFSheet sheet, int startRow, int endRow,
                                  int startColumn, int endColumn) {
        assert sheet != null;
        for (int nRow = startRow; nRow <= endRow; nRow++) {
            XSSFRow row = sheet.getRow(nRow);
            if (row != null) {
                for (int nColumn = startColumn; nColumn <= endColumn; nColumn++) {
                    XSSFCell cell = row.getCell(nColumn);
                    if (cell != null) {
                        row.removeCell(cell);
                    }
                }
            }
        }
    }

    /**
     * 指定シートの削除
     *
     * @param workbook
     *            ワークブック
     * @param sheetName
     *            削除対象のシート名
     */
    public static void removeSheet(XSSFWorkbook workbook, String sheetName) {
        assert workbook != null && StringUtil.isNotEmpty(sheetName);
        int removeId = workbook.getSheetIndex(sheetName);
        workbook.removeSheetAt(removeId);
    }

    /**
     * シートのクローンを行う
     *
     * @param workbook
     *            ワークブック
     * @param insertSheetId
     *            シートの挿入先番号
     * @param from
     *            コピー元のシート名
     * @param to
     *            追加するシート名
     * @return 追加するシート
     */
    public static XSSFSheet cloneSheet(XSSFWorkbook workbook,
                                       int insertSheetId, String from, String to) {
        assert workbook != null && StringUtil.isNotEmpty(from)
                && StringUtil.isNotEmpty(to);
        int sheetId = workbook.getSheetIndex(from);
        XSSFSheet clone = workbook.cloneSheet(sheetId);
        String cloneName = clone.getSheetName();
        workbook.setSheetOrder(cloneName, insertSheetId);
        workbook.setSheetName(insertSheetId, to);
        int newSheetId = workbook.getSheetIndex(to);
        return workbook.getSheetAt(newSheetId);
    }

    /**
     * 指定したシート名のシートを取得
     *
     * @param workbook
     *            ワークブック
     * @param name
     *            シート名
     * @return シート
     */
    public static XSSFSheet getSheet(XSSFWorkbook workbook, String name) {
        assert workbook != null && StringUtil.isNotEmpty(name);
        int nSheetIndex = workbook.getSheetIndex(name);
        return workbook.getSheetAt(nSheetIndex);
    }

    /**
     * 指定行の有効列数を取得する
     *
     * @param row
     *            行データ
     * @return 有効列数
     */
    public static int getColumnCount(XSSFRow row) {
        if (row != null) {
            for (int nColumn = 0;; nColumn++) {
                XSSFCell cell = row.getCell(nColumn);
                if (cell == null) {
                    return nColumn;
                }
            }
        }
        return 0;
    }
    /**
     * 上線は太線のセル行を探す
     *
     * @param nRow
     *            行データ
     * @return 有効列数
     */
    public static int getRowForBold(XSSFSheet sheet,int nRow,int pageRowNum) {
        int nRowIndex=nRow;
        for(nRowIndex=nRow;nRowIndex>(nRow-pageRowNum);nRow--){
            XSSFRow row = OoxmlUtil.getRowAnyway(sheet, nRow);
            if (row != null) {
                XSSFCell cell = row.getCell(0);
                XSSFCellStyle styletmp = cell.getCellStyle();
                if (styletmp.getBorderTop()==(BorderStyle.MEDIUM)) {
                    break;
                }
            }
        }
        return nRowIndex;
    }
    /**
     * 上線は太線のセル行を探す
     *
     * @param nRow
     *            行データ
     * @return 有効列数
     */
    public static int getRowForThin(XSSFSheet sheet,int nRow,int pageRowNum) {
        int nRowIndex=nRow;
        for(nRowIndex=nRow;nRowIndex>(nRow-pageRowNum);nRow--){
            XSSFRow row = OoxmlUtil.getRowAnyway(sheet, nRow);
            if (row != null) {
                XSSFCell cell = row.getCell(4);
                XSSFCellStyle styletmp = cell.getCellStyle();
                if (styletmp.getBorderBottom()==(BorderStyle.THIN)) {
                    break;
                }
            }
        }
        return nRow;
    }
    /**
     * セルの縮小して全体を表示する
     *
     * @param nRow
     *            行データ
     * @return 有効列数
     */
    public static void setShrinkToFitForCell(XSSFWorkbook wb,XSSFSheet sheet,int nRow,int nCol) {

        XSSFRow row = OoxmlUtil.getRowAnyway(sheet, nRow);
        XSSFCell cell= OoxmlUtil.getCellAnyway(row, nCol);
        CellStyle styletmp = cell.getCellStyle();
        CellStyle newStyletmp=wb.createCellStyle();
        newStyletmp.cloneStyleFrom(styletmp);
        newStyletmp.setWrapText(false);//折り返して全体を表示する
        newStyletmp.setShrinkToFit(true);//縮小して全体を表示する
        cell.setCellStyle(newStyletmp);
    }

    //公式を更新する
    public static void updateFormula(XSSFWorkbook workbook,XSSFSheet sheet,int nRow,int nCol){
        XSSFRow row = OoxmlUtil.getRowAnyway(sheet, nRow);
        XSSFCell cell= OoxmlUtil.getCellAnyway(row, nCol);
        XSSFFormulaEvaluator eval=new XSSFFormulaEvaluator(workbook);
       eval.evaluateFormulaCell(cell);
    }
    /**
     * セルに計算式を記入する
     *
     * @param nRow
     *            行
     * @param nColumn
     *            列番号
     * @param rules
     *            計算式
     * @param style
     *            セルスタイル
     */
    public static void setDataFormat(XSSFSheet sheet, int nRow, int nColumn,
                               String rules, XSSFCellStyle style) {
        assert sheet != null && rules != null;
        XSSFRow row = getRowAnyway(sheet, nRow);
        XSSFCell cell = getCellAnyway(row, nColumn);
        cell.setCellFormula(rules);
    }

    /**
     * 指定した範囲のセルをコピーする。
     *
     * @param copyRow0
     *            開始行
     * @param copyColumn0
     *            開始列
     * @param copyRow1
     *            終了行
     * @param copyColumn1
     *            終了列
     * @param startRow
     *            貼り付け行
     * @param startColumn
     *            貼り付け列
     */
    public static void copyCellArea(XSSFWorkbook workbook,XSSFSheet sheet, final int copyRow0, final int copyColumn0, final int copyRow1,
                             final int copyColumn1, final int startRow, final int startColumn) {

        for (int i = 0; copyRow0 + i <= copyRow1; i++) {
            XSSFRow row = getRowAnyway(sheet, startRow + i);
            row.setHeightInPoints(25);
            for (int j = 0; copyColumn0 + j <= copyColumn1; j++) {
                XSSFCell srcCell =  getCellAnyway(getRowAnyway(sheet, copyRow0 + i), copyColumn0 + j);
                XSSFCell destCell = getCellAnyway(getRowAnyway(sheet, startRow + i), startColumn + j);
                // スタイルを取得
                destCell.setCellStyle(cloneCellStyle(workbook,srcCell.getCellStyle()));
                destCell.setCellType(srcCell.getCellType());

                // 値の設定
                switch (srcCell.getCellType()) {
                    case BOOLEAN:
                        destCell.setCellValue(srcCell.getBooleanCellValue());
                        break;
                    case ERROR:
                        destCell.setCellValue(srcCell.getErrorCellValue());
                        break;
                    case FORMULA:
                        destCell.setCellFormula(srcCell.getCellFormula());
                        break;
                    case NUMERIC:
                        destCell.setCellValue(srcCell.getNumericCellValue());
                        break;
                    case STRING:
                        destCell.setCellValue(srcCell.getStringCellValue());
                        break;
                    default:
                }

                // 結合の設定
//                for (int k = 0; k < sheet.getNumMergedRegions(); k++) {
//                    CellRangeAddress merged = sheet.getMergedRegion(k);
//                    if (merged.isInRange(copyRow0 + i, copyColumn0 + j)) {
//                        int moveRows = startRow - copyRow0;
//                        int moveCols = startColumn - copyColumn0;
//                        CellRangeAddress newMaerged = new CellRangeAddress(moveRows+ merged.getFirstRow(), moveRows +merged.getLastRow(), moveCols
//                                + merged.getFirstColumn(), moveCols + merged.getLastColumn());
//                        sheet.addMergedRegion(newMaerged);
//                        break;
//                    }
//                }
                // 幅サイズ調節
                if (i == 0) {
                    sheet.setColumnWidth(startColumn + j, sheet.getColumnWidth(copyColumn0 + j));
                }

            }

        }

    }

    /**
     * セルの書式設定を複製します。
     *
     * @param originalStyle
     *            複製元となるPOIのセルスタイルオブジェクト
     * @return 複製されたPOIのセルスタイルオブジェクト
     */
    private static  CellStyle cloneCellStyle(XSSFWorkbook wb,final CellStyle originalStyle) {
        CellStyle newStyle = wb.createCellStyle();
        newStyle.cloneStyleFrom(originalStyle);
        return newStyle;
    }

}
