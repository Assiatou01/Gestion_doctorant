<%@ page pageEncoding="UTF-8" %>
<style>
    :root {
        --header-height: 80px;   /* augmenté de 70px à 80px */
        --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
        --border-color: #e9ecef;
        --danger: #dc3545;
    }
    .navbar-custom {
        position: fixed;
        top: 0;
        right: 0;
        left: 280px;
        background: white;
        box-shadow: var(--shadow-sm);
        padding: 0 2rem;
        z-index: 1040;
        height: var(--header-height);
        border-bottom: 1px solid var(--border-color);
        display: flex;
        align-items: center;
        justify-content: flex-end;
        transition: left 0.3s ease;
    }
    .logo-wrapper {
        margin-right: auto;
        display: flex;
        align-items: center;
    }
    .logo-img {
        height: 48px;   /* augmenté de 42px à 48px */
        width: auto;
        object-fit: contain;
        transition: transform 0.2s;
    }
    .logo-img:hover {
        transform: scale(1.02);
    }
    .logout-btn {
        background: transparent;
        border: none;
        display: flex;
        align-items: center;
        padding: 8px 12px;
        border-radius: 40px;
        color: #1e293b;
        text-decoration: none;
        transition: all 0.2s;
        cursor: pointer;
        font-size: 1.2rem;
    }
    .logout-btn i {
        color: #0d6efd;
    }
    .logout-btn:hover {
        background: #f8f9fc;
    }
    .logout-btn:hover i {
        color: #0b5ed7;
    }
    @media (max-width: 768px) {
        .navbar-custom {
            left: 0;
            padding: 0 1rem;
        }
        .logo-img {
            height: 40px;   /* adapté pour mobile */
        }
    }
</style>

<nav class="navbar-custom">
    <div class="logo-wrapper">
        <img src="${pageContext.request.contextPath}/images/blason-ucad.png" alt="UCAD" class="logo-img"
             onerror="this.src='https://via.placeholder.com/48?text=UCAD'">
    </div>
    <a href="/logout" class="logout-btn" title="Déconnexion">
        <i class="fas fa-sign-out-alt"></i>
    </a>
</nav>