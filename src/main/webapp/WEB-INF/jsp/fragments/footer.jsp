<%@ page pageEncoding="UTF-8" %>
<style>
    .footer-custom {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        background: #ffffff;
        border-top: 1px solid #edf2f7;
        padding: 1rem 0;
        z-index: 1030;
        font-family: 'Inter', system-ui, -apple-system, sans-serif;
        box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.02);
    }
    body {
        padding-bottom: 90px;
    }
    .footer-container {
        max-width: 1280px;
        margin: 0 auto;
        padding: 0 2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }
    .footer-copyright {
        font-size: 0.8rem;
        color: #4a5568;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .footer-copyright i {
        color: #cbd5e0;
        font-size: 0.9rem;
    }
    .footer-links {
        display: flex;
        gap: 1.5rem;
        align-items: center;
        flex-wrap: wrap;
    }
    .footer-links a {
        color: #718096;
        text-decoration: none;
        font-size: 0.8rem;
        transition: color 0.2s;
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
    }
    .footer-links a i {
        font-size: 0.85rem;
    }
    .footer-links a:hover {
        color: #0d6efd;
    }
    @media (max-width: 768px) {
        .footer-container {
            flex-direction: column;
            text-align: center;
            padding: 0 1rem;
        }
        .footer-links {
            justify-content: center;
        }
        body {
            padding-bottom: 110px;
        }
    }
</style>

<footer class="footer-custom">
    <div class="footer-container">
        <div class="footer-copyright">
            <i class="far fa-copyright"></i>
            <span>2026 UCAD – École Doctorale Mathématiques et Informatique</span>
        </div>
        <div class="footer-links">
            <a href="mailto:edmi@ucad.sn">
                <i class="fas fa-envelope"></i> edmi@ucad.sn
            </a>
            <a href="https://ucad.sn" target="_blank" rel="noopener noreferrer">
                <i class="fas fa-globe"></i> ucad.sn
            </a>
            <span style="color:#cbd5e0;">|</span>
            <span style="color:#718096; font-size:0.75rem;">Plateforme de Cartographie Système </span>
        </div>
    </div>
</footer>