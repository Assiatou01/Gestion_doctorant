<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Gestion des utilisateurs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fc; }
        .card-admin { border: none; border-radius: 1.5rem; box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.05); }
        .badge-role { font-size: 0.75rem; padding: 0.35rem 0.75rem; border-radius: 2rem; }
        .btn-table { border-radius: 2rem; padding: 0.2rem 1rem; }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container py-4">
        <div class="card card-admin">
            <div class="card-header bg-primary text-white rounded-top-4 py-3">
                <h4 class="mb-0"><i class="fas fa-users me-2"></i>Gestion des utilisateurs et rôles</h4>
            </div>
            <div class="card-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light"><tr><th>ID</th><th>Email</th><th>Doctorant associé</th><th>Rôle actuel</th><th>Nouveau rôle</th><th class="text-center">Action</th></tr></thead>
                        <tbody>
                        <c:forEach items="${utilisateurs}" var="u">
                            <c:if test="${u.id != null}">
                                <tr>
                                    <td>${u.id}</td>
                                    <td>${u.email}</td>
                                    <td>${u.doctorant != null ? u.doctorant.firstName : ''} ${u.doctorant != null ? u.doctorant.lastName : ''}</td>
                                    <td><span class="badge bg-secondary badge-role">${u.role}</span></td>
                                    <td>
                                        <form action="/admin/utilisateur/changer-role" method="post" class="d-flex gap-2 align-items-center">
                                            <input type="hidden" name="id" value="${u.id}">
                                            <select name="role" class="form-select form-select-sm" style="width: 130px;">
                                                <c:forEach items="${roles}" var="r"><option value="${r}" ${u.role == r ? 'selected' : ''}>${r}</option></c:forEach>
                                            </select>
                                            <button type="submit" class="btn btn-sm btn-primary btn-table">Appliquer</button>
                                        </form>
                                    </td>
                                    <td class="text-center"><a href="/admin/utilisateur/supprimer/${u.id}" class="btn btn-sm btn-danger btn-table" onclick="return confirm('Supprimer cet utilisateur ?')"><i class="fas fa-trash"></i> Supprimer</a></td>
                                </tr>
                            </c:if>
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