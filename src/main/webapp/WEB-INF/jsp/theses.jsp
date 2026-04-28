<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Annuaire des Thèses - EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .thesis-card { border-left: 5px solid #0d6efd; transition: all 0.2s; background: white; }
        .thesis-card:hover { background-color: #f1f9ff; }
        .btn-outline-custom { border-radius: 20px; }
        .accordion-button:not(.collapsed) { background-color: #e7f1ff; color: #0d6efd; }
    </style>
</head>
<body class="bg-light">

<jsp:include page="fragments/header.jsp" />

<div class="container pb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary"><i class="fas fa-book-open me-2"></i>Travaux de Recherche</h2>
        <c:if test="${not isCandidat}">
            <a href="/these/nouveau" class="btn btn-primary rounded-pill px-4"><i class="fas fa-plus-circle me-2"></i>Nouvelle Thèse</a>
        </c:if>
        <c:if test="${isCandidat}">
            <a href="/these/candidat/nouveau" class="btn btn-success rounded-pill px-4"><i class="fas fa-plus-circle me-2"></i>Déclarer ma thèse</a>
        </c:if>
    </div>

    <c:if test="${isCandidat}">
        <div class="alert alert-info alert-dismissible fade show shadow-sm rounded-pill">
            <i class="fas fa-info-circle me-2"></i> Vous ne voyez que vos propres thèses.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="accordion shadow-sm" id="accordionTheses">
        <c:forEach items="${listeTheses}" var="t">
            <div class="accordion-item mb-3 border-0 overflow-hidden rounded-3 shadow-sm thesis-card">
                <h2 class="accordion-header" id="heading${t.id}">
                    <button class="accordion-button collapsed bg-transparent" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${t.id}">
                        <div class="w-100">
                            <div class="mb-2">
                                <span class="badge bg-primary me-2 text-uppercase rounded-pill">${t.secteur}</span>
                                <c:forEach items="${t.motsCles}" var="m">
                                    <span class="badge border text-secondary bg-white rounded-pill">#${m.mot}</span>
                                </c:forEach>
                            </div>
                            <div class="h5 fw-bold text-dark">${t.intitule}</div>
                            <div class="text-muted small">
                                <i class="fas fa-user-graduate me-1"></i> <strong>Doctorant(s) :</strong>
                                <c:forEach items="${t.doctorants}" var="d" varStatus="loop">
                                    <span class="text-primary">${d.firstName} ${d.lastName}</span><c:if test="${not loop.last}">, </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </button>
                </h2>
                <div id="collapse${t.id}" class="accordion-collapse collapse" data-bs-parent="#accordionTheses">
                    <div class="accordion-body bg-white pt-0">
                        <hr class="mt-0">
                        <div class="row g-4">
                            <div class="col-12"><h6 class="fw-bold text-secondary"><i class="fas fa-question-circle me-2"></i>Problématique</h6><p class="text-dark">${t.problematique}</p></div>
                            <div class="col-md-6 border-end"><h6 class="fw-bold text-warning"><i class="fas fa-lightbulb me-2"></i>Solution proposée</h6><p class="text-secondary">${t.solution}</p></div>
                            <div class="col-md-6"><h6 class="fw-bold text-success"><i class="fas fa-chart-line me-2"></i>Impact attendu</h6><p class="text-secondary">${t.impact}</p></div>
                        </div>
                        <div class="d-flex justify-content-end mt-4 gap-2">
                            <c:if test="${not isCandidat}">
                                <a href="/these/modifier/${t.id}" class="btn btn-outline-warning btn-sm rounded-pill px-3"><i class="fas fa-edit"></i> Modifier</a>
                                <a href="/these/supprimer/${t.id}" class="btn btn-outline-danger btn-sm rounded-pill px-3" onclick="return confirm('Supprimer ?')"><i class="fas fa-trash"></i> Supprimer</a>
                            </c:if>
                            <c:if test="${isCandidat}">
                                <a href="/these/modifier-moi/${t.id}" class="btn btn-outline-warning btn-sm rounded-pill px-3"><i class="fas fa-edit"></i> Modifier</a>
                                <a href="/these/supprimer-moi/${t.id}" class="btn btn-outline-danger btn-sm rounded-pill px-3" onclick="return confirm('Supprimer ?')"><i class="fas fa-trash"></i> Supprimer</a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty listeTheses}">
        <div class="alert alert-warning text-center shadow-sm rounded-pill">
            <i class="fas fa-inbox fa-2x d-block mb-2"></i>Aucune thèse trouvée.
        </div>
    </c:if>
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>