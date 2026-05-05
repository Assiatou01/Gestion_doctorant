<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Doctorants</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="fragments/styles.jsp" />
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container-fluid px-4">
        <!-- En-tête avec filtre laboratoire -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <h2 class="text-primary m-0"><i class="fas fa-users me-2"></i>Annuaire des Doctorants</h2>
            <div class="d-flex gap-2">
                <form method="get" action="/doctorants" class="d-flex gap-2">
                    <select name="laboratoireId" class="form-select rounded-pill" onchange="this.form.submit()">
                        <option value="">Tous les laboratoires</option>
                        <c:forEach items="${laboratoires}" var="lab">
                            <option value="${lab.id}" ${selectedLaboratoireId == lab.id ? 'selected' : ''}>${lab.nom}</option>
                        </c:forEach>
                    </select>
                    <a href="/doctorant/nouveau" class="btn btn-primary rounded-pill px-4">
                        <i class="fas fa-plus-circle me-2"></i> Nouveau Doctorant
                    </a>
                </form>
            </div>
        </div>

        <!-- Tableau des doctorants -->
        <div class="card p-2" style="border: none; border-radius: 1rem; box-shadow: 0 1px 2px rgba(0,0,0,0.03);">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="text-uppercase text-muted" style="font-size: 0.75rem;">
                        <tr><th>Nom & Prénom</th><th>Email</th><th>Laboratoire</th><th>Faculté</th><th class="text-center">Actions</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${listeDoctorants}" var="doc">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="d-flex align-items-center justify-content-center me-3 rounded-circle bg-light text-dark fw-bold" style="width: 40px; height: 40px;">
                                                ${fn:substring(doc.firstName, 0, 1)}${fn:substring(doc.lastName, 0, 1)}
                                        </div>
                                        <div><strong>${doc.firstName} ${doc.lastName}</strong></div>
                                    </div>
                                </td>
                                <td>${doc.email}</td>
                                <td><span class="badge bg-light text-dark border">${doc.laboratoire != null ? doc.laboratoire.nom : 'Non défini'}</span></td>
                                <td><span class="badge bg-light text-dark border">${doc.faculte != null ? doc.faculte.nom : 'Non défini'}</span></td>
                                <td class="text-center">
                                    <div class="btn-group" role="group">
                                        <a href="/doctorant/details/${doc.id}" class="btn btn-sm btn-outline-primary" title="Voir"><i class="fas fa-eye"></i></a>
                                        <a href="/doctorant/modifier/${doc.id}" class="btn btn-sm btn-outline-primary" title="Modifier"><i class="fas fa-edit"></i></a>
                                        <a href="/doctorant/supprimer/${doc.id}" class="btn btn-sm btn-outline-secondary" title="Supprimer" onclick="return confirm('Supprimer ce doctorant ?')"><i class="fas fa-trash"></i></a>
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
</div>

<jsp:include page="fragments/footer.jsp" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>