<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Annuaire des Thèses - EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .thesis-card { border-left: 5px solid #0d6efd; transition: 0.3s; }
        .thesis-card:hover { background-color: #f8f9fa; }
        .accordion-button:not(.collapsed) { background-color: #e7f1ff; color: #0d6efd; }
        .author-box { font-size: 0.9rem; color: #6c757d; margin-top: 5px; }
        .badge-secteur { font-weight: 500; letter-spacing: 0.5px; }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow">
    <div class="container-fluid">
        <a class="navbar-brand" href="/dashboard"><i class="fas fa-university me-2"></i>Cartographie EDMI</a>
        <div class="navbar-nav">
            <a class="nav-link" href="/doctorants">Doctorants</a>
            <a class="nav-link active" href="/theses">Thèses</a>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-book-open text-primary me-2"></i>Travaux de Recherche</h2>
        <a href="/these/nouveau" class="btn btn-success shadow-sm">
            <i class="fas fa-plus-circle me-1"></i> Nouvelle Thèse
        </a>
    </div>

    <div class="accordion shadow-sm" id="accordionTheses">
        <c:forEach items="${listeTheses}" var="t" varStatus="status">
            <div class="accordion-item mb-2 border-0 overflow-hidden rounded shadow-sm">
                <h2 class="accordion-header" id="heading${t.id}">
                    <button class="accordion-button collapsed thesis-card" type="button"
                            data-bs-toggle="collapse" data-bs-target="#collapse${t.id}">
                        <div class="w-100">
                            <div class="mb-2">
                                <span class="badge bg-primary badge-secteur me-2 text-uppercase">${t.secteur}</span>
                                <c:forEach items="${t.motsCles}" var="m">
                                    <span class="badge border text-secondary bg-white">#${m.mot}</span>
                                </c:forEach>
                            </div>

                            <div class="h5 mb-1 text-dark fw-bold">${t.intitule}</div>

                            <div class="author-box">
                                <i class="fas fa-user-graduate me-1"></i>
                                <strong>Doctorant :</strong>
                                <c:choose>
                                    <c:when test="${not empty t.doctorants}">
                                        <c:forEach items="${t.doctorants}" var="d" varStatus="loop">
                                            <span class="text-primary">${d.firstName} ${d.lastName}</span>
                                            <c:if test="${!loop.last}">, </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-danger">Auteur non identifié</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </button>
                </h2>

                <div id="collapse${t.id}" class="accordion-collapse collapse" data-bs-parent="#accordionTheses">
                    <div class="accordion-body bg-white pt-0">
                        <hr class="mt-0">
                        <div class="row g-4">
                            <div class="col-12">
                                <h6 class="fw-bold text-uppercase text-secondary small">
                                    <i class="fas fa-question-circle me-2"></i>Problématique
                                </h6>
                                <p class="text-muted" style="text-align: justify;">${t.problematique}</p>
                            </div>

                            <div class="col-md-6 border-end">
                                <h6 class="fw-bold text-uppercase text-secondary small text-warning">
                                    <i class="fas fa-lightbulb me-2"></i>Solution proposée
                                </h6>
                                <p class="text-muted small">${t.solution}</p>
                            </div>

                            <div class="col-md-6">
                                <h6 class="fw-bold text-uppercase text-secondary small text-success">
                                    <i class="fas fa-chart-line me-2"></i>Impact attendu
                                </h6>
                                <p class="text-muted small">${t.impact}</p>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end mt-4">
                            <a href="/these/modifier/${t.id}" class="btn btn-outline-warning btn-sm me-2">
                                <i class="fas fa-edit"></i> Modifier
                            </a>

                            <a href="/these/supprimer/${t.id}"
                               class="btn btn-outline-danger btn-sm"
                               onclick="event.stopPropagation(); return confirm('Supprimer définitivement cette thèse ?');">
                                <i class="fas fa-trash"></i> Supprimer
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty listeTheses}">
        <div class="alert alert-info text-center shadow-sm">
            <i class="fas fa-info-circle me-2"></i>Aucune thèse enregistrée pour le moment.
        </div>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>