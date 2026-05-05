<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Statistiques - EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="fragments/styles.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --transition: all 0.2s ease-in-out;
            --shadow-md: 0 0.5rem 1rem rgba(0,0,0,0.08);
            --shadow-lg: 0 1rem 2rem rgba(0,0,0,0.12);
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --bg-light: #f8f9fc;
            --primary-gradient: linear-gradient(135deg, #0d6efd, #0a58ca);
        }
        body { background-color: #f8f9fc; }
        .chart-card {
            background: var(--card-bg);
            border: none;
            border-radius: 1.25rem;
            box-shadow: var(--shadow-md);
            padding: 1.5rem;
            transition: var(--transition);
            height: 100%;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
        }
        .chart-card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-4px);
        }
        .chart-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--primary-gradient);
            opacity: 0;
            transition: var(--transition);
        }
        .chart-card:hover::before { opacity: 1; }
        .chart-card h5 {
            color: var(--text-main);
            font-weight: 700;
            margin-bottom: 1.5rem;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
        }
        .chart-card h5 i {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background: var(--bg-light);
            margin-right: 12px;
            font-size: 1rem;
        }
        .chart-wrapper {
            overflow-x: auto;
            width: 100%;
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        canvas {
            width: 100%;
            height: auto;
            min-height: 280px;
        }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container-fluid py-4">
        <!-- En-tête -->
        <div class="d-flex justify-content-between align-items-center mb-5 bg-white p-4 rounded-4 shadow-sm">
            <div class="d-flex align-items-center">
                <div class="bg-primary-subtle text-primary rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px; font-size: 1.5rem;">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div>
                    <h2 class="fw-bold mb-0" style="color: var(--text-main);">Statistiques Détaillées</h2>
                    <p class="text-muted mb-0 small">Analyse approfondie des données de l'EDMI</p>
                </div>
            </div>
            <a href="/dashboard" class="btn btn-outline-secondary rounded-pill px-4 fw-bold shadow-sm">
                <i class="fas fa-arrow-left me-2"></i> Retour au Dashboard
            </a>
        </div>

        <div class="row g-4">
            <!-- 1. Facultés (camembert) -->
            <div class="col-md-6 col-xl-4">
                <div class="chart-card">
                    <h5><i class="fas fa-university text-primary"></i>Répartition par Faculté</h5>
                    <div class="chart-wrapper"><canvas id="chartFacultes"></canvas></div>
                </div>
            </div>

            <!-- 2. Laboratoires (barres horizontales, Top 20) -->
            <div class="col-md-6 col-xl-4">
                <div class="chart-card">
                    <h5><i class="fas fa-flask text-success"></i>Répartition par Laboratoire (Top 20)</h5>
                    <div class="chart-wrapper"><canvas id="chartLabos"></canvas></div>
                </div>
            </div>

            <!-- 3. Thèses par secteur (anneau) -->
            <div class="col-md-6 col-xl-4">
                <div class="chart-card">
                    <h5><i class="fas fa-chart-pie text-warning"></i>Thèses par Secteur</h5>
                    <div class="chart-wrapper"><canvas id="chartSecteurs"></canvas></div>
                </div>
            </div>

            <!-- 4. Thèses par doctorant (BARRES VERTICALES, Top 20) -->
            <div class="col-md-6 col-xl-4">
                <div class="chart-card">
                    <h5><i class="fas fa-user-graduate text-info"></i>Thèses par Doctorant (Top 20)</h5>
                    <div class="chart-wrapper"><canvas id="chartThesesParDoctorant"></canvas></div>
                </div>
            </div>

            <!-- 5. Compétences (barres horizontales, Top 20) -->
            <div class="col-md-6 col-xl-4">
                <div class="chart-card">
                    <h5><i class="fas fa-brain text-secondary"></i>Compétences (Top 20)</h5>
                    <div class="chart-wrapper"><canvas id="chartCompetences"></canvas></div>
                </div>
            </div>

            <!-- 6. Domaines de recherche (barres horizontales, Top 20) -->
            <div class="col-md-6 col-xl-4">
                <div class="chart-card">
                    <h5><i class="fas fa-search text-danger"></i>Domaines de Recherche (Top 20)</h5>
                    <div class="chart-wrapper"><canvas id="chartDomaines"></canvas></div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function() {
        // Palette de couleurs premium
        const colorPalette = [
            '#0d6efd', '#20c997', '#ffc107', '#fd7e14', '#6f42c1',
            '#dc3545', '#198754', '#0dcaf0', '#6610f2', '#e83e8c',
            '#343a40', '#adb5bd', '#055160', '#842029', '#0f5132'
        ];
        function getColors(count, offset = 0) {
            let cols = [];
            for (let i = 0; i < count; i++) {
                cols.push(colorPalette[(i + offset) % colorPalette.length]);
            }
            return cols;
        }

        // Limiter une Map à 20 éléments (top par valeur) et agréger le reste
        function getTop20WithOthers(entries) {
            // entries est un tableau de [key, value]
            entries.sort((a, b) => b[1] - a[1]); // tri décroissant par valeur
            let top = entries.slice(0, 20);
            let rest = entries.slice(20);
            let otherCount = rest.length;
            let otherSum = rest.reduce((sum, e) => sum + e[1], 0);
            let result = { labels: top.map(e => e[0]), values: top.map(e => e[1]) };
            if (otherCount > 0) {
                result.labels.push(`Autres (${otherCount} éléments)`);
                result.values.push(otherSum);
            }
            return result;
        }

        // Créer un graphique à barres HORIZONTALES (indexAxis = 'y')
        function createHorizontalBarChart(canvasId, labels, values, unitLabel, colorOffset = 0) {
            if (!labels || labels.length === 0) {
                const container = document.getElementById(canvasId)?.parentElement;
                if (container) container.innerHTML = '<div class="text-muted text-center py-5"><i class="fas fa-inbox fa-3x mb-3 opacity-25"></i><br/>Aucune donnée</div>';
                return;
            }
            const canvas = document.getElementById(canvasId);
            new Chart(canvas, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: unitLabel,
                        data: values,
                        backgroundColor: getColors(labels.length, colorOffset),
                        borderRadius: 6,
                        barPercentage: 0.8,
                        categoryPercentage: 0.9
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: 'rgba(255,255,255,0.9)',
                            titleColor: '#1e293b',
                            bodyColor: '#1e293b',
                            borderColor: '#e2e8f0',
                            borderWidth: 1,
                            padding: 12,
                            cornerRadius: 8,
                            callbacks: { label: (ctx) => ` ${ctx.raw} ${unitLabel}` }
                        }
                    },
                    scales: {
                        x: { grid: { display: false }, title: { display: true, text: unitLabel } },
                        y: { grid: { display: false }, ticks: { font: { size: 11 } } }
                    }
                }
            });
            canvas.style.height = Math.max(280, labels.length * 35) + 'px';
            canvas.style.width = '100%';
        }

        // Créer un graphique à barres VERTICALES (indexAxis = 'x')
        function createVerticalBarChart(canvasId, labels, values, unitLabel, colorOffset = 0) {
            if (!labels || labels.length === 0) {
                const container = document.getElementById(canvasId)?.parentElement;
                if (container) container.innerHTML = '<div class="text-muted text-center py-5"><i class="fas fa-inbox fa-3x mb-3 opacity-25"></i><br/>Aucune donnée</div>';
                return;
            }
            const canvas = document.getElementById(canvasId);
            new Chart(canvas, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: unitLabel,
                        data: values,
                        backgroundColor: getColors(labels.length, colorOffset),
                        borderRadius: 6,
                        barPercentage: 0.7,
                        categoryPercentage: 0.8
                    }]
                },
                options: {
                    indexAxis: 'x',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: 'rgba(255,255,255,0.9)',
                            titleColor: '#1e293b',
                            bodyColor: '#1e293b',
                            borderColor: '#e2e8f0',
                            borderWidth: 1,
                            padding: 12,
                            cornerRadius: 8,
                            callbacks: { label: (ctx) => ` ${ctx.raw} ${unitLabel}` }
                        }
                    },
                    scales: {
                        x: { ticks: { rotation: -45, autoSkip: true, maxRotation: 45, minRotation: 45, font: { size: 10 } } },
                        y: { grid: { display: true }, title: { display: true, text: unitLabel } }
                    }
                }
            });
            canvas.style.height = '350px';
            canvas.style.width = '100%';
        }

        Chart.defaults.font.family = 'Inter, sans-serif';
        Chart.defaults.color = '#64748b';

        // ---------- 1. Facultés (pie) ----------
        fetch('/api/statistiques/globales')
            .then(res => res.json())
            .then(data => {
                const facKeys = Object.keys(data.statsFacultes || {});
                const facValues = Object.values(data.statsFacultes || {});
                if (facKeys.length) {
                    new Chart(document.getElementById('chartFacultes'), {
                        type: 'pie',
                        data: { labels: facKeys, datasets: [{ data: facValues, backgroundColor: getColors(facKeys.length), borderWidth: 2, borderColor: '#fff', hoverOffset: 8 }] },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { position: 'bottom', labels: { padding: 20, usePointStyle: true } },
                                tooltip: { callbacks: { label: (ctx) => ` ${ctx.raw} doctorant(s)` } }
                            }
                        }
                    });
                } else {
                    document.getElementById('chartFacultes').parentElement.innerHTML = '<div class="text-muted text-center py-5">Aucune donnée</div>';
                }

                // ---------- 2. Laboratoires (Top 20, horizontales) ----------
                const labos = Object.entries(data.statsLaboratoires || {});
                const labosTop = getTop20WithOthers(labos);
                createHorizontalBarChart('chartLabos', labosTop.labels, labosTop.values, 'doctorant(s)', 2);

                // ---------- 3. Secteurs (doughnut) ----------
                const sectKeys = Object.keys(data.statsSecteurs || {});
                const sectValues = Object.values(data.statsSecteurs || {});
                if (sectKeys.length) {
                    new Chart(document.getElementById('chartSecteurs'), {
                        type: 'doughnut',
                        data: { labels: sectKeys, datasets: [{ data: sectValues, backgroundColor: getColors(sectKeys.length, 5).reverse(), borderWidth: 2, borderColor: '#fff', hoverOffset: 8, cutout: '65%' }] },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: { position: 'bottom', labels: { padding: 20, usePointStyle: true } },
                                tooltip: { callbacks: { label: (ctx) => ` ${ctx.raw} thèse(s)` } }
                            }
                        }
                    });
                } else {
                    document.getElementById('chartSecteurs').parentElement.innerHTML = '<div class="text-muted text-center py-5">Aucune donnée</div>';
                }

                // ---------- 4. Thèses par doctorant (Top 20, verticales) ----------
                const thesesEntries = Object.entries(data.thesesParDoctorant || {});
                const thesesTop = getTop20WithOthers(thesesEntries);
                createVerticalBarChart('chartThesesParDoctorant', thesesTop.labels, thesesTop.values, 'thèse(s)', 8);
            })
            .catch(err => console.error('Erreur stats globales:', err));

        // ---------- 5. Compétences (Top 20, horizontales) ----------
        fetch('/api/statistiques/competences')
            .then(res => res.json())
            .then(data => {
                const entries = Object.entries(data);
                const top = getTop20WithOthers(entries);
                createHorizontalBarChart('chartCompetences', top.labels, top.values, 'doctorant(s)', 4);
            })
            .catch(err => console.error('Erreur compétences:', err));

        // ---------- 6. Domaines de recherche (Top 20, horizontales) ----------
        fetch('/api/statistiques/domaines')
            .then(res => res.json())
            .then(data => {
                const entries = Object.entries(data);
                const top = getTop20WithOthers(entries);
                createHorizontalBarChart('chartDomaines', top.labels, top.values, 'doctorant(s)', 7);
            })
            .catch(err => console.error('Erreur domaines:', err));
    })();
</script>
</body>
</html>