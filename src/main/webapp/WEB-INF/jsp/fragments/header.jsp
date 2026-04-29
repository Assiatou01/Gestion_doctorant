<%@ page pageEncoding="UTF-8" %>
<style>
    .navbar-custom {
        background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        padding: 0.75rem 0;
        border-radius: 0 0 20px 20px;
    }
    .navbar-brand-custom { font-weight: 700; font-size: 1.4rem; letter-spacing: 0.5px; }
    .logo-img { height: 48px; transition: transform 0.2s; }
    .logo-img:hover { transform: scale(1.03); }
    .user-name { font-weight: 500; font-size: 0.95rem; background: rgba(255,255,255,0.15); padding: 6px 14px; border-radius: 40px; backdrop-filter: blur(2px); }
    .btn-logout { border-radius: 40px; padding: 5px 16px; font-weight: 500; transition: all 0.2s; }
    .btn-logout:hover { background: white; color: #0d6efd; transform: translateY(-2px); }
    @media (max-width: 576px) {
        .navbar-brand-custom { font-size: 1rem; }
        .logo-img { height: 35px; }
        .user-name { font-size: 0.8rem; padding: 4px 10px; }
        .btn-logout { padding: 4px 12px; font-size: 0.8rem; }
    }
</style>
<nav class="navbar navbar-expand-lg navbar-custom mb-4">
    <div class="container">
        <div class="d-flex align-items-center">
            <img src="${pageContext.request.contextPath}/images/logo-ucad.jpeg" alt="UCAD" class="logo-img me-3">
            <span class="navbar-brand text-white navbar-brand-custom">Cartographie EDMI</span>
        </div>
        <div class="d-flex align-items-center gap-3">
            <span class="user-name text-white d-none d-md-inline-block">
                <i class="fas fa-user-circle me-1"></i> ${pageContext.request.userPrincipal.name}
            </span>
            <a href="/logout" class="btn btn-outline-light btn-logout">
                <i class="fas fa-sign-out-alt me-1"></i> Déconnexion
            </a>
        </div>
    </div>
</nav>