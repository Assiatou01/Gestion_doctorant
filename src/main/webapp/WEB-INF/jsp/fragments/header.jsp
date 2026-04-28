<%@ page pageEncoding="UTF-8" %>
<nav class="navbar navbar-expand-lg mb-4 shadow-sm" style="background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);">
    <div class="container">
        <div class="d-flex align-items-center">
            <img src="${pageContext.request.contextPath}/images/logo-ucad.jpeg" alt="UCAD" style="height: 45px; margin-right: 12px;">
            <span class="navbar-brand text-white fw-bold">Cartographie EDMI</span>
        </div>
        <div>
            <span class="text-white me-3"><i class="fas fa-user-circle"></i> ${pageContext.request.userPrincipal.name}</span>
            <a href="/logout" class="btn btn-outline-light btn-sm rounded-pill px-3">Déconnexion</a>
        </div>
    </div>
</nav>