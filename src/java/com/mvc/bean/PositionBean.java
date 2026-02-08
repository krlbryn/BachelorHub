package com.mvc.bean;

public class PositionBean {
    private int positionId;
    private String positionName;
    private String positionDesc;
    private int electionId;

    public int getPositionId() { return positionId; }
    public void setPositionId(int positionId) { this.positionId = positionId; }

    public String getPositionName() { return positionName; }
    public void setPositionName(String positionName) { this.positionName = positionName; }

    public String getPositionDesc() { return positionDesc; }
    public void setPositionDesc(String positionDesc) { this.positionDesc = positionDesc; }

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }
}
