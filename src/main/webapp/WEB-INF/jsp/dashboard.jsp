<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Dashboard EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="fragments/styles.jsp" />
    <style>
        .stat-card { border: none; border-radius: 1rem; transition: 0.2s; background: linear-gradient(135deg, #0d6efd, #0b5ed7); color: white; }
        .stat-card:hover { transform: translateY(-4px); box-shadow: 0 8px 20px rgba(0,0,0,0.08); }
        .stat-card.success { background: linear-gradient(135deg, #198754, #146c43); }
        .stat-icon { font-size: 2rem; opacity: 0.2; position: absolute; right: 20px; bottom: 20px; }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container-fluid py-3">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold">Tableau de bord</h2>
            <c:if test="${pageContext.request.isUserInRole('ROLE_ADMINISTRATEUR')}">
                <button type="button" class="btn btn-primary rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#importModal">
                    <i class="fas fa-upload me-2"></i> Importer CSV
                </button>
            </c:if>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <div class="card stat-card p-3 position-relative">
                    <i class="fas fa-users stat-icon"></i>
                    <div class="card-body p-0">
                        <h6 class="text-uppercase fw-bold opacity-75 mb-1">Total Doctorants</h6>
                        <h2 class="display-5 fw-bold mb-2" id="totalDoc">...</h2>
                        <a href="/doctorants" class="btn btn-light rounded-pill px-3 py-1 btn-sm fw-bold" style="color: #0b5ed7;">Voir l'annuaire <i class="fas fa-arrow-right ms-1"></i></a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card stat-card success p-3 position-relative">
                    <i class="fas fa-book-open stat-icon"></i>
                    <div class="card-body p-0">
                        <h6 class="text-uppercase fw-bold opacity-75 mb-1">Total Thèses</h6>
                        <h2 class="display-5 fw-bold mb-2" id="totalTheses">...</h2>
                        <a href="/theses" class="btn btn-light rounded-pill px-3 py-1 btn-sm fw-bold" style="color: #146c43;">Consulter les thèses <i class="fas fa-arrow-right ms-1"></i></a>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mb-5">
            <a href="/statistiques" class="btn btn-outline-primary rounded-pill px-5 py-2">Détails des statistiques</a>
        </div>
    </div>

    <!-- Modal import CSV -->
    <div class="modal fade" id="importModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="fas fa-file-csv"></i> Importer des doctorants</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="csvUploadForm" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="csvFile" class="form-label">Fichier CSV (UTF-8, séparateur tabulation)</label>
                            <input type="file" class="form-control" id="csvFile" name="file" accept=".csv,.txt" required>
                            <div class="form-text small">Colonnes : id, last_name, first_name, email, telephone, faculte, laboratoire, doctorale, these, startup, secteur, impact, problematique, solution, date_start, date_end, maturation, interet, competences, domaine_recherche, motscles, publication, publication_faire, souhait, cv.</div>
                        </div>
                        <div id="importProgress" class="progress d-none mb-3">
                            <div class="progress-bar progress-bar-striped progress-bar-animated" style="width:100%">Import en cours...</div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 rounded-pill">Lancer l'import</button>
                    </form>
                    <div id="importResult" class="mt-3"></div>
                </div>
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
        })
        .catch(err => console.error('Erreur chargement totaux:', err));

    const form = document.getElementById('csvUploadForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            const file = document.getElementById('csvFile').files[0];
            if (!file) {
                document.getElementById('importResult').innerHTML = '<div class="alert alert-warning">Veuillez sélectionner un fichier.</div>';
                return;
            }
            const formData = new FormData();
            formData.append('file', file);
            const progressDiv = document.getElementById('importProgress');
            progressDiv.classList.remove('d-none');
            fetch('/admin/import-csv', { method: 'POST', body: formData })
                .then(r => r.json())
                .then(data => {
                    progressDiv.classList.add('d-none');
                    const msg = data.message || data.error;
                    const type = data.message ? 'success' : 'danger';
                    document.getElementById('importResult').innerHTML = `<div class="alert alert-${type} alert-dismissible fade show">${msg}<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>`;
                    if (data.message) setTimeout(() => location.reload(), 2000);
                })
                .catch(err => {
                    progressDiv.classList.add('d-none');
                    document.getElementById('importResult').innerHTML = '<div class="alert alert-danger">Erreur réseau : ' + err.message + '</div>';
                });
        });
    }
</script>
</body>
</html>