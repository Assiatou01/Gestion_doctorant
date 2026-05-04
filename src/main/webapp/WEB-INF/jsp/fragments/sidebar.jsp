<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    /* ----- SIDEBAR STYLE PRO (fond légèrement adouci, cercle avec bordure) ----- */
    .sidebar {
        width: 280px;
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        background: #fafcff;  /* blanc très légèrement adouci (plus pro) */
        color: #1e293b;
        z-index: 1000;
        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        /* Ombre bleutée extérieure conservée */
        box-shadow: 6px 0 24px rgba(13, 110, 253, 0.08), 2px 0 6px rgba(0, 0, 0, 0.03);
        border-right: none;
        font-family: 'Inter', system-ui, -apple-system, sans-serif;
        display: flex;
        flex-direction: column;
    }

    /* Brand */
    .sidebar .brand {
        padding: 32px 24px 24px 24px;
        text-align: center;
        border-bottom: 1px solid #eef2f5;
        margin-bottom: 24px;
    }
    /* Logo dans un cercle avec BORDURE (plus d’ombre) */
    .sidebar .brand .logo-circle {
        width: 90px;
        height: 90px;
        margin: 0 auto 12px auto;
        background: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2px solid #e2e8f0;   /* bordure fine au lieu de l’ombre */
        transition: transform 0.2s;
    }
    .sidebar .brand .logo-circle:hover {
        transform: scale(1.02);
        border-color: #cbd5e1;
    }
    .sidebar .brand img {
        width: 65px;
        height: 65px;
        object-fit: contain;
        border-radius: 50%;
    }
    .sidebar .brand span {
        display: block;
        font-size: 1.25rem;
        font-weight: 700;
        color: #0d6efd;
        margin-top: 12px;
        letter-spacing: -0.3px;
    }

    /* Navigation */
    .sidebar .nav {
        flex: 1;
        padding: 0 12px;
    }
    .sidebar .nav-link {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 12px 18px;
        margin: 6px 0;
        border-radius: 14px;
        color: #4b5563;
        font-weight: 500;
        font-size: 0.95rem;
        transition: all 0.2s ease;
        background: transparent;
        text-decoration: none;
    }
    .sidebar .nav-link i {
        width: 24px;
        font-size: 1.2rem;
        color: #9ca3af;
        transition: color 0.2s;
    }
    .sidebar .nav-link:hover {
        background: #eef2ff;
        color: #0d6efd;
        transform: translateX(4px);
    }
    .sidebar .nav-link:hover i {
        color: #0d6efd;
    }
    .sidebar .nav-link.active {
        background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
        color: white;
        box-shadow: 0 4px 10px rgba(13, 110, 253, 0.2);
    }
    .sidebar .nav-link.active i {
        color: white;
    }

    /* Séparateur */
    .sidebar hr {
        border: none;
        border-top: 1px solid #eef2f5;
        margin: 16px 18px;
    }

    /* Pied de sidebar */
    .sidebar-footer {
        padding: 20px 24px;
        font-size: 0.7rem;
        color: #9ca3af;
        text-align: center;
        border-top: 1px solid #eef2f5;
        margin-top: auto;
    }

    /* Main content */
    .main-content {
        margin-left: 280px;
        padding: 24px 32px;
        transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    /* Bouton hamburger */
    .toggle-btn {
        display: none;
        position: fixed;
        top: 20px;
        left: 20px;
        z-index: 1100;
        background: #ffffff;
        color: #0d6efd;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 10px 12px;
        font-size: 1.2rem;
        cursor: pointer;
        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        transition: all 0.2s;
    }
    .toggle-btn:hover {
        background: #f8fafc;
        transform: scale(0.98);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
            width: 280px;
            box-shadow: 2px 0 20px rgba(13, 110, 253, 0.1);
        }
        .sidebar.active {
            transform: translateX(0);
        }
        .main-content {
            margin-left: 0 !important;
            padding: 20px;
        }
        .toggle-btn {
            display: block;
        }
        .sidebar .brand .logo-circle {
            width: 75px;
            height: 75px;
        }
        .sidebar .brand img {
            width: 55px;
            height: 55px;
        }
    }

    /* Scrollbar élégante */
    .sidebar::-webkit-scrollbar {
        width: 5px;
    }
    .sidebar::-webkit-scrollbar-track {
        background: #f1f1f1;
    }
    .sidebar::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 10px;
    }
</style>

<button class="toggle-btn" id="sidebarToggle">
    <i class="fas fa-bars"></i>
</button>

<div class="sidebar" id="sidebar">
    <div class="brand">
        <div class="logo-circle">
            <img src="${pageContext.request.contextPath}/images/logo-ucad.png" alt="UCAD">
        </div>
        <span>Cartographie EDMI</span>
    </div>
    <nav class="nav flex-column">
        <c:if test="${sessionScope.isCandidat}">
            <a class="nav-link" href="/doctorant/mes-theses">
                <i class="fas fa-book-open"></i> Mes thèses
            </a>
            <a class="nav-link" href="/doctorant/details/${sessionScope.user.doctorant.id}">
                <i class="fas fa-user"></i> Mon profil
            </a>
            <hr>
            <a class="nav-link" href="/logout">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </c:if>
        <c:if test="${not sessionScope.isCandidat}">
            <a class="nav-link" href="/dashboard">
                <i class="fas fa-tachometer-alt"></i> Tableau de bord
            </a>
            <a class="nav-link" href="/doctorants">
                <i class="fas fa-users"></i> Doctorants
            </a>
            <a class="nav-link" href="/theses">
                <i class="fas fa-book-open"></i> Thèses
            </a>
            <a class="nav-link" href="/statistiques">
                <i class="fas fa-chart-line"></i> Statistiques
            </a>
            <c:if test="${sessionScope.user.role.name() == 'ADMINISTRATEUR'}">
                <a class="nav-link" href="/admin/domaines">
                    <i class="fas fa-tags"></i> Domaines
                </a>
                <a class="nav-link" href="/admin/utilisateurs">
                    <i class="fas fa-users-cog"></i> Utilisateurs
                </a>
            </c:if>
            <hr>
            <a class="nav-link" href="/logout">
                <i class="fas fa-sign-out-alt"></i> Déconnexion
            </a>
        </c:if>
    </nav>
    <div class="sidebar-footer">
        <i class="fas fa-graduation-cap"></i> EDMI — UCAD
    </div>
</div>

<script>
    const toggleBtn = document.getElementById('sidebarToggle');
    const sidebar = document.getElementById('sidebar');
    if (toggleBtn) {
        toggleBtn.addEventListener('click', () => {
            sidebar.classList.toggle('active');
        });
    }
</script>