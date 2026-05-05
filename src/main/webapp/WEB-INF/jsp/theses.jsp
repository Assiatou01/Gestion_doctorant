<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Annuaire des Thèses - EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="fragments/styles.jsp" />
    <style>
        .thesis-card { border-left: 4px solid #0d6efd; transition: 0.2s; }
        .thesis-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .accordion-button:not(.collapsed) { background-color: #f8f9fc; color: #0d6efd; font-weight: 600; }
        .accordion-button:focus { box-shadow: none; }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary"><i class="fas fa-book-open me-2"></i>Travaux de Recherche</h2>
            <c:if test="${not isCandidat}">
                <a href="/these/nouveau" class="btn btn-primary rounded-pill px-4"><i class="fas fa-plus-circle me-2"></i> Nouvelle Thèse</a>
            </c:if>
            <c:if test="${isCandidat}">
                <a href="/these/candidat/nouveau" class="btn btn-primary rounded-pill px-4"><i class="fas fa-plus-circle me-2"></i> Déclarer ma thèse</a>
            </c:if>
        </div>

        <div class="accordion" id="accordionTheses">
            <c:forEach items="${listeTheses}" var="t">
                <div class="accordion-item mb-3 border-0 rounded-3 shadow-sm thesis-card">
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
                                <div class="col-12">
                                    <h6 class="fw-bold text-secondary"><i class="fas fa-question-circle me-2"></i>Problématique</h6>
                                    <p class="text-dark">${t.problematique}</p>
                                </div>
                                <div class="col-md-6 border-end">
                                    <h6 class="fw-bold text-secondary"><i class="fas fa-lightbulb me-2"></i>Solution proposée</h6>
                                    <p class="text-dark">${t.solution}</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="fw-bold text-secondary"><i class="fas fa-chart-line me-2"></i>Impact attendu</h6>
                                    <p class="text-dark">${t.impact}</p>
                                </div>
                            </div>
                            <div class="d-flex justify-content-end mt-4 gap-2">
                                <c:if test="${not isCandidat}">
                                    <a href="/these/modifier/${t.id}" class="btn btn-outline-primary btn-sm rounded-pill px-3" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="/these/supprimer/${t.id}" class="btn btn-outline-secondary btn-sm rounded-pill px-3" onclick="return confirm('Supprimer ?')" title="Supprimer">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </c:if>
                                <c:if test="${isCandidat}">
                                    <a href="/these/modifier-moi/${t.id}" class="btn btn-outline-primary btn-sm rounded-pill px-3" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="/these/supprimer-moi/${t.id}" class="btn btn-outline-secondary btn-sm rounded-pill px-3" onclick="return confirm('Supprimer ?')" title="Supprimer">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty listeTheses}">
            <div class="text-center py-5">
                <i class="fas fa-file-alt fa-4x text-muted mb-3"></i>
                <h4 class="text-muted">Aucune thèse trouvée</h4>
                <c:if test="${isCandidat}">
                    <p class="mb-3">Vous n’avez pas encore déclaré de thèse.</p>
                    <a href="/these/candidat/nouveau" class="btn btn-primary rounded-pill px-4"><i class="fas fa-plus-circle me-2"></i> Déclarer ma thèse</a>
                </c:if>
                <c:if test="${not isCandidat}">
                    <p class="mb-3">Aucune thèse n’est encore enregistrée.</p>
                    <a href="/these/nouveau" class="btn btn-primary rounded-pill px-4"><i class="fas fa-plus-circle me-2"></i> Ajouter une thèse</a>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>