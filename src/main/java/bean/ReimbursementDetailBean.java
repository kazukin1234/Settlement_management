package bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 立替金申請の明細1件分を保持するBean。
 * 個別の項目（プロジェクトコード、金額、摘要など）と、
 * 一時的なファイル添付リストを含む。
 */
public class ReimbursementDetailBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private String projectCode;
    private String date;
    private String destinations;
    private String accountingItem;
    private int amount;
    private String abstractNote;
    private String report;
    private List<UploadedFile> temporaryFiles = new ArrayList<>();

    // Toàn bộ Getters và Setters ở đây...

    /**
     * プロジェクトコードを取得します。
     */
    public String getProjectCode() {
        return projectCode;
    }

    /**
     * プロジェクトコードを設定します。
     */
    public void setProjectCode(String projectCode) {
        this.projectCode = projectCode;
    }

    /**
     * 日付を取得します。
     */
    public String getDate() {
        return date;
    }

    /**
     * 日付を設定します。
     */
    public void setDate(String date) {
        this.date = date;
    }

    /**
     * 行き先を取得します。
     */
    public String getDestinations() {
        return destinations;
    }

    /**
     * 行き先を設定します。
     */
    public void setDestinations(String destinations) {
        this.destinations = destinations;
    }

    /**
     * 勘定科目を取得します。
     */
    public String getAccountingItem() {
        return accountingItem;
    }

    /**
     * 勘定科目を設定します。
     */
    public void setAccountingItem(String accountingItem) {
        this.accountingItem = accountingItem;
    }

    /**
     * 金額を取得します。
     */
    public int getAmount() {
        return amount;
    }

    /**
     * 金額を設定します。
     */
    public void setAmount(int amount) {
        this.amount = amount;
    }

    
    public String getAbstractNote() {
        return abstractNote;
    }
    public void setAbstractNote(String abstractNote) {
        this.abstractNote = abstractNote;
    }
    /**
     * 摘要（報告）を取得します。
     */
    /**
     * 摘要（報告）を設定します。
     */
    
    
    
    public String getReport() {
        return report;
    }

    public void setReport(String report) {
        this.report = report;
    }

    /**
     * 一時添付ファイルリストを取得します。
     */
    public List<UploadedFile> getTemporaryFiles() {
        return temporaryFiles;
    }

    /**
     * 一時添付ファイルリストを設定します。
     */
    public void setTemporaryFiles(List<UploadedFile> temporaryFiles) {
        this.temporaryFiles = temporaryFiles;
    }
}
