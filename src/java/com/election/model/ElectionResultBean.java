package com.election.model;
import java.io.Serializable;

public class ElectionResultBean implements Serializable {
    private String election_Title, votingPeriod, president, vicePresident, secretary, treasurer;
    public ElectionResultBean() {}
    // Getters and Setters for all fields
    public String getElection_Title() { return election_Title; }
    public void setElection_Title(String t) { this.election_Title = t; }
    public String getVotingPeriod() { return votingPeriod; }
    public void setVotingPeriod(String v) { this.votingPeriod = v; }
    public String getPresident() { return president; }
    public void setPresident(String p) { this.president = p; }
    public String getVicePresident() { return vicePresident; }
    public void setVicePresident(String vp) { this.vicePresident = vp; }
    public String getSecretary() { return secretary; }
    public void setSecretary(String s) { this.secretary = s; }
    public String getTreasurer() { return treasurer; }
    public void setTreasurer(String t) { this.treasurer = t; }
}