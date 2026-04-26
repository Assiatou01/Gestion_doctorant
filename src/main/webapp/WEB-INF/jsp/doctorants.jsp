<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des Doctorants</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="/dashboard"><i class="fas fa-microscope"></i> Cartographie EDMI</a>
        <div class="navbar-nav">
            <a class="nav-link" href="/dashboard">Dashboard</a>
            <a class="nav-link active" href="/doctorants">Doctorants</a>
        </div>
    </div>
</nav>

<div class="container-fluid px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-users"></i> Annuaire des Doctorants</h2>
        <a href="/doctorant/nouveau" class="btn btn-success">
            <i class="fas fa-plus-circle"></i> Nouveau Doctorant
        </a>
    </div>

    <div class="card shadow mb-4">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Nom & Prénom</th>
                        <th>Email</th>
                        <th>Laboratoire</th>
                        <th>Faculté</th>
                        <th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listeDoctorants}" var="doc">
                        <tr>
                            <td><strong>${doc.lastName}</strong> ${doc.firstName}</td>
                            <td>${doc.email}</td>
                            <td>${doc.laboratoire != null ? doc.laboratoire.nom : 'Non défini'}</td>
                            <td>${doc.faculte != null ? doc.faculte.nom : 'Non défini'}</td>
                            <td class="text-center">
                                <div class="btn-group">
                                    <a href="/doctorant/details/${doc.id}" class="btn btn-sm btn-info text-white" title="Détails">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="/doctorant/modifier/${doc.id}" class="btn btn-sm btn-warning text-white" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="/doctorant/supprimer/${doc.id}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Supprimer ce doctorant ?');" title="Supprimer">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>