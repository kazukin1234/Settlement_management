package bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 出張申請のStep2（宿泊・手当などの詳細）で使用される明細情報を保持するBeanクラス。
 * 地域区分、出張区分、宿泊情報、負担区分、金額、メモ、添付ファイルなどを管理します。
 */
public class Step2Detail implements Serializable {
    private static final long serialVersionUID = 1L;

    private String regionType;
    private String tripType;
    private String hotel;
    private String burden;
    private int hotelFee;
    private int dailyAllowance;
    private int days;
    private int expenseTotal;
    private String memo;
    private List<UploadedFile> temporaryFiles = new ArrayList<>();
    private List<String> adjustmentOptions = new ArrayList<>();
    // --- Getters and Setters ---

    /**
     * 地域区分を取得します。
     * @return 地域区分
     */
    public String getRegionType() {
        return regionType;
    }

    /**
     * 地域区分を設定します。
     * @param regionType 地域区分
     */
    public void setRegionType(String regionType) {
        this.regionType = regionType;
    }

    /**
     * 出張区分を取得します。
     * @return 出張区分
     */
    public String getTripType() {
        return tripType;
    }

    /**
     * 出張区分を設定します。
     * @param tripType 出張区分
     */
    public void setTripType(String tripType) {
        this.tripType = tripType;
    }

    /**
     * 宿泊施設の情報を取得します。
     * @return 宿泊施設名
     */
    public String getHotel() {
        return hotel;
    }

    /**
     * 宿泊施設の情報を設定します。
     * @param hotel 宿泊施設名
     */
    public void setHotel(String hotel) {
        this.hotel = hotel;
    }

    /**
     * 費用負担区分を取得します。
     * @return 負担区分
     */
    public String getBurden() {
        return burden;
    }

    /**
     * 費用負担区分を設定します。
     * @param burden 負担区分
     */
    public void setBurden(String burden) {
        this.burden = burden;
    }

    /**
     * 宿泊費を取得します。
     * @return 宿泊費（円）
     */
    public int getHotelFee() {
        return hotelFee;
    }

    /**
     * 宿泊費を設定します。
     * @param hotelFee 宿泊費（円）
     */
    public void setHotelFee(int hotelFee) {
        this.hotelFee = hotelFee;
    }

    /**
     * 日当を取得します。
     * @return 日当（円）
     */
    public int getDailyAllowance() {
        return dailyAllowance;
    }

    /**
     * 日当を設定します。
     * @param dailyAllowance 日当（円）
     */
    public void setDailyAllowance(int dailyAllowance) {
        this.dailyAllowance = dailyAllowance;
    }

    /**
     * 出張日数を取得します。
     * @return 日数
     */
    public int getDays() {
        return days;
    }

    /**
     * 出張日数を設定します。
     * @param days 日数
     */
    public void setDays(int days) {
        this.days = days;
    }

    /**
     * 合計金額（宿泊費＋日当）を取得します。
     * @return 合計金額（円）
     */
    public int getExpenseTotal() {
        return expenseTotal;
    }

    /**
     * 合計金額（宿泊費＋日当）を設定します。
     * @param expenseTotal 合計金額（円）
     */
    public void setExpenseTotal(int expenseTotal) {
        this.expenseTotal = expenseTotal;
    }

    /**
     * 備考を取得します。
     * @return メモ
     */
    public String getMemo() {
        return memo;
    }

    /**
     * メモを設定します。
     * @param memo メモ
     */
    public void setMemo(String memo) {
        this.memo = memo;
    }

    /**
     * 一時添付ファイルのリストを取得します。
     * @return 添付ファイルリスト
     */
    public List<UploadedFile> getTemporaryFiles() {
        return temporaryFiles;
    }

    /**
     * 一時添付ファイルのリストを設定します。
     * @param temporaryFiles 添付ファイルリスト
     */
    public void setTemporaryFiles(List<UploadedFile> temporaryFiles) {
        this.temporaryFiles = temporaryFiles;
    }
    
    
    
    
    
    
    
    public List<String> getAdjustmentOptions() {
        return adjustmentOptions;
    }

    public void setAdjustmentOptions(List<String> adjustmentOptions) {
        this.adjustmentOptions = adjustmentOptions;
    }
}
