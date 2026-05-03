<%@ page pageEncoding="UTF-8" %>
<style>
    :root {
        --sidebar-width: 260px;
        --header-height: 70px;
        --shadow-sm: 0 2px 8px rgba(0,0,0,0.05);
        --shadow-md: 0 4px 12px rgba(0,0,0,0.08);
        --border-color: #e9ecef;
        --bg-light: #f8f9fc;
        --text-main: #1e293b;
        --danger: #dc3545;
        --danger-hover: #b02a37;
    }
    .navbar-custom {
        position: fixed;
        top: 0;
        right: 0;
        width: calc(100% - var(--sidebar-width));
        background: rgba(255, 255, 255, 0.92);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        box-shadow: var(--shadow-sm);
        padding: 0.75rem 0;
        z-index: 1040;
        height: var(--header-height);
        border-bottom: 1px solid var(--border-color);
        transition: all 0.3s ease;
    }
    .navbar-brand-custom {
        font-weight: 700;
        font-size: 1.4rem;
        letter-spacing: 0.5px;
        color: var(--text-main) !important;
    }
    .logo-img {
        height: 42px;
        transition: transform 0.2s;
        border-radius: 50%;
        box-shadow: var(--shadow-sm);
    }
    .logo-img:hover {
        transform: scale(1.05);
    }
    .user-name {
        font-weight: 600;
        font-size: 0.95rem;
        background: var(--bg-light);
        padding: 8px 16px;
        border-radius: 40px;
        color: var(--text-main);
        border: 1px solid var(--border-color);
    }
    .btn-logout {
        border-radius: 40px;
        padding: 6px 18px;
        font-weight: 600;
        transition: all 0.2s;
        background: rgba(220, 53, 69, 0.1);
        color: var(--danger);
        border: 1px solid rgba(220, 53, 69, 0.2);
    }
    .btn-logout:hover {
        background: var(--danger);
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 10px rgba(220, 53, 69, 0.2);
    }
    @media (max-width: 768px) {
        .navbar-custom {
            width: 100%;
            padding-left: 60px; /* espace pour le bouton toggle du sidebar */
        }
        .navbar-brand-custom {
            font-size: 1.1rem;
        }
        .logo-img {
            height: 35px;
        }
        .user-name {
            display: none !important;
        }
        .btn-logout {
            padding: 4px 12px;
            font-size: 0.85rem;
        }
    }
    /* Petit ajustement pour que le contenu ne soit pas caché sous le header fixe */
    body {
        padding-top: var(--header-height);
    }
    .main-content {
        margin-top: 0; /* déjà décalé par le body padding */
    }
    @media (min-width: 769px) {
        body {
            padding-top: var(--header-height);
        }
    }
</style>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <div class="d-flex align-items-center">
            <img src="${pageContext.request.contextPath}/images/logo-ucad.jpeg" alt="UCAD" class="logo-img me-3">
            <span class="navbar-brand navbar-brand-custom">Cartographie EDMI</span>
        </div>
        <div class="d-flex align-items-center gap-3">
            <span class="user-name d-none d-md-inline-block">
                <i class="fas fa-user-circle me-1"></i> ${pageContext.request.userPrincipal.name}
            </span>
            <a href="/logout" class="btn btn-logout">
                <i class="fas fa-sign-out-alt me-1"></i> Déconnexion
            </a>
        </div>
    </div>
</nav>