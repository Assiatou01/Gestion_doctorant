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
        :root {
            --primary: #0d6efd;
            --primary-dark: #0b5ed7;
            --primary-gradient: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
            --danger: #dc3545;
            --danger-dark: #bb2d3b;
            --warning: #ffc107;
            --success: #198754;
            --text-main: #212529;
            --text-muted: #6c757d;
            --bg-light: #f8f9fc;
            --shadow-sm: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
            --shadow-md: 0 0.5rem 1rem rgba(0,0,0,0.08);
            --transition: all 0.2s ease-in-out;
            --card-bg: #ffffff;
            --border-radius-lg: 1rem;
        }
        body {
            background-color: var(--bg-light);
        }
        .card-custom {
            border: none;
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            transition: var(--transition);
        }
        .card-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 1rem 2rem rgba(0,0,0,0.1);
        }
        .profile-banner {
            background: var(--primary-gradient);
            height: 180px;
            border-radius: var(--border-radius-lg) var(--border-radius-lg) 0 0;
            position: relative;
            margin-bottom: 80px;
        }
        .profile-avatar {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 6px solid var(--bg-light);
            background: white;
            position: absolute;
            bottom: -70px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: var(--primary);
            box-shadow: var(--shadow-md);
        }
        .info-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-muted);
            margin-bottom: 0.3rem;
            font-weight: 600;
        }
        .info-value {
            font-size: 1.05rem;
            color: var(--text-main);
            margin-bottom: 1.5rem;
            font-weight: 500;
        }
        .btn-outline-danger {
            border-radius: 2rem;
            transition: var(--transition);
        }
        .btn-outline-danger:hover {
            background-color: var(--danger);
            color: white;
            transform: translateY(-2px);
        }
        .btn-outline-primary, .btn-outline-warning, .btn-secondary, .btn-warning {
            border-radius: 2rem;
            transition: var(--transition);
        }
        .btn-outline-primary:hover, .btn-outline-warning:hover, .btn-secondary:hover, .btn-warning:hover {
            transform: translateY(-2px);
        }
        .badge.bg-primary-subtle {
            background-color: #e7f1ff;
            color: var(--primary);
            border: 1px solid #b8d9ff;
        }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container pb-5">
        <div class="card card-custom mb-4">
            <div class="profile-banner">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
            </div>
            <div class="text-center px-4 pb-4">
                <h1 class="display-6 fw-bold mb-1" style="color: var(--text-main);">${doctorant.firstName} ${doctorant.lastName}</h1>
                <p class="text-muted mb-3">
                    <i class="fas fa-envelope me-2"></i>${doctorant.email}
                    <span class="mx-2">|</span>
                    <i class="fas fa-phone me-2"></i>${doctorant.telephone}
                </p>
                <div>
                    <span class="badge bg-primary-subtle rounded-pill px-3 py-2">
                        <i class="fas fa-file-alt me-2"></i> ${not empty doctorant.publications ? doctorant.publications.size() : 0} Publications
                    </span>
                </div>
            </div>
        </div>

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
                <div class="card card-custom mb-4">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3 text-primary"><i class="fas fa-bullseye me-2 text-warning"></i>Vision & Carrière</h5>
                        <div class="info-label">Centres d'intérêts</div>
                        <p class="text-muted small">${doctorant.interet}</p>
                        <div class="info-label">Souhait d'insertion</div>
                        <p class="text-muted small">${doctorant.souhait}</p>
                    </div>
                </div>
                <div class="card card-custom">
                    <div class="card-body p-4 text-center">
                        <h5 class="fw-bold mb-3 text-primary"><i class="fas fa-folder-open me-2 text-info"></i>Documents</h5>
                        <c:if test="${not empty doctorant.cv}">
                            <a href="${doctorant.cv}" target="_blank" class="btn btn-outline-primary rounded-pill w-100 mb-2">
                                <i class="fas fa-file-pdf me-2"></i> Consulter le CV
                            </a>
                        </c:if>
                        <a href="/doctorants" class="btn btn-secondary rounded-pill w-100">
                            <i class="fas fa-arrow-left me-2"></i> Retour à l'annuaire
                        </a>
                        <div class="mt-3">
                            <a href="/doctorant/modifier/${doctorant.id}" class="btn btn-warning rounded-pill w-100">
                                <i class="fas fa-edit me-2"></i> Éditer le profil
                            </a>
                        </div>
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