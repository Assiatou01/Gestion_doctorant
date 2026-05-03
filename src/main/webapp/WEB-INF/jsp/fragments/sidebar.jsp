<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .sidebar { width: 260px; position: fixed; top: 0; left: 0; height: 100vh; background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%); color: white; z-index: 1000; transition: all 0.3s; box-shadow: 2px 0 10px rgba(0,0,0,0.1); }
    .sidebar .nav-link { color: rgba(255,255,255,0.85); padding: 12px 20px; border-radius: 30px; margin: 5px 10px; transition: all 0.2s; }
    .sidebar .nav-link:hover { background: rgba(255,255,255,0.2); transform: translateX(5px); }
    .sidebar .nav-link.active { background: white; color: #0d6efd; font-weight: 600; }
    .sidebar .nav-link i { width: 28px; margin-right: 10px; }
    .sidebar .brand { padding: 25px 20px; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.1); margin-bottom: 20px; }
    .sidebar .brand img { height: 55px; margin-bottom: 10px; }
    .sidebar .brand span { font-size: 1.2rem; font-weight: 600; display: block; }
    .main-content { margin-left: 260px; padding: 20px 30px; transition: all 0.3s; }
    @media (max-width: 768px) {
        .sidebar { transform: translateX(-100%); width: 240px; }
        .main-content { margin-left: 260px; padding: 20px 30px; padding-top: 90px; transition: all 0.3s; }
        .sidebar.active { transform: translateX(0); }
        .toggle-btn { display: block; position: fixed; top: 15px; left: 15px; z-index: 1100; background: #0d6efd; color: white; border: none; border-radius: 8px; padding: 8px 12px; }
    }
    .toggle-btn { display: none; }
</style>

<button class="toggle-btn" id="sidebarToggle"><i class="fas fa-bars"></i></button>

<div class="sidebar" id="sidebar">
    <div class="brand">
        <img src="${pageContext.request.contextPath}/images/logo-ucad.jpeg" alt="UCAD">
        <span>Cartographie EDMI</span>
    </div>
    <nav class="nav flex-column">
        <!-- Utilisation unique de la variable de session -->
        <c:if test="${sessionScope.isCandidat}">
            <!-- MENU CANDIDAT : SEULEMENT CES 3 LIENS -->
            <a class="nav-link" href="/doctorant/mes-theses"><i class="fas fa-book-open"></i> Mes thèses</a>
            <a class="nav-link" href="/doctorant/details/${sessionScope.user.doctorant.id}"><i class="fas fa-user"></i> Mon profil</a>
            <hr class="bg-white opacity-25 my-2">
            <a class="nav-link" href="/logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </c:if>
        <c:if test="${not sessionScope.isCandidat}">
            <!-- MENU GESTIONNAIRE / ADMIN -->
            <a class="nav-link" href="/dashboard"><i class="fas fa-tachometer-alt"></i> Tableau de bord</a>
            <a class="nav-link" href="/doctorants"><i class="fas fa-users"></i> Doctorants</a>
            <a class="nav-link" href="/theses"><i class="fas fa-book-open"></i> Thèses</a>
            <a class="nav-link" href="/statistiques"><i class="fas fa-chart-line"></i> Statistiques</a>
            <c:if test="${sessionScope.user.role.name() == 'ADMINISTRATEUR'}">
                <a class="nav-link" href="/admin/domaines"><i class="fas fa-tags"></i> Domaines</a>
                <a class="nav-link" href="/admin/utilisateurs"><i class="fas fa-users-cog"></i> Utilisateurs</a>
            </c:if>
            <hr class="bg-white opacity-25 my-2">
            <a class="nav-link" href="/logout"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </c:if>
    </nav>
</div>

<script>
    const toggleBtn = document.getElementById('sidebarToggle');
    const sidebar = document.getElementById('sidebar');
    if (toggleBtn) toggleBtn.addEventListener('click', () => sidebar.classList.toggle('active'));
</script>