<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription | EDMI - ESMT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .register-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 100%;
        }
        .card-header {
            background-color: #198754;
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 20px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="register-card card">
    <div class="card-header">
        <h4 class="mb-0"><i class="fas fa-user-plus me-2"></i>Créer un compte EDMI</h4>
    </div>
    <div class="card-body p-4">

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                Erreur : ${param.error}
            </div>
        </c:if>

        <form action="/register" method="post">
            <div class="mb-3">
                <label class="form-label fw-bold">Nom complet</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                    <input type="text" name="nom" class="form-control" placeholder="Ex: Jean Dupont" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Email professionnel</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="exemple@esmt.sn" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Mot de passe</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input type="password" name="password" class="form-control" placeholder="********" required>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-bold">Rôle / Profil</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-briefcase"></i></span>
                    <select name="role" class="form-select" required>
                        <option value="" disabled selected>Choisir un profil...</option>
                        <c:forEach items="${roles}" var="r">
                            <option value="${r}">${r}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-text mt-2 text-muted small">
                    <i class="fas fa-info-circle me-1"></i>
                    Le rôle <strong>ADMINISTRATEUR</strong> donne accès au Dashboard.
                </div>
            </div>

            <button type="submit" class="btn btn-success w-100 py-2 fw-bold shadow-sm">
                S'inscrire maintenant
            </button>
        </form>

        <hr>

        <div class="text-center">
            <p class="text-muted mb-0">Déjà inscrit ?</p>
            <a href="/login" class="text-success fw-bold text-decoration-none">Se connecter ici</a>
        </div>
    </div>
    <div class="card-footer bg-light text-center py-3">
        <small class="text-muted">Système de Cartographie Doctorants ISI</small>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>