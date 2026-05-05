<style>
    :root {
        --header-height: 64px;
        --sidebar-width: 280px;
    }
    body {
        background: #f8f9fc;
        margin: 0;
        padding-bottom: 90px;
    }
    /* Force le padding-top pour que le contenu ne soit pas masqué par le header fixe */
    .main-content {
        margin-left: var(--sidebar-width);
        padding: calc(var(--header-height) + 2rem) 30px 1.5rem 30px !important;
        transition: margin-left 0.3s ease, padding 0.3s ease;
    }
    @media (max-width: 768px) {
        .main-content {
            margin-left: 0 !important;
            padding-top: calc(var(--header-height) + 1.5rem) !important;
        }
    }
    .d-flex.flex-wrap {
        row-gap: 0.5rem;
    }
</style>