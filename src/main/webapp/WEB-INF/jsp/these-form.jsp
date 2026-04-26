<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Formulaire Thèse</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">${these.id == null ? 'Ajouter une Thèse' : 'Modifier la Thèse'}</h4>
        </div>
        <div class="card-body">
            <form action="/these/save" method="post">
                <input type="hidden" name="id" value="${these.id}"/>

                <div class="mb-3">
                    <label class="form-label">Intitulé de la thèse</label>
                    <textarea name="intitule" class="form-control" rows="2" required>${these.intitule}</textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Secteur</label>
                        <input type="text" name="secteur" class="form-control" value="${these.secteur}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Problématique</label>
                    <textarea name="problematique" class="form-control" rows="4">${these.problematique}</textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Solution proposée</label>
                    <textarea name="solution" class="form-control" rows="4">${these.solution}</textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Impact attendu</label>
                    <textarea name="impact" class="form-control" rows="3">${these.impact}</textarea>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                    <a href="/theses" class="btn btn-secondary">Annuler</a>
                </div>
                <div class="mb-3">
                    <label class="form-label">Assigner à un Doctorant (Optionnel)</label>
                    <select name="doctorantId" class="form-select">
                        <option value="">-- Sélectionner un doctorant --</option>
                        <c:forEach items="${doctorants}" var="d">
                            <option value="${d.id}">${d.firstName} ${d.lastName}</option>
                        </c:forEach>
                    </select>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>