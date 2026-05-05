<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Profil de ${doctorant.firstName} ${doctorant.lastName} | EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="fragments/styles.jsp" />
    <style>
        :root {
            --primary-color: #0d6efd;
            --gray-light: #f8f9fc;
            --gray-border: #eef2f6;
            --shadow-sm: 0 2px 6px rgba(0,0,0,0.02), 0 1px 2px rgba(0,0,0,0.05);
            --shadow-md: 0 8px 20px rgba(0,0,0,0.05);
        }
        body {
            background-color: #f4f7fb;
        }
        .profile-banner {
            background: linear-gradient(120deg, #0d6efd, #0a58ca);
            height: 160px;
            border-radius: 1.2rem 1.2rem 0 0;
            position: relative;
            margin-bottom: 70px;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3.2rem;
            color: var(--primary-color);
            position: absolute;
            bottom: -60px;
            left: 50%;
            transform: translateX(-50%);
            box-shadow: 0 6px 14px rgba(0,0,0,0.1);
            border: 4px solid white;
            transition: transform 0.2s;
        }
        .profile-avatar:hover {
            transform: translateX(-50%) scale(1.02);
        }
        .card-custom {
            border: none;
            border-radius: 1.2rem;
            background: white;
            box-shadow: var(--shadow-sm);
            transition: all 0.25s ease;
            overflow: hidden;
        }
        .card-custom:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-3px);
        }
        .info-label {
            font-size: 0.7rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6c86a3;
            margin-bottom: 0.3rem;
        }
        .info-value {
            font-size: 1rem;
            font-weight: 500;
            color: #1e2c3a;
            margin-bottom: 1rem;
        }
        .badge-soft-primary {
            background: #eef2ff;
            color: #0d6efd;
            border-radius: 2rem;
            padding: 0.4rem 0.9rem;
            font-weight: 500;
            font-size: 0.75rem;
        }
        .badge-light-custom {
            background: #f8fafc;
            color: #2c3e50;
            border: 1px solid #e2e8f0;
            border-radius: 2rem;
            padding: 0.3rem 0.8rem;
            font-weight: 500;
            font-size: 0.75rem;
        }
        .btn-outline-icon {
            border-radius: 2rem;
            padding: 0.4rem 1rem;
            font-size: 0.85rem;
        }
        .contact-info {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 1.2rem;
            margin-top: 0.5rem;
        }
        .contact-info span {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }
        hr {
            opacity: 0.5;
            margin: 1.2rem 0;
        }
        @media (max-width: 768px) {
            .profile-banner { height: 130px; margin-bottom: 60px; }
            .profile-avatar { width: 100px; height: 100px; font-size: 2.5rem; bottom: -50px; }
            .info-value { font-size: 0.9rem; }
            .contact-info { gap: 0.8rem; font-size: 0.85rem; }
        }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container pb-5">
        <!-- Carte profil principal -->
        <div class="card-custom mb-5 overflow-hidden shadow-sm">
            <div class="profile-banner"></div>
            <div class="profile-avatar">
                <i class="fas fa-user-graduate"></i>
            </div>
            <div class="text-center px-4 pb-4 pt-5">
                <h1 class="display-5 fw-bold" style="color: #0a2540;">${doctorant.firstName} ${doctorant.lastName}</h1>
                <div class="contact-info text-muted">
                    <span><i class="fas fa-envelope text-primary"></i> ${doctorant.email}</span>
                    <span><i class="fas fa-phone-alt text-primary"></i> ${doctorant.telephone}</span>
                </div>
                <div class="mt-3">
                    <span class="badge-soft-primary">
                        <i class="fas fa-file-alt me-1"></i> ${not empty doctorant.publications ? doctorant.publications.size() : 0} publication(s)
                    </span>
                </div>
            </div>
        </div>

        <!-- Reste du code identique à l’original (parcours, compétences, documents) -->
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card-custom mb-4">
                    <div class="card-body p-4">
                        <h4 class="mb-4 fw-semibold"><i class="fas fa-university me-2 text-primary"></i> Parcours académique</h4>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="info-label">Faculté</div>
                                <div class="info-value">${not empty doctorant.faculte ? doctorant.faculte.nom : 'Non définie'}</div>
                                <div class="info-label">Laboratoire</div>
                                <div class="info-value">${not empty doctorant.laboratoire ? doctorant.laboratoire.nom : 'Non défini'}</div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-label">École doctorale</div>
                                <div class="info-value">${not empty doctorant.ecoleDoctorale ? doctorant.ecoleDoctorale.nom : 'Non définie'}</div>
                                <div class="info-label">Maturation / statut</div>
                                <div><span class="badge-soft-primary">${not empty doctorant.maturation ? doctorant.maturation : 'En cours'}</span></div>
                            </div>
                        </div>
                        <hr>
                        <h4 class="mb-4 fw-semibold"><i class="fas fa-calendar-alt me-2 text-primary"></i> Calendrier de thèse</h4>
                        <div class="row text-center g-3">
                            <div class="col-6">
                                <div class="info-label">Début</div>
                                <div class="fw-bold text-success fs-5">${dateStartFormatted != null ? dateStartFormatted : 'Non renseignée'}</div>
                            </div>
                            <div class="col-6">
                                <div class="info-label">Fin (prévision)</div>
                                <div class="fw-bold text-danger fs-5">${dateEndFormatted != null ? dateEndFormatted : 'Non renseignée'}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card-custom mb-4">
                    <div class="card-body p-4">
                        <h5 class="fw-semibold mb-3"><i class="fas fa-bullseye me-2 text-primary"></i> Vision & carrière</h5>
                        <div class="info-label">Centres d'intérêt</div>
                        <p class="text-secondary mb-3">${doctorant.interet}</p>
                        <div class="info-label">Souhait d'insertion</div>
                        <p class="text-secondary">${doctorant.souhait}</p>
                    </div>
                </div>

                <div class="card-custom mb-4">
                    <div class="card-body p-4">
                        <h5 class="fw-semibold mb-3"><i class="fas fa-tags me-2 text-primary"></i> Domaines de recherche</h5>
                        <div>
                            <c:forEach items="${doctorant.domainesRecherche}" var="domaine">
                                <span class="badge-light-custom me-1 mb-1">${domaine.domaine}</span>
                            </c:forEach>
                            <c:if test="${empty doctorant.domainesRecherche}"><span class="text-muted small">Non renseigné</span></c:if>
                        </div>
                    </div>
                </div>

                <div class="card-custom mb-4">
                    <div class="card-body p-4">
                        <h5 class="fw-semibold mb-3"><i class="fas fa-brain me-2 text-primary"></i> Compétences</h5>
                        <div>
                            <c:forEach items="${doctorant.competences}" var="comp">
                                <span class="badge-light-custom me-1 mb-1">${comp.nomCompetence}</span>
                            </c:forEach>
                            <c:if test="${empty doctorant.competences}"><span class="text-muted small">Non renseigné</span></c:if>
                        </div>
                    </div>
                </div>

                <div class="card-custom">
                    <div class="card-body p-4 text-center">
                        <h5 class="fw-semibold mb-3"><i class="fas fa-folder-open me-2 text-primary"></i> Documents</h5>
                        <c:if test="${not empty doctorant.cv}">
                            <a href="${doctorant.cv}" target="_blank" class="btn btn-outline-primary rounded-pill w-100 mb-2 btn-outline-icon">
                                <i class="fas fa-file-pdf me-2"></i> Voir le CV
                            </a>
                        </c:if>
                        <a href="/doctorants" class="btn btn-outline-secondary rounded-pill w-100 mb-2 btn-outline-icon">
                            <i class="fas fa-arrow-left me-2"></i> Annuaire
                        </a>
                        <a href="/doctorant/modifier/${doctorant.id}" class="btn btn-outline-warning rounded-pill w-100 mb-3 btn-outline-icon">
                            <i class="fas fa-edit me-2"></i> Éditer le profil
                        </a>
                        <form action="/doctorant/upload-cv/${doctorant.id}" method="post" enctype="multipart/form-data">
                            <label class="form-label small fw-semibold">Téléverser un CV</label>
                            <div class="input-group input-group-sm">
                                <input type="file" name="file" class="form-control" accept=".pdf,.doc,.docx" required>
                                <button type="submit" class="btn btn-outline-primary" title="Importer">
                                    <i class="fas fa-upload"></i>
                                </button>
                            </div>
                            <div class="form-text text-muted small mt-1">PDF, DOC, DOCX (max 5 Mo)</div>
                        </form>
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