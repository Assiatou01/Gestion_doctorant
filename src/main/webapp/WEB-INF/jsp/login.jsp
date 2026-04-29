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
        *{margin:0;padding:0;box-sizing:border-box;}
        body{background:linear-gradient(135deg,#e9f0ff 0%,#d4e0f5 100%);height:100vh;width:100vw;display:flex;align-items:center;justify-content:center;overflow:hidden;font-family:'Segoe UI',system-ui,sans-serif;}
        .login-card{max-width:380px;width:90%;background:white;border-radius:1.5rem;box-shadow:0 15px 30px rgba(0,0,0,0.1);overflow:hidden;}
        .login-header{background:linear-gradient(135deg,#0d6efd 0%,#0b5ed7 100%);color:white;text-align:center;padding:1.2rem 1rem;}
        .login-header img{height:65px;margin-bottom:0.5rem;}
        .login-header h3{font-weight:700;font-size:1.3rem;margin-bottom:0.2rem;}
        .login-header p{font-size:0.75rem;opacity:0.9;margin-bottom:0;}
        .card-body{padding:1.5rem;}
        .form-control{border-radius:2rem;padding:0.5rem 1rem;border:1px solid #e2e8f0;font-size:0.9rem;}
        .form-control:focus{border-color:#0d6efd;box-shadow:0 0 0 3px rgba(13,110,253,0.15);}
        .input-group-text{background:white;border-right:none;border-radius:2rem 0 0 2rem;color:#0d6efd;padding-left:1rem;padding-right:0.5rem;}
        .input-group .form-control{border-left:none;border-radius:0 2rem 2rem 0;}
        .btn-login{background:linear-gradient(135deg,#0d6efd,#0b5ed7);border:none;border-radius:2rem;padding:0.55rem;font-weight:600;font-size:0.9rem;transition:all 0.2s;}
        .btn-login:hover{transform:translateY(-2px);box-shadow:0 5px 12px rgba(13,110,253,0.3);}
        .btn-google{border-radius:2rem;padding:0.55rem;border:1px solid #dadce0;background:white;color:#3c4043;font-weight:500;font-size:0.9rem;display:flex;align-items:center;justify-content:center;gap:8px;}
        .btn-google:hover{background:#f8f9fa;}
        .divider{display:flex;align-items:center;margin:1rem 0;color:#9aa4b2;font-size:0.75rem;}
        .divider::before,.divider::after{content:"";flex:1;border-bottom:1px solid #e2e8f0;}
        .divider::before{margin-right:1rem;}
        .divider::after{margin-left:1rem;}
        .register-link{text-align:center;margin-top:1rem;font-size:0.85rem;}
        .alert{border-radius:2rem;font-size:0.8rem;padding:0.5rem 1rem;}
        @media (max-width:480px){.login-card{max-width:330px;}.login-header img{height:55px;}.card-body{padding:1.2rem;}}
    </style>
</head>
<body>
<div class="login-card">
    <div class="login-header">
        <img src="${pageContext.request.contextPath}/images/logo-ucad.jpeg" alt="UCAD">
        <h3>Cartographie EDMI</h3>
        <p>École Doctorale Mathématiques et Informatique</p>
    </div>
    <div class="card-body">
        <c:if test="${param.error != null}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i> Identifiants incorrects ou accès refusé.</div></c:if>
        <c:if test="${param.logout != null}"><div class="alert alert-info"><i class="fas fa-sign-out-alt me-2"></i> Déconnexion réussie.</div></c:if>
        <c:if test="${param.registered != null}"><div class="alert alert-success"><i class="fas fa-user-check me-2"></i> Inscription réussie ! Connectez-vous.</div></c:if>

        <form action="/perform_login" method="post">
            <div class="mb-3">
                <label class="form-label fw-semibold">Adresse email</label>
                <div class="input-group"><span class="input-group-text"><i class="fas fa-envelope"></i></span><input type="email" name="username" class="form-control" placeholder="exemple@esmt.sn" required></div>
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold">Mot de passe</label>
                <div class="input-group"><span class="input-group-text"><i class="fas fa-lock"></i></span><input type="password" name="password" class="form-control" placeholder="••••••••" required></div>
            </div>
            <button type="submit" class="btn btn-login w-100 text-white"><i class="fas fa-sign-in-alt me-2"></i> Se connecter</button>
        </form>

        <div class="divider">OU</div>

        <a href="/oauth2/authorization/google" class="btn btn-google w-100">
            <i class="fab fa-google me-2"></i> Continuer avec Google
        </a>

        <div class="register-link"><span class="text-muted">Nouveau membre ?</span> <a href="/register" class="text-primary fw-bold text-decoration-none"> Créer un compte</a></div>
    </div>
    <div class="text-center pb-3 small text-muted border-top pt-2 mx-3">ESMT – Master ISI</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>