<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Formulaire Thèse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="fragments/styles.jsp" />
    <style>
        .card-form { border: none; border-radius: 1rem; box-shadow: 0 1px 2px rgba(0,0,0,0.03); }
        .form-control, .form-select { border-radius: 0.5rem; }
        .btn-custom { border-radius: 2rem; padding: 0.4rem 1.2rem; }
    </style>
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container py-4">
        <div class="card card-form">
            <div class="card-header bg-white border-bottom py-3">
                <h4 class="mb-0"><i class="fas fa-file-alt me-2 text-primary"></i>${these.id == null ? 'Déclarer une thèse' : 'Modifier la thèse'}</h4>
            </div>
            <div class="card-body p-4">
                <c:choose>
                    <c:when test="${candidatId != null}">
                        <form action="/these/candidat/save" method="post">
                            <input type="hidden" name="id" value="${these.id}">
                            <input type="hidden" name="candidatId" value="${candidatId}">
                            <div class="mb-3"><label class="form-label fw-semibold">Intitulé</label><textarea name="intitule" class="form-control" rows="3" required>${these.intitule}</textarea></div>
                            <div class="mb-3"><label class="form-label fw-semibold">Secteur</label><input name="secteur" class="form-control" value="${these.secteur}"></div>
                            <div class="mb-3"><label class="form-label fw-semibold">Problématique</label><textarea name="problematique" class="form-control" rows="4">${these.problematique}</textarea></div>
                            <div class="mb-3"><label class="form-label fw-semibold">Solution proposée</label><textarea name="solution" class="form-control" rows="4">${these.solution}</textarea></div>
                            <div class="mb-3"><label class="form-label fw-semibold">Impact attendu</label><textarea name="impact" class="form-control" rows="3">${these.impact}</textarea></div>
                            <div class="text-center mt-4">
                                <button type="submit" class="btn btn-primary btn-custom"><i class="fas fa-save me-2"></i> Enregistrer</button>
                                <a href="/doctorant/mes-theses" class="btn btn-secondary btn-custom"><i class="fas fa-times me-2"></i> Annuler</a>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <form action="/these/save" method="post">
                            <input type="hidden" name="id" value="${these.id}">
                            <div class="mb-3"><label class="form-label fw-semibold">Intitulé</label><textarea name="intitule" class="form-control" rows="3" required>${these.intitule}</textarea></div>
                            <div class="mb-3"><label class="form-label fw-semibold">Secteur</label><input name="secteur" class="form-control" value="${these.secteur}"></div>
                            <div class="mb-3"><label class="form-label fw-semibold">Problématique</label><textarea name="problematique" class="form-control" rows="4">${these.problematique}</textarea></div>
                            <div class="mb-3"><label class="form-label fw-semibold">Solution proposée</label><textarea name="solution" class="form-control" rows="4">${these.solution}</textarea></div>
                            <div class="mb-3"><label class="form-label fw-semibold">Impact attendu</label><textarea name="impact" class="form-control" rows="3">${these.impact}</textarea></div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Assigner à un doctorant</label>
                                <select name="doctorantId" class="form-select">
                                    <option value="">-- Sélectionner --</option>
                                    <c:forEach items="${doctorants}" var="d"><option value="${d.id}">${d.firstName} ${d.lastName}</option></c:forEach>
                                </select>
                            </div>
                            <div class="text-center mt-4">
                                <button type="submit" class="btn btn-primary btn-custom"><i class="fas fa-save me-2"></i> Enregistrer</button>
                                <a href="/theses" class="btn btn-secondary btn-custom"><i class="fas fa-times me-2"></i> Annuler</a>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>