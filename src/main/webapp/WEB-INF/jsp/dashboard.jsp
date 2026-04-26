<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Dashboard EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <span class="navbar-brand">Cartographie EDMI</span>
        <a href="/logout" class="btn btn-outline-light btn-sm">Déconnexion</a>
    </div>
</nav>

<div class="container">
    <h2 class="mb-4">Tableau de Bord des Doctorants</h2>

    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card bg-primary text-white p-3">
                <h5>Total Doctorants</h5>
                <h2 id="totalDoc">...</h2>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card bg-success text-white p-3">
                <h5>Thèses Soutenues / En cours</h5>
                <h2 id="totalTheses">...</h2>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6 mb-4">
            <div class="card p-3 shadow-sm">
                <h5 class="text-center">Répartition par Faculté</h5>
                <canvas id="chartFacultes"></canvas>
            </div>
        </div>
        <div class="col-md-6 mb-4">
            <div class="card p-3 shadow-sm">
                <h5 class="text-center">Répartition par Laboratoire</h5>
                <canvas id="chartLabos"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
    // Appel à ton API StatistiquesController
    fetch('/api/statistiques/globales')
        .then(res => res.json())
        .then(data => {
            // Remplissage des chiffres
            document.getElementById('totalDoc').innerText = data.totalDoctorants;
            document.getElementById('totalTheses').innerText = data.totalTheses;

            // Camembert Facultés
            new Chart(document.getElementById('chartFacultes'), {
                type: 'pie',
                data: {
                    labels: Object.keys(data.statsFacultes),
                    datasets: [{
                        data: Object.values(data.statsFacultes),
                        backgroundColor: ['#198754', '#0d6efd', '#ffc107', '#6610f2']
                    }]
                }
            });

            // Camembert Labos
            new Chart(document.getElementById('chartLabos'), {
                type: 'bar',
                data: {
                    labels: Object.keys(data.statsLabos),
                    datasets: [{
                        label: 'Nombre de Doctorants',
                        data: Object.values(data.statsLabos),
                        backgroundColor: '#6f42c1'
                    }]
                }
            });
        });
</script>

</body>
</html>