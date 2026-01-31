package com.mvc.bean;

public class CandidateBean {
    private int candId;
    private String manifesto;
    private String photoPath;
    private int studId;
    private int positionId;
    
    // Joined fields from Student and Position tables for display convenience
    private String studName;
    private String studProgram;
    private int studYear;
    private String positionName;

    // Getters and Setters
    public int getCandId() { return candId; }
    public void setCandId(int candId) { this.candId = candId; }

    public String getManifesto() { return manifesto; }
    public void setManifesto(String manifesto) { this.manifesto = manifesto; }

    public String getPhotoPath() { return photoPath; }
    public void setPhotoPath(String photoPath) { this.photoPath = photoPath; }

    public int getStudId() { return studId; }
    public void setStudId(int studId) { this.studId = studId; }

    public int getPositionId() { return positionId; }
    public void setPositionId(int positionId) { this.positionId = positionId; }

    public String getStudName() { return studName; }
    public void setStudName(String studName) { this.studName = studName; }

    public String getStudProgram() { return studProgram; }
    public void setStudProgram(String studProgram) { this.studProgram = studProgram; }

    public int getStudYear() { return studYear; }
    public void setStudYear(int studYear) { this.studYear = studYear; }

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }
}
