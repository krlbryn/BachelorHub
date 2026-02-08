package com.mvc.bean;

import java.io.Serializable;

public class CandidateBean implements Serializable {

    private int candId;
    private String studName; // This likely comes from a JOIN with the student table
    private String positionName;
    private String manifesto;
    private String photoPath; // Maps to cand_PhotoPath
    private int electionId;

    public CandidateBean() {
    }

    // Getters and Setters
    public int getCandId() {
        return candId;
    }

    public void setCandId(int candId) {
        this.candId = candId;
    }

    public String getStudName() {
        return studName;
    }

    public void setStudName(String studName) {
        this.studName = studName;
    }

    public String getPositionName() {
        return positionName;
    }

    public void setPositionName(String positionName) {
        this.positionName = positionName;
    }

    public String getManifesto() {
        return manifesto;
    }

    public void setManifesto(String manifesto) {
        this.manifesto = manifesto;
    }

    public String getPhotoPath() {
        return photoPath;
    }

    public void setPhotoPath(String photoPath) {
        this.photoPath = photoPath;
    }

    public int getElectionId() {
        return electionId;
    }

    public void setElectionId(int electionId) {
        this.electionId = electionId;
    }
}
