<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Dashboard EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card-stats { border: none; border-radius: 1rem; transition: transform 0.2s; }
        .card-stats:hover { transform: translateY(-5px); }
        .stat-icon { font-size: 2.5rem; opacity: 0.4; position: absolute; right: 20px; top: 20px; }
        .chart-card { border: none; border-radius: 1rem; box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.05); }
        body { background-color: #f8f9fc; }
    </style>
</head>
<body class="bg-light">

<jsp:include page="fragments/header.jsp" />

<div class="container py-3">
    <div class="row g-4 mb-5">
        <div class="col-md-6">
            <div class="card card-stats bg-primary text-white p-3 position-relative">
                <i class="fas fa-users stat-icon"></i>
                <div class="card-body">
                    <h5 class="card-title">Total Doctorants</h5>
                    <h2 class="display-4 fw-bold" id="totalDoc">...</h2>
                    <a href="/doctorants" class="btn btn-outline-light rounded-pill mt-2">Voir la liste <i class="fas fa-arrow-right ms-2"></i></a>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card card-stats bg-success text-white p-3 position-relative">
                <i class="fas fa-book-open stat-icon"></i>
                <div class="card-body">
                    <h5 class="card-title">Total Thèses</h5>
                    <h2 class="display-4 fw-bold" id="totalTheses">...</h2>
                    <a href="/theses" class="btn btn-outline-light rounded-pill mt-2">Voir la liste <i class="fas fa-arrow-right ms-2"></i></a>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${pageContext.request.isUserInRole('ROLE_ADMINISTRATEUR')}">
        <div class="row mb-4">
            <div class="col text-end">
                <button type="button" class="btn btn-danger rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#importModal">
                    <i class="fas fa-upload me-2"></i> Importer CSV
                </button>
            </div>
        </div>
    </c:if>

    <div class="row g-4">
        <div class="col-md-6">
            <div class="card chart-card p-3">
                <h5 class="text-center text-primary fw-bold"><i class="fas fa-chalkboard-user me-2"></i>Répartition par Faculté</h5>
                <canvas id="chartFacultes" height="250"></canvas>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card chart-card p-3">
                <h5 class="text-center text-primary fw-bold"><i class="fas fa-flask me-2"></i>Répartition par Laboratoire</h5>
                <canvas id="chartLabos" height="250"></canvas>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card chart-card p-3">
                <h5 class="text-center text-primary fw-bold"><i class="fas fa-chart-pie me-2"></i>Thèses par secteur</h5>
                <canvas id="chartSecteurs" height="250"></canvas>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card chart-card p-3">
                <h5 class="text-center text-primary fw-bold"><i class="fas fa-user-graduate me-2"></i>Thèses par doctorant</h5>
                <canvas id="chartThesesParDoctorant" height="250"></canvas>
            </div>
        </div>
    </div>
</div>

<!-- Modal import CSV -->
<div class="modal fade" id="importModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title"><i class="fas fa-file-csv me-2"></i> Importer des doctorants</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="csvUploadForm" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label for="csvFile" class="form-label">Fichier CSV (UTF-8, séparateur tabulation)</label>
                        <input type="file" class="form-control" id="csvFile" name="file" accept=".csv, .txt" required>
                        <div class="form-text small">Colonnes : id, last_name, first_name, email, telephone, faculte, laboratoire, doctorale, these, startup, secteur, impact, problematique, solution, date_start, date_end, maturation, interet, competences, domaine_recherche, motscles, publication, publication_faire, souhait, cv.</div>
                    </div>
                    <div id="importProgress" class="progress d-none mb-3"><div class="progress-bar progress-bar-striped progress-bar-animated" style="width:100%">Import en cours...</div></div>
                    <button type="submit" class="btn btn-danger w-100 rounded-pill">Lancer l'import</button>
                </form>
                <div id="importResult" class="mt-3"></div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    fetch('/api/statistiques/globales')
        .then(res => res.json())
        .then(data => {
            document.getElementById('totalDoc').innerText = data.totalDoctorants;
            document.getElementById('totalTheses').innerText = data.totalTheses;

            new Chart(document.getElementById('chartFacultes'), {
                type: 'pie',
                data: { labels: Object.keys(data.statsFacultes), datasets: [{ data: Object.values(data.statsFacultes), backgroundColor: ['#0d6efd','#198754','#ffc107','#dc3545','#6f42c1'] }] }
            });
            const labos = data.statsLaboratoires || {};
            new Chart(document.getElementById('chartLabos'), {
                type: 'bar',
                data: { labels: Object.keys(labos), datasets: [{ label: 'Doctorants', data: Object.values(labos), backgroundColor: '#0d6efd', borderRadius: 8 }] }
            });
            new Chart(document.getElementById('chartSecteurs'), {
                type: 'pie',
                data: { labels: Object.keys(data.statsSecteurs), datasets: [{ data: Object.values(data.statsSecteurs), backgroundColor: ['#20c997','#fd7e14','#0d6efd'] }] }
            });
            new Chart(document.getElementById('chartThesesParDoctorant'), {
                type: 'bar',
                data: { labels: Object.keys(data.thesesParDoctorant), datasets: [{ label: 'Thèses', data: Object.values(data.thesesParDoctorant), backgroundColor: '#fd7e14', borderRadius: 8 }] }
            });
        });

    document.getElementById('csvUploadForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        const file = document.getElementById('csvFile').files[0];
        if (!file) { showToast('Veuillez sélectionner un fichier', 'warning'); return; }
        const formData = new FormData(); formData.append('file', file);
        document.getElementById('importProgress').classList.remove('d-none');
        fetch('/admin/import-csv', { method: 'POST', body: formData })
            .then(r => r.json())
            .then(data => {
                document.getElementById('importProgress').classList.add('d-none');
                const msg = data.message || data.error;
                const type = data.message ? 'success' : 'danger';
                document.getElementById('importResult').innerHTML = `<div class="alert alert-${type} alert-dismissible fade show">${msg}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>`;
                if (data.message) setTimeout(() => location.reload(), 2000);
            })
            .catch(err => { document.getElementById('importProgress').classList.add('d-none'); document.getElementById('importResult').innerHTML = '<div class="alert alert-danger">Erreur réseau</div>'; });
    });
</script>
</body>
</html>