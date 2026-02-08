package com.mvc.bean;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * @author Antigravity
 */
public class ElectionBean implements Serializable {

    private int electionId;
    private String electionTitle;
    private String electionDesc;
    private Timestamp electionStartDate;
    private Timestamp electionEndDate;
    private String electionStatus;
    private int adminId;

    // Field for the filename (e.g., test.jpg)
    private String electionImage;

    public ElectionBean() {
    }

    // Getters and Setters
    public int getElectionId() {
        return electionId;
    }

    public void setElectionId(int electionId) {
        this.electionId = electionId;
    }

    public String getElectionTitle() {
        return electionTitle;
    }

    public void setElectionTitle(String electionTitle) {
        this.electionTitle = electionTitle;
    }

    public String getElectionDesc() {
        return electionDesc;
    }

    public void setElectionDesc(String electionDesc) {
        this.electionDesc = electionDesc;
    }

    public Timestamp getElectionStartDate() {
        return electionStartDate;
    }

    public void setElectionStartDate(Timestamp electionStartDate) {
        this.electionStartDate = electionStartDate;
    }

    public Timestamp getElectionEndDate() {
        return electionEndDate;
    }

    public void setElectionEndDate(Timestamp electionEndDate) {
        this.electionEndDate = electionEndDate;
    }

    public String getElectionStatus() {
        return electionStatus;
    }

    public void setElectionStatus(String electionStatus) {
        this.electionStatus = electionStatus;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getElectionImage() {
        return electionImage;
    }

    public void setElectionImage(String electionImage) {
        this.electionImage = electionImage;
    }
}
