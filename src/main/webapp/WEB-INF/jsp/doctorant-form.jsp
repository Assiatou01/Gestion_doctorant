<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Formulaire Doctorant - EDMI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="fragments/styles.jsp" />
    <style>
        body {
            background: #f4f7fb;
        }
        .card-form {
            border: none;
            border-radius: 1.5rem;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }
        .card-header {
            background: white;
            border-bottom: 1px solid #eef2f6;
            padding: 1.25rem 1.8rem;
        }
        .form-control, .form-select {
            border: 1px solid #e2e8f0;
            border-radius: 0.75rem;
            padding: 0.6rem 1rem;
            transition: all 0.2s;
            background-color: #ffffff;
        }
        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
            outline: none;
        }
        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin: 1.8rem 0 1.2rem 0;
            padding-left: 1rem;
            border-left: 4px solid #0d6efd;
            color: #1e2a3a;
        }
        .input-group-text {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-right: none;
            border-radius: 0.75rem 0 0 0.75rem;
            color: #0d6efd;
        }
        .input-group .form-control {
            border-left: none;
            border-radius: 0 0.75rem 0.75rem 0;
        }
        .btn-custom {
            border-radius: 2rem;
            padding: 0.55rem 1.8rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-custom i {
            margin-right: 0.5rem;
        }
        .btn-primary {
            background: #0d6efd;
            border: none;
        }
        .btn-primary:hover {
            background: #0b5ed7;
            transform: translateY(-2px);
            box-shadow: 0 6px 14px rgba(13, 110, 253, 0.2);
        }
        .btn-secondary {
            background: #eef2f6;
            border: none;
            color: #2c3e50;
        }
        .btn-secondary:hover {
            background: #e2e8f0;
            transform: translateY(-2px);
        }
        .checkbox-custom {
            margin-top: 2rem;
        }
        hr {
            opacity: 0.4;
            margin: 1rem 0;
        }
        @media (max-width: 768px) {
            .card-header {
                padding: 1rem;
            }
            .section-title {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container py-4">
        <div class="card card-form">
            <div class="card-header">
                <h4 class="mb-0 fw-semibold">
                    <i class="fas fa-user-edit me-2 text-primary"></i>
                    Fiche complète du doctorant
                </h4>
                <p class="text-muted small mb-0 mt-1">Renseignez toutes les informations académiques et professionnelles</p>
            </div>
            <div class="card-body p-4 p-lg-5">
                <form action="/doctorant/save" method="post">
                    <input type="hidden" name="id" value="${doctorant.id}" />

                    <!-- ÉTAT CIVIL -->
                    <div class="section-title">1. État civil</div>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold"><i class="fas fa-user me-1 text-primary"></i> Nom</label>
                            <input type="text" name="lastName" class="form-control" value="${doctorant.lastName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold"><i class="fas fa-user me-1 text-primary"></i> Prénom</label>
                            <input type="text" name="firstName" class="form-control" value="${doctorant.firstName}" required>
                        </div>
                    </div>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold"><i class="fas fa-envelope me-1 text-primary"></i> Email</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" name="email" class="form-control" value="${doctorant.email}">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold"><i class="fas fa-phone me-1 text-primary"></i> Téléphone</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                <input type="text" name="telephone" class="form-control" value="${doctorant.telephone}">
                            </div>
                        </div>
                    </div>

                    <!-- PARCOURS ACADÉMIQUE -->
                    <div class="section-title">2. Parcours académique</div>
                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold"><i class="fas fa-building me-1 text-primary"></i> Faculté</label>
                            <select name="faculte.id" class="form-select">
                                <option value="">-- Choisir --</option>
                                <c:forEach items="${facultes}" var="fac">
                                    <option value="${fac.id}" ${doctorant.faculte != null && doctorant.faculte.id == fac.id ? 'selected' : ''}>${fac.nom}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold"><i class="fas fa-flask me-1 text-primary"></i> Laboratoire</label>
                            <select name="laboratoire.id" class="form-select">
                                <option value="">-- Choisir --</option>
                                <c:forEach items="${laboratoires}" var="lab">
                                    <option value="${lab.id}" ${doctorant.laboratoire != null && doctorant.laboratoire.id == lab.id ? 'selected' : ''}>${lab.nom}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold"><i class="fas fa-chart-line me-1 text-primary"></i> Maturation</label>
                            <input type="text" name="maturation" class="form-control" value="${doctorant.maturation}" placeholder="Ex: 2ème année, Prototype...">
                        </div>
                    </div>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold"><i class="fas fa-calendar me-1 text-primary"></i> Date début thèse</label>
                            <input type="date" name="dateStart" class="form-control" value="${doctorant.dateStart}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold"><i class="fas fa-calendar-check me-1 text-primary"></i> Date fin (prévision)</label>
                            <input type="date" name="dateEnd" class="form-control" value="${doctorant.dateEnd}">
                        </div>
                    </div>

                    <!-- MÉTIER & CARRIÈRE -->
                    <div class="section-title">3. Informations métier & carrière</div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold"><i class="fas fa-heart me-1 text-primary"></i> Centres d'intérêt</label>
                        <textarea name="interet" class="form-control" rows="2" placeholder="Recherche, enseignement, entrepreneuriat...">${doctorant.interet}</textarea>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold"><i class="fas fa-bullhorn me-1 text-primary"></i> Souhait d'insertion</label>
                        <textarea name="souhait" class="form-control" rows="2" placeholder="Continuer la recherche, être salarié, entreprendre...">${doctorant.souhait}</textarea>
                    </div>
                    <div class="row g-3 mb-4">
                        <div class="col-md-8">
                            <label class="form-label fw-semibold"><i class="fas fa-link me-1 text-primary"></i> Lien CV / Drive</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-globe"></i></span>
                                <input type="text" name="cv" class="form-control" value="${doctorant.cv}" placeholder="https://drive.google.com/...">
                            </div>
                        </div>
                        <div class="col-md-4 checkbox-custom">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="publicationFaire" id="publiCheck" ${doctorant.publicationFaire ? 'checked' : ''}>
                                <label class="form-check-label" for="publiCheck">
                                    <i class="fas fa-file-alt me-1"></i> A des publications
                                </label>
                            </div>
                        </div>
                    </div>

                    <hr>
                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-primary btn-custom">
                            <i class="fas fa-save"></i> Enregistrer
                        </button>
                        <a href="/doctorants" class="btn btn-secondary btn-custom ms-2">
                            <i class="fas fa-times"></i> Annuler
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>