<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inscription | EDMI - ESMT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #e9f0ff 0%, #d4e0f5 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .register-card { border: none; border-radius: 2rem; box-shadow: 0 20px 35px rgba(0,0,0,0.1); max-width: 500px; width: 100%; }
        .card-header { background: linear-gradient(135deg, #0d6efd, #0b5ed7); color: white; border-radius: 2rem 2rem 0 0 !important; padding: 1.5rem; text-align: center; }
        .btn-register { background: #0d6efd; border: none; border-radius: 2rem; padding: 10px; font-weight: 600; }
        .btn-register:hover { background: #0b5ed7; }
    </style>
</head>
<body>
<div class="register-card card">
    <div class="card-header">
        <i class="fas fa-user-plus fa-2x mb-2"></i>
        <h4 class="mb-0">Créer un compte EDMI</h4>
    </div>
    <div class="card-body p-4">
        <c:if test="${param.error != null}"><div class="alert alert-danger rounded-pill">Erreur : ${param.error}</div></c:if>
        <form action="/register" method="post">
            <div class="mb-3"><label class="form-label fw-semibold">Nom complet</label><div class="input-group"><span class="input-group-text bg-white"><i class="fas fa-user text-primary"></i></span><input type="text" name="nom" class="form-control rounded-end" required></div></div>
            <div class="mb-3"><label class="form-label fw-semibold">Email professionnel</label><div class="input-group"><span class="input-group-text bg-white"><i class="fas fa-envelope text-primary"></i></span><input type="email" name="email" class="form-control rounded-end" required></div></div>
            <div class="mb-3"><label class="form-label fw-semibold">Mot de passe</label><div class="input-group"><span class="input-group-text bg-white"><i class="fas fa-lock text-primary"></i></span><input type="password" name="password" class="form-control rounded-end" required></div></div>
<%--            <div class="mb-4"><label class="form-label fw-semibold">Rôle / Profil</label><div class="input-group"><span class="input-group-text bg-white"><i class="fas fa-briefcase text-primary"></i></span><select name="role" class="form-select" required><option value="" disabled selected>Choisir...</option><c:forEach items="${roles}" var="r"><option value="${r}">${r}</option></c:forEach></select></div><div class="form-text text-muted small mt-2">Le rôle <strong>ADMINISTRATEUR</strong> donne accès au Dashboard.</div></div>--%>
            <button type="submit" class="btn btn-register w-100 py-2 fw-bold">S'inscrire</button>
        </form>
        <hr class="my-4">
        <div class="text-center"><p class="text-muted mb-0">Déjà inscrit ?</p><a href="/login" class="text-primary fw-bold text-decoration-none">Se connecter ici</a></div>
    </div>
    <div class="card-footer bg-light text-center py-3 border-0 rounded-bottom">
        <small class="text-muted">Système de Cartographie Doctorants EDMI</small>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>