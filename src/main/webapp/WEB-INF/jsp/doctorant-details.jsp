<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Profil de ${doctorant.firstName} ${doctorant.lastName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* vos styles */
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="profile-header shadow-sm">
        <div class="container text-center">
            <div class="mb-3"><i class="fas fa-user-circle fa-5x"></i></div>
            <h1 class="display-5 fw-bold">${doctorant.firstName} ${doctorant.lastName}</h1>
            <p class="lead"><i class="fas fa-envelope me-2"></i>${doctorant.email} | <i class="fas fa-phone me-2"></i>${doctorant.telephone}</p>
            <div class="mt-3"><span class="badge stat-badge"><i class="fas fa-file-alt me-2"></i> ${not empty doctorant.publications ? doctorant.publications.size() : 0} Publications</span></div>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row g-4">
            <div class="col-md-8">
                <div class="card card-custom mb-4">
                    <div class="card-body p-4">
                        <h4 class="card-title mb-4 text-primary"><i class="fas fa-university me-2"></i>Parcours Académique</h4>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-label">Faculté</div>
                                <div class="info-value">${not empty doctorant.faculte ? doctorant.faculte.nom : 'Non définie'}</div>
                                <div class="info-label">Laboratoire</div>
                                <div class="info-value">${not empty doctorant.laboratoire ? doctorant.laboratoire.nom : 'Non défini'}</div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">École Doctorale</div>
                                <div class="info-value">${not empty doctorant.ecoleDoctorale ? doctorant.ecoleDoctorale.nom : 'Non définie'}</div>
                                <div class="info-label">Statut / Maturation</div>
                                <div class="info-value"><span class="badge bg-success rounded-pill">${not empty doctorant.maturation ? doctorant.maturation : 'En cours'}</span></div>
                            </div>
                        </div>
                        <hr>
                        <h4 class="card-title mt-4 mb-4 text-primary"><i class="fas fa-calendar-alt me-2"></i>Calendrier de Thèse</h4>
                        <div class="row text-center">
                            <div class="col-6 border-end">
                                <div class="info-label">Début de Thèse</div>
                                <div class="info-value text-success fw-bold">${dateStartFormatted != null ? dateStartFormatted : 'Non renseignée'}</div>
                            </div>
                            <div class="col-6">
                                <div class="info-label">Fin de Thèse (Prévision)</div>
                                <div class="info-value text-danger fw-bold">${dateEndFormatted != null ? dateEndFormatted : 'Non renseignée'}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <!-- le reste du bloc droite est inchangé -->
                <div class="card card-custom mb-4">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3 text-primary"><i class="fas fa-bullseye me-2 text-warning"></i>Vision & Carrière</h5>
                        <div class="info-label">Centres d'intérêts</div><p class="text-muted small">${doctorant.interet}</p>
                        <div class="info-label">Souhait d'insertion</div><p class="text-muted small">${doctorant.souhait}</p>
                    </div>
                </div>
                <div class="card card-custom">
                    <div class="card-body p-4 text-center">
                        <h5 class="fw-bold mb-3 text-primary"><i class="fas fa-folder-open me-2 text-info"></i>Documents</h5>
                        <c:if test="${not empty doctorant.cv}">
                            <a href="${doctorant.cv}" target="_blank" class="btn btn-outline-primary rounded-pill w-100 mb-2"><i class="fas fa-file-pdf me-2"></i>Consulter le CV</a>
                        </c:if>
                        <a href="/doctorants" class="btn btn-secondary rounded-pill w-100"><i class="fas fa-arrow-left me-2"></i>Retour à l'annuaire</a>
                        <div class="mt-3"><a href="/doctorant/modifier/${doctorant.id}" class="btn btn-warning rounded-pill w-100"><i class="fas fa-edit me-2"></i>Éditer le profil</a></div>
                        <div class="mt-3">
                            <form action="/doctorant/upload-cv/${doctorant.id}" method="post" enctype="multipart/form-data">
                                <label class="form-label fw-semibold">Téléverser un nouveau CV</label>
                                <div class="input-group mb-2">
                                    <input type="file" name="file" class="form-control" accept=".pdf,.doc,.docx" required>
                                    <button type="submit" class="btn btn-outline-primary rounded-pill">Importer</button>
                                </div>
                                <div class="form-text text-muted small">Formats acceptés : PDF, DOC, DOCX (max 5 Mo)</div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>