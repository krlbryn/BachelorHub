package com.election.model;

public class Election {
    private int election_ID;
    private String election_Title, election_Status, startDate, endDate;

    public Election() {}
    public int getElection_ID() { return election_ID; }
    public void setElection_ID(int id) { this.election_ID = id; }
    public String getElection_Title() { return election_Title; }
    public void setElection_Title(String t) { this.election_Title = t; }
    public String getElection_Status() { return election_Status; }
    public void setElection_Status(String s) { this.election_Status = s; }
    public String getStartDate() { return startDate; }
    public void setStartDate(String d) { this.startDate = d; }
    public String getEndDate() { return endDate; }
    public void setEndDate(String d) { this.endDate = d; }
}