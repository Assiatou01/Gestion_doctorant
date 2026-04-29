<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Gestion des domaines</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fc; }
        .card-admin { border: none; border-radius: 1.5rem; box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.05); }
        .btn-table { border-radius: 2rem; padding: 0.2rem 1rem; font-size: 0.85rem; }
        .table thead th { background-color: #eef2ff; font-weight: 600; }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container py-4">
        <div class="card card-admin">
            <div class="card-header bg-primary text-white rounded-top-4 py-3">
                <h4 class="mb-0"><i class="fas fa-tags me-2"></i>Gestion des domaines de recherche</h4>
            </div>
            <div class="card-body p-4">
                <form action="/admin/domaines/ajouter" method="post" class="row g-3 mb-4 align-items-end bg-light p-3 rounded-4">
                    <div class="col-md-8"><label class="form-label fw-semibold">Nouveau domaine</label><input type="text" name="domaine" class="form-control" placeholder="Ex: Intelligence Artificielle" required></div>
                    <div class="col-md-4"><button type="submit" class="btn btn-primary rounded-pill px-4 w-100"><i class="fas fa-plus me-2"></i>Ajouter</button></div>
                </form>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light"><tr><th>ID</th><th>Domaine</th><th class="text-end">Actions</th></tr></thead>
                        <tbody>
                        <c:forEach items="${domaines}" var="d">
                            <tr>
                                <td>${d.id}</td>
                                <td>${d.domaine}</td>
                                <td class="text-end">
                                    <form action="/admin/domaines/modifier/${d.id}" method="post" class="d-inline-block me-2">
                                        <input type="text" name="domaine" value="${d.domaine}" required class="form-control form-control-sm d-inline-block w-auto" style="width: 180px;">
                                        <button type="submit" class="btn btn-sm btn-warning btn-table"><i class="fas fa-edit"></i> Modifier</button>
                                    </form>
                                    <a href="/admin/domaines/supprimer/${d.id}" class="btn btn-sm btn-danger btn-table" onclick="return confirm('Supprimer ce domaine ?')"><i class="fas fa-trash"></i> Supprimer</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="mt-4 text-center"><a href="/dashboard" class="btn btn-secondary rounded-pill px-5"><i class="fas fa-arrow-left me-2"></i>Retour au tableau de bord</a></div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>