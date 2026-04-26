<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion | EDMI - ESMT</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            max-width: 450px;
            width: 100%;
        }
        .login-header {
            background-color: #198754; /* Vert ESMT */
            color: white;
            padding: 30px;
            text-align: center;
        }
        .btn-google {
            background-color: #ffffff;
            border: 1px solid #dadce0;
            color: #3c4043;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-google:hover {
            background-color: #f8f9fa;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        }
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 20px 0;
            color: #6c757d;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #dee2e6;
        }
        .divider:not(:empty)::before { margin-right: .5em; }
        .divider:not(:empty)::after { margin-left: .5em; }
    </style>
</head>
<body>

<div class="login-card card">
    <div class="login-header">
        <i class="fas fa-university fa-3x mb-3"></i>
        <h3>Cartographie EDMI</h3>
        <p class="mb-0">École Doctorale Mathématiques et Informatique</p>
    </div>

    <div class="card-body p-4">

        <c:if test="${param.error != null}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Identifiants incorrects ou accès refusé.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.logout != null}">
            <div class="alert alert-info">Vous avez été déconnecté.</div>
        </c:if>
        <c:if test="${param.registered != null}">
            <div class="alert alert-success">Inscription réussie ! Connectez-vous.</div>
        </c:if>

        <form action="/perform_login" method="post">
            <div class="mb-3">
                <label class="form-label">Email (Identifiant)</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                    <input type="email" name="username" class="form-control" required>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">Mot de passe</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input type="password" name="password" class="form-control" required>
                </div>
            </div>
            <button type="submit" class="btn btn-success w-100">Se connecter</button>
        </form>

        <div class="divider my-4">OU</div>

        <a href="/oauth2/authorization/google" class="btn btn-outline-danger w-100">
            <img src="https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg" width="20" class="me-2">
            Continuer avec Google
        </a>

        <div class="divider">OU</div>

        <a href="/oauth2/authorization/google" class="btn btn-google w-100 py-2 mb-3">
            <img src="https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg" alt="Google" width="20" class="me-2">
            Continuer avec Google
        </a>

        <div class="text-center mt-3">
            <span class="text-muted">Nouveau membre ?</span>
            <a href="/register" class="text-success fw-bold text-decoration-none">Créer un compte</a>
        </div>
    </div>
    <div class="card-footer bg-light text-center py-3">
        <small class="text-muted">&copy; 2026 ESMT - Master ISI</small>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>