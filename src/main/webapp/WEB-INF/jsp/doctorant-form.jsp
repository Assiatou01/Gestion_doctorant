<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <title>Formulaire Doctorant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-5">
<div class="container">
    <div class="card shadow">
        <div class="card-header bg-dark text-white">
            <h4 class="mb-0">Fiche Complète du Doctorant</h4>
        </div>
        <div class="card-body">
            <form action="/doctorant/save" method="post">
                <input type="hidden" name="id" value="${doctorant.id}" />

                <h5 class="text-primary border-bottom pb-2 mt-2">1. État Civil</h5>
                <div class="row mb-3">
                    <div class="col-md-6"><label>Nom</label>
                        <input type="text" name="lastName" class="form-control" value="${doctorant.lastName}" required/>
                    </div>
                    <div class="col-md-6"><label>Prénom</label>
                        <input type="text" name="firstName" class="form-control" value="${doctorant.firstName}" required/>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6"><label>Email</label>
                        <input type="email" name="email" class="form-control" value="${doctorant.email}"/>
                    </div>
                    <div class="col-md-6"><label>Téléphone</label>
                        <input type="text" name="telephone" class="form-control" value="${doctorant.telephone}"/>
                    </div>
                </div>

                <h5 class="text-primary border-bottom pb-2 mt-4">2. Parcours Académique</h5>
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label>Faculté de rattachement</label>
                        <select name="faculte.id" class="form-select">
                            <option value="">-- Choisir --</option>
                            <c:forEach items="${facultes}" var="fac">
                                <option value="${fac.id}" ${doctorant.faculte != null && doctorant.faculte.id == fac.id ? 'selected' : ''}>${fac.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label>Laboratoire de recherche</label>
                        <select name="laboratoire.id" class="form-select">
                            <option value="">-- Choisir --</option>
                            <c:forEach items="${laboratoires}" var="lab">
                                <option value="${lab.id}" ${doctorant.laboratoire != null && doctorant.laboratoire.id == lab.id ? 'selected' : ''}>${lab.nom}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label>Niveau / Maturation</label>
                        <input type="text" name="maturation" class="form-control" value="${doctorant.maturation}"/>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label>Date de Début (Thèse)</label>
                        <input type="date" name="dateStart" class="form-control" value="${doctorant.dateStart}"/>
                    </div>
                    <div class="col-md-6">
                        <label>Date de Fin (Thèse)</label>
                        <input type="date" name="dateEnd" class="form-control" value="${doctorant.dateEnd}"/>
                    </div>
                </div>

                <h5 class="text-primary border-bottom pb-2 mt-4">3. Informations Métier & Carrière</h5>
                <div class="row mb-3">
                    <div class="col-12">
                        <label>Centres d'intérêt</label>
                        <textarea name="interet" class="form-control" rows="2">${doctorant.interet}</textarea>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-12">
                        <label>Souhait d'insertion</label>
                        <textarea name="souhait" class="form-control" rows="2">${doctorant.souhait}</textarea>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-8">
                        <label>Lien CV / Drive</label>
                        <input type="text" name="cv" class="form-control" value="${doctorant.cv}"/>
                    </div>
                    <div class="col-md-4 mt-4">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="publicationFaire" id="publiCheck" ${doctorant.publicationFaire ? 'checked' : ''}>
                            <label class="form-check-label" for="publiCheck">
                                A des publications à son actif
                            </label>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <button type="submit" class="btn btn-success px-5">Enregistrer le profil</button>
                    <a href="/doctorants" class="btn btn-secondary px-5">Annuler</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
