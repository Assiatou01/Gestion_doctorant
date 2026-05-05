<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Gestion des domaines</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="fragments/styles.jsp" />
    <style>
        body { background-color: #f8f9fc; }
        .card-admin { border: none; border-radius: 1rem; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
        .card-header { background: #ffffff; border-bottom: 1px solid #eef2f6; color: #1e293b; padding: 1rem 1.5rem; }
        .btn-table { border-radius: 2rem; padding: 0.2rem 0.8rem; font-size: 0.8rem; }
        .table thead th { background-color: #f8fafc; font-weight: 600; color: #334155; border-bottom: 1px solid #e2e8f0; }
        /* Forcer tout sur une seule ligne */
        .table td, .table th {
            white-space: nowrap;
            vertical-align: middle;
        }
        .table .modif-form {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
        }
        .table .modif-form input {
            width: 160px;
            margin-right: 0.2rem;
        }
        @media (max-width: 768px) {
            .table td, .table th {
                white-space: normal; /* sur mobile, on autorise le retour à la ligne */
            }
        }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container py-4">
        <div class="card card-admin">
            <div class="card-header">
                <h4 class="mb-0"><i class="fas fa-tags me-2 text-primary"></i>Gestion des domaines de recherche</h4>
            </div>
            <div class="card-body p-4">
                <!-- Formulaire d'ajout -->
                <form action="/admin/domaines/ajouter" method="post" class="row g-3 mb-4 align-items-end bg-light p-3 rounded-3">
                    <div class="col-md-8">
                        <label class="form-label fw-semibold text-secondary">Nouveau domaine</label>
                        <input type="text" name="domaine" class="form-control" placeholder="Ex: Intelligence Artificielle" required>
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-primary rounded-pill w-100" title="Ajouter">
                            <i class="fas fa-plus me-1"></i> Ajouter
                        </button>
                    </div>
                </form>

                <!-- Tableau -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr><th>ID</th><th>Domaine</th><th class="text-end">Actions</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${domaines}" var="d">
                            <tr>
                                <td>${d.id}</td>
                                <td>${d.domaine}</td>
                                <td class="text-end">
                                    <div class="modif-form d-inline-flex align-items-center gap-2">
                                        <form action="/admin/domaines/modifier/${d.id}" method="post" class="d-inline-block">
                                            <div class="d-flex gap-1">
                                                <input type="text" name="domaine" value="${d.domaine}" required class="form-control form-control-sm" style="width: 160px;">
                                                <button type="submit" class="btn btn-outline-primary btn-sm" title="Modifier">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                            </div>
                                        </form>
                                        <a href="/admin/domaines/supprimer/${d.id}" class="btn btn-outline-secondary btn-sm" title="Supprimer" onclick="return confirm('Supprimer ce domaine ?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="mt-4 text-center">
                    <a href="/dashboard" class="btn btn-outline-secondary rounded-pill px-4" title="Retour">
                        <i class="fas fa-arrow-left me-1"></i> Retour
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>