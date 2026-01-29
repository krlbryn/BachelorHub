/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mvc.bean;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 *
 * @author Antigravity
 */
public class ElectionBean implements Serializable {
    private int electionId;
    private String electionTitle;
    private String electionDesc;
    private Timestamp electionStartDate;
    private Timestamp electionEndDate;
    private String electionStatus;
    private int studId;
    private int adminId;

    public ElectionBean() {
    }

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

    public int getStudId() {
        return studId;
    }

    public void setStudId(int studId) {
        this.studId = studId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
}
