<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Formulaire Doctorant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fc; }
        .card-form { border: none; border-radius: 1.5rem; box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.05); }
        .form-control, .form-select { border-radius: 0.75rem; padding: 0.6rem 1rem; }
        .btn-custom { border-radius: 2rem; padding: 0.5rem 2rem; font-weight: 600; }
        .section-title { border-left: 5px solid #0d6efd; padding-left: 15px; margin: 25px 0 20px 0; }
    </style>
</head>
<body>

<jsp:include page="fragments/header.jsp" />

<div class="container py-4">
    <div class="card card-form shadow-sm">
        <div class="card-header bg-dark text-white rounded-top-4 py-3">
            <h4 class="mb-0"><i class="fas fa-user-edit me-2"></i>Fiche Complète du Doctorant</h4>
        </div>
        <div class="card-body p-4">
            <form action="/doctorant/save" method="post">
                <input type="hidden" name="id" value="${doctorant.id}" />

                <h5 class="section-title text-primary">1. État Civil</h5>
                <div class="row g-3 mb-3">
                    <div class="col-md-6"><label class="form-label fw-semibold">Nom</label><input type="text" name="lastName" class="form-control" value="${doctorant.lastName}" required/></div>
                    <div class="col-md-6"><label class="form-label fw-semibold">Prénom</label><input type="text" name="firstName" class="form-control" value="${doctorant.firstName}" required/></div>
                </div>
                <div class="row g-3 mb-3">
                    <div class="col-md-6"><label class="form-label fw-semibold">Email</label><input type="email" name="email" class="form-control" value="${doctorant.email}"/></div>
                    <div class="col-md-6"><label class="form-label fw-semibold">Téléphone</label><input type="text" name="telephone" class="form-control" value="${doctorant.telephone}"/></div>
                </div>

                <h5 class="section-title text-primary">2. Parcours Académique</h5>
                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Faculté de rattachement</label>
                        <select name="faculte.id" class="form-select">
                            <option value="">-- Choisir --</option>
                            <c:forEach items="${facultes}" var="fac">
                                <option value="${fac.id}" ${doctorant.faculte != null && doctorant.faculte.id == fac.id ? 'selected' : ''}>${fac.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Laboratoire de recherche</label>
                        <select name="laboratoire.id" class="form-select">
                            <option value="">-- Choisir --</option>
                            <c:forEach items="${laboratoires}" var="lab">
                                <option value="${lab.id}" ${doctorant.laboratoire != null && doctorant.laboratoire.id == lab.id ? 'selected' : ''}>${lab.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Niveau / Maturation</label>
                        <input type="text" name="maturation" class="form-control" value="${doctorant.maturation}"/>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6"><label class="form-label fw-semibold">Date de Début (Thèse)</label><input type="date" name="dateStart" class="form-control" value="${doctorant.dateStart}"/></div>
                    <div class="col-md-6"><label class="form-label fw-semibold">Date de Fin (Thèse)</label><input type="date" name="dateEnd" class="form-control" value="${doctorant.dateEnd}"/></div>
                </div>

                <h5 class="section-title text-primary">3. Informations Métier & Carrière</h5>
                <div class="mb-3"><label class="form-label fw-semibold">Centres d'intérêt</label><textarea name="interet" class="form-control" rows="2">${doctorant.interet}</textarea></div>
                <div class="mb-3"><label class="form-label fw-semibold">Souhait d'insertion</label><textarea name="souhait" class="form-control" rows="2">${doctorant.souhait}</textarea></div>

                <div class="row g-3 mb-4">
                    <div class="col-md-8"><label class="form-label fw-semibold">Lien CV / Drive</label><input type="text" name="cv" class="form-control" value="${doctorant.cv}"/></div>
                    <div class="col-md-4 mt-4"><div class="form-check"><input class="form-check-input" type="checkbox" name="publicationFaire" id="publiCheck" ${doctorant.publicationFaire ? 'checked' : ''}><label class="form-check-label" for="publiCheck">A des publications à son actif</label></div></div>
                </div>

                <div class="text-center mt-4">
                    <button type="submit" class="btn btn-success btn-custom px-5"><i class="fas fa-save me-2"></i>Enregistrer</button>
                    <a href="/doctorants" class="btn btn-secondary btn-custom px-5"><i class="fas fa-times me-2"></i>Annuler</a>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>