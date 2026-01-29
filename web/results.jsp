<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Voting Results</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Shared Sidebar and Layout Styles */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; background: #f4f4f4; min-height: 100vh; }
        .sidebar { width: 220px; background: #fff; border-right: 2px solid #ddd; position: fixed; height: 100vh; display: flex; flex-direction: column; padding: 20px 0; }
        .nav-link { text-decoration: none; color: #555; padding: 15px 25px; display: flex; align-items: center; gap: 12px; font-weight: 500; }
        .nav-link.active { color: #2b65ec; background: #f0f7ff; border-left: 4px solid #2b65ec; font-weight: bold; }
        .main-content { margin-left: 220px; flex: 1; padding: 40px; }

        /* Results Card and Table Styles */
        .results-card { background: white; padding: 30px; border-radius: 15px; border: 2px solid black; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .results-table { width: 100%; border-collapse: collapse; border: 2px solid #000; margin-top: 20px; }
        .results-table th, .results-table td { border: 2px solid #000; padding: 15px; text-align: center; }
        
        /* Specific Header Colors from Mockup */
        .th-blue-1 { background: #a3c1f3; } 
        .th-blue-2 { background: #72a2ed; }
        .th-winners { background: #6d96e0; font-weight: bold; font-size: 1.1rem; }
        .th-gray { background: #c4c4c4; font-size: 10px; font-weight: bold; }
        
        .filter-btn { background: #4facfe; color: white; border: none; padding: 10px 25px; border-radius: 12px; float: right; cursor: pointer; font-weight: bold; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div style="padding: 0 25px 40px;"><i class="fas fa-vote-yea fa-3x"></i></div>
        <a href="dashboard" class="nav-link"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="#" class="nav-link"><i class="fas fa-file-alt"></i> Vote</a>
        <a href="results" class="nav-link active"><i class="fas fa-poll"></i> Voting Results</a>
    </aside>

    <main class="main-content">
        <h1 style="margin-bottom: 20px;">Voting Results</h1>
        <div class="results-card">
            <button class="filter-btn">Filter Results</button>
            <h2 style="font-family: 'Georgia', serif; margin-bottom: 20px;">Final Results</h2>
            <table class="results-table">
                <thead>
                    <tr>
                        <th rowspan="2" class="th-blue-1">Election Name<br><small>(Status: Completed)</small></th>
                        <th rowspan="2" class="th-blue-2">Voting Period</th>
                        <th colspan="4" class="th-winners">Winners <i class="fas fa-medal" style="color:gold;"></i></th>
                    </tr>
                    <tr>
                        <th class="th-gray">PRESIDENT</th>
                        <th class="th-gray">VICE PRESIDENT</th>
                        <th class="th-gray">SECRETARY</th>
                        <th class="th-gray">TREASURER</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="res" items="${resultsList}">
                        <tr>
                            <td>${res.election_Title}</td>
                            <td>${res.votingPeriod}</td>
                            <td>${res.president}</td>
                            <td>${res.vicePresident}</td>
                            <td>${res.secretary}</td>
                            <td>${res.treasurer}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>