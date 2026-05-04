<%@ page pageEncoding="UTF-8" %>
<style>
    :root {
        --header-height: 64px;
        --shadow-sm: 0 2px 8px rgba(0,0,0,0.03), 0 1px 2px rgba(0,0,0,0.05);
        --border-color: #f0f0f0;
        --danger: #e3342f;
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
        margin-right: auto; /* pousse les éléments à droite */
        display: flex;
        align-items: center;
    }
    .logo-img {
        height: 38px;
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
        gap: 10px;
        padding: 8px 16px;
        border-radius: 40px;
        font-weight: 500;
        font-size: 0.85rem;
        color: #4a5568;
        text-decoration: none;
        transition: all 0.2s;
        cursor: pointer;
    }
    .logout-btn i {
        font-size: 1rem;
        color: #e53e3e;
    }
    .logout-btn:hover {
        background: #fff5f5;
        color: #e53e3e;
    }
    .logout-btn:hover i {
        color: #e53e3e;
    }

    @media (max-width: 768px) {
        .navbar-custom {
            left: 0;
            padding: 0 1rem;
        }
        .logo-img {
            height: 32px;
        }
        .logout-btn span {
            display: none; /* sur mobile, cacher le texte "Déconnexion", ne garder que l'icône */
        }
        .logout-btn {
            padding: 6px 12px;
        }
    }
</style>

<nav class="navbar-custom">
    <div class="logo-wrapper">
        <img src="${pageContext.request.contextPath}/images/blason-ucad.png" alt="UCAD" class="logo-img"
             onerror="this.src='https://via.placeholder.com/38?text=UCAD'">
    </div>
    <a href="/logout" class="logout-btn">
        <i class="fas fa-sign-out-alt"></i>
        <span>Déconnexion</span>
    </a>
</nav>