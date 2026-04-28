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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            background: linear-gradient(135deg, #e9f0ff 0%, #d4e0f5 100%);
            height: 100vh;
            width: 100vw;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;  /* ← pas de défilement */
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        .login-card {
            max-width: 450px;
            width: 90%;
            background: white;
            border-radius: 2rem;
            box-shadow: 0 20px 35px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .login-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
            color: white;
            text-align: center;
            padding: 2rem 1rem;
        }
        .login-header img {
            height: 85px;
            margin-bottom: 1rem;
        }
        .login-header h3 {
            font-weight: 700;
            font-size: 1.75rem;
            margin-bottom: 0.25rem;
        }
        .login-header p {
            opacity: 0.9;
            font-size: 0.9rem;
        }
        .card-body {
            padding: 2rem;
        }
        .form-control {
            border-radius: 3rem;
            padding: 0.75rem 1.25rem;
            border: 1px solid #e2e8f0;
            transition: all 0.2s;
        }
        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 3px rgba(13,110,253,0.15);
        }
        .input-group-text {
            background: white;
            border-right: none;
            border-radius: 3rem 0 0 3rem;
            color: #0d6efd;
            padding-left: 1.2rem;
        }
        .input-group .form-control {
            border-left: none;
            border-radius: 0 3rem 3rem 0;
        }
        .btn-login {
            background: linear-gradient(135deg, #0d6efd, #0b5ed7);
            border: none;
            border-radius: 3rem;
            padding: 0.75rem;
            font-weight: 600;
            font-size: 1rem;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 12px rgba(13,110,253,0.3);
        }
        .btn-google {
            border-radius: 3rem;
            padding: 0.7rem;
            border: 1px solid #dadce0;
            background: white;
            color: #3c4043;
            font-weight: 500;
            transition: background 0.2s;
        }
        .btn-google:hover {
            background: #f8f9fa;
        }
        .divider {
            display: flex;
            align-items: center;
            margin: 1.5rem 0;
            color: #9aa4b2;
            font-size: 0.85rem;
        }
        .divider::before, .divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px solid #e2e8f0;
        }
        .divider::before { margin-right: 1rem; }
        .divider::after { margin-left: 1rem; }
        .register-link {
            text-align: center;
            margin-top: 1.2rem;
        }
        .alert {
            border-radius: 3rem;
            font-size: 0.9rem;
            padding: 0.7rem 1rem;
        }
    </style>
</head>
<body>
<div class="login-card">
    <div class="login-header">
        <img src="${pageContext.request.contextPath}/images/logo-ucad.jpeg" alt="UCAD - Université Cheikh Anta Diop">
        <h3>Cartographie EDMI</h3>
        <p>École Doctorale Mathématiques et Informatique</p>
    </div>
    <div class="card-body">
        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i> Identifiants incorrects ou accès refusé.
            </div>
        </c:if>
        <c:if test="${param.logout != null}">
            <div class="alert alert-info">
                <i class="fas fa-sign-out-alt me-2"></i> Déconnexion réussie.
            </div>
        </c:if>
        <c:if test="${param.registered != null}">
            <div class="alert alert-success">
                <i class="fas fa-user-check me-2"></i> Inscription réussie ! Connectez-vous.
            </div>
        </c:if>

        <form action="/perform_login" method="post">
            <div class="mb-3">
                <label class="form-label fw-semibold">Adresse email</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                    <input type="email" name="username" class="form-control" placeholder="exemple@esmt.sn" required>
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label fw-semibold">Mot de passe</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
            </div>
            <button type="submit" class="btn btn-login w-100 text-white">
                <i class="fas fa-sign-in-alt me-2"></i> Se connecter
            </button>
        </form>

        <div class="divider">OU</div>

        <a href="/oauth2/authorization/google" class="btn btn-google w-100">
            <img src="https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg" width="20" class="me-2">
            Continuer avec Google
        </a>

        <div class="register-link">
            <span class="text-muted">Nouveau membre ?</span>
            <a href="/register" class="text-primary fw-bold text-decoration-none"> Créer un compte</a>
        </div>
    </div>
    <div class="text-center pb-3 small text-muted">
        <hr class="mx-4 my-2" style="opacity:0.3;">
        ESMT – Master ISI
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>