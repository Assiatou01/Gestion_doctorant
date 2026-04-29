<%@ page pageEncoding="UTF-8" %>
<style>
    .footer-custom {
        background: #ffffff;
        border-top: 1px solid #e9ecef;
        padding: 1.5rem 0;
        margin-top: 3rem;
        width: 100%;
    }
    .footer-custom .blason-img {
        height: 50px;
        opacity: 0.7;
        transition: opacity 0.2s;
    }
    .footer-custom .blason-img:hover {
        opacity: 1;
    }
    .footer-custom .footer-text {
        font-size: 0.8rem;
        color: #6c757d;
    }
    .footer-custom .footer-divider {
        width: 50px;
        height: 2px;
        background: #0d6efd;
        margin: 10px auto;
        opacity: 0.4;
    }
    @media (max-width: 768px) {
        .footer-custom .blason-img { height: 40px; }
        .footer-custom .footer-text { font-size: 0.7rem; }
    }
</style>
<footer class="footer-custom">
    <div class="container">
        <div class="text-center">
            <img src="${pageContext.request.contextPath}/images/blason-ucad.jpeg" alt="Blason UCAD" class="blason-img mb-2">
            <div class="footer-text">
                <strong>UNIVERSITÉ CHEIKH ANTA DIOP DE DAKAR</strong><br>
                EDMI - École doctorale de Mathématiques et Informatique
            </div>
            <div class="footer-divider"></div>
            <div class="footer-text">
                <i class="fas fa-copyright me-1"></i> 2026 ESMT - Master ISI | Plateforme de Cartographie EDMI
            </div>
        </div>
    </div>
</footer>