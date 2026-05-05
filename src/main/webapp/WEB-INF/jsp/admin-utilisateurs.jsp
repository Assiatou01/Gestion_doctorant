<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Gestion des utilisateurs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="fragments/styles.jsp" />
</head>
<body>
<jsp:include page="fragments/sidebar.jsp" />
<div class="main-content">
    <jsp:include page="fragments/header.jsp" />
    <div class="container py-4">
        <div class="card" style="border: none; border-radius: 1rem; box-shadow: 0 1px 2px rgba(0,0,0,0.03);">
            <div class="card-header bg-white border-bottom py-3">
                <h4 class="mb-0"><i class="fas fa-users me-2 text-primary"></i>Gestion des utilisateurs et rôles</h4>
            </div>
            <div class="card-body p-4">
                <!-- Formulaire de création -->
                <div class="card mb-4 border-0 shadow-sm">
                    <div class="card-header bg-white fw-bold">
                        <i class="fas fa-user-plus me-2 text-primary"></i> Créer un utilisateur
                    </div>
                    <div class="card-body">
                        <form action="/admin/utilisateur/creer" method="post" class="row g-2">
                            <div class="col-md-3">
                                <input type="text" name="nom" class="form-control" placeholder="Nom complet" required>
                            </div>
                            <div class="col-md-3">
                                <input type="email" name="email" class="form-control" placeholder="Email" required>
                            </div>
                            <div class="col-md-2">
                                <input type="password" name="password" class="form-control" placeholder="Mot de passe" required>
                            </div>
                            <div class="col-md-2">
                                <select name="role" class="form-select">
                                    <option value="CANDIDAT">CANDIDAT</option>
                                    <option value="GESTIONNAIRE">GESTIONNAIRE</option>
                                    <option value="ADMINISTRATEUR">ADMINISTRATEUR</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100"><i class="fas fa-user-plus me-2"></i> Créer</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Tableau des utilisateurs -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr><th>ID</th><th>Email</th><th>Doctorant associé</th><th>Rôle actuel</th><th>Nouveau rôle</th><th class="text-center">Action</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${utilisateurs}" var="u">
                            <c:if test="${u.id != null}">
                                <tr>
                                    <td>${u.id}</td>
                                    <td>${u.email}</td>
                                    <td>${u.doctorant != null ? u.doctorant.firstName : ''} ${u.doctorant != null ? u.doctorant.lastName : ''}</td>
                                    <td><span class="badge bg-secondary">${u.role}</span></td>
                                    <td>
                                        <form action="/admin/utilisateur/changer-role" method="post" class="d-flex gap-2 align-items-center">
                                            <input type="hidden" name="id" value="${u.id}">
                                            <select name="role" class="form-select form-select-sm" style="width: 130px;">
                                                <c:forEach items="${roles}" var="r"><option value="${r}" ${u.role == r ? 'selected' : ''}>${r}</option></c:forEach>
                                            </select>
                                            <button type="submit" class="btn btn-outline-primary btn-sm" title="Appliquer">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </form>
                                    </td>
                                    <td class="text-center">
                                        <a href="/admin/utilisateur/supprimer/${u.id}" class="btn btn-outline-secondary btn-sm" title="Supprimer" onclick="return confirm('Supprimer cet utilisateur ?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="mt-4 text-center">
                    <a href="/dashboard" class="btn btn-outline-secondary rounded-pill px-4"><i class="fas fa-arrow-left me-2"></i> Retour au tableau de bord</a>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>