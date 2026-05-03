<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Dashboard EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --transition: all 0.2s ease-in-out;
            --shadow-md: 0 0.5rem 1rem rgba(0,0,0,0.08);
            --shadow-lg: 0 1rem 2rem rgba(0,0,0,0.12);
            --card-bg: #ffffff;
            --text-main: #1e293b;
        }
        .stat-card-custom {
            border: none;
            border-radius: 1rem;
            transition: var(--transition);
            overflow: hidden;
            position: relative;
            color: white;
        }
        .stat-card-custom:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }
        .stat-card-custom::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 60%);
            transform: rotate(30deg);
            pointer-events: none;
        }
        .bg-gradient-primary { background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%); }
        .bg-gradient-success { background: linear-gradient(135deg, #20c997 0%, #198754 100%); }
        .stat-icon {
            font-size: 2.5rem;
            opacity: 0.2;
            position: absolute;
            right: 20px;
            bottom: 20px;
            transform: rotate(-10deg);
            transition: var(--transition);
        }
        .stat-card-custom:hover .stat-icon {
            transform: rotate(0deg) scale(1.1);
            opacity: 0.3;
        }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container-fluid py-3">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold" style="color: var(--text-main);">Tableau de bord</h2>
            <c:if test="${pageContext.request.isUserInRole('ROLE_ADMINISTRATEUR')}">
                <button type="button" class="btn btn-danger rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#importModal">
                    <i class="fas fa-upload me-2"></i> Importer CSV
                </button>
            </c:if>
        </div>

        <!-- Cartes synthétiques -->
        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <div class="card stat-card-custom bg-gradient-primary p-3">
                    <i class="fas fa-users stat-icon"></i>
                    <div class="card-body p-0">
                        <h6 class="text-uppercase fw-bold opacity-75 mb-1">Total Doctorants</h6>
                        <h2 class="display-5 fw-bold mb-2" id="totalDoc">...</h2>
                        <a href="/doctorants" class="btn btn-light rounded-pill px-3 py-1 btn-sm fw-bold" style="color: #0a58ca;">Voir l'annuaire <i class="fas fa-arrow-right ms-1"></i></a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card stat-card-custom bg-gradient-success p-3">
                    <i class="fas fa-book-open stat-icon"></i>
                    <div class="card-body p-0">
                        <h6 class="text-uppercase fw-bold opacity-75 mb-1">Total Thèses</h6>
                        <h2 class="display-5 fw-bold mb-2" id="totalTheses">...</h2>
                        <a href="/theses" class="btn btn-light rounded-pill px-3 py-1 btn-sm fw-bold text-success">Consulter les thèses <i class="fas fa-arrow-right ms-1"></i></a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bouton vers la page des statistiques détaillées -->
        <div class="text-center mb-5">
            <a href="/statistiques" class="btn btn-outline-primary rounded-pill px-5 py-2 shadow-sm">
                <i class="fas fa-chart-line me-2"></i> Détails des statistiques
            </a>
        </div>
    </div>

    <!-- Modal import CSV (inchangé) -->
    <div class="modal fade" id="importModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
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
                        <button type="submit" class="btn btn-danger w-100 rounded-pill">Lancer l'import</button>
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
    // Chargement des totaux (Doctorants / Thèses)
    fetch('/api/statistiques/globales')
        .then(res => res.json())
        .then(data => {
            document.getElementById('totalDoc').innerText = data.totalDoctorants;
            document.getElementById('totalTheses').innerText = data.totalTheses;
        })
        .catch(err => console.error('Erreur chargement totaux:', err));

    // Gestion de l’import CSV (identique)
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