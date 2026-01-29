package com.election.model;

public class DashboardStats {
    private int activeCount, endedCount, upcomingCount;
    public int getActiveCount() { return activeCount; }
    public void setActiveCount(int c) { this.activeCount = c; }
    public int getEndedCount() { return endedCount; }
    public void setEndedCount(int c) { this.endedCount = c; }
    public int getUpcomingCount() { return upcomingCount; }
    public void setUpcomingCount(int c) { this.upcomingCount = c; }
}