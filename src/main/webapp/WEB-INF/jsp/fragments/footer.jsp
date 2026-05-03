<%@ page pageEncoding="UTF-8" %>
<style>
    /* Footer fixe en bas */
    .footer-custom {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        background: #ffffff;
        border-top: 1px solid #e9ecef;
        padding: 1rem 0;
        box-shadow: 0 -2px 10px rgba(0,0,0,0.05);
        z-index: 1030;
    }
    /* Ajout d’un padding-bottom au body pour que le contenu ne soit pas masqué par le footer */
    body {
        padding-bottom: 80px; /* Hauteur approximative du footer */
    }
    /* Ajustement pour sidebar fixe (si nécessaire) */
    .sidebar {
        z-index: 1040;
    }
    .footer-custom .blason-img {
        height: 45px;
        opacity: 0.75;
        transition: all 0.2s ease-in-out;
        filter: drop-shadow(0 2px 4px rgba(0,0,0,0.05));
    }
    .footer-custom .blason-img:hover {
        opacity: 1;
        transform: scale(1.02);
    }
    .footer-custom .footer-text {
        font-size: 0.8rem;
        color: #6c757d;
        letter-spacing: 0.3px;
    }
    .footer-custom .footer-divider {
        width: 60px;
        height: 2px;
        background: #0d6efd;
        margin: 8px auto;
        opacity: 0.5;
        border-radius: 2px;
    }
    @media (max-width: 768px) {
        .footer-custom .blason-img { height: 35px; }
        .footer-custom .footer-text { font-size: 0.7rem; }
        .footer-custom { padding: 0.75rem 0; }
        body { padding-bottom: 70px; }
    }
</style>

<footer class="footer-custom">
    <div class="container">
        <div class="text-center">
            <img src="${pageContext.request.contextPath}/images/blason-ucad.jpeg" alt="Blason UCAD" class="blason-img mb-1">
            <div class="footer-divider"></div>
            <div class="footer-text">
                <i class="fas fa-copyright me-1"></i> 2026 ESMT - Master ISI | Plateforme de Cartographie EDMI
            </div>
        </div>
    </div>
</footer>