<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Doctorants</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>

<jsp:include page="fragments/sidebar.jsp" />

<div class="main-content">
    <jsp:include page="fragments/header.jsp" />

    <div class="container-fluid px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary"><i class="fas fa-users me-2"></i>Annuaire des Doctorants</h2>
            <a href="/doctorant/nouveau" class="btn btn-primary rounded-pill px-4"><i class="fas fa-plus-circle me-2"></i>Nouveau Doctorant</a>
        </div>

        <div class="card card-custom p-2">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" style="border-collapse: separate; border-spacing: 0 8px;">
                        <thead class="text-uppercase text-muted" style="font-size: 0.8rem; letter-spacing: 0.5px;">
                        <tr><th class="border-0 ps-3">Nom & Prénom</th><th class="border-0">Email</th><th class="border-0">Laboratoire</th><th class="border-0">Faculté</th><th class="text-center border-0 pe-3">Actions</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${listeDoctorants}" var="doc">
                            <tr class="bg-white shadow-sm rounded-3 transition-hover" style="transition: all 0.2s;">
                                <td class="border-0 ps-3 py-3 rounded-start"><div class="d-flex align-items-center"><div class="avatar bg-primary-subtle text-primary fw-bold rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 40px; height: 40px;">${fn:substring(doc.firstName, 0, 1)}${fn:substring(doc.lastName, 0, 1)}</div><div><h6 class="mb-0 fw-bold text-dark">${doc.firstName} ${doc.lastName}</h6></div></div></td>
                                <td class="border-0 text-muted">${doc.email}</td>
                                <td class="border-0"><span class="badge bg-light text-dark border px-3 py-2 rounded-pill">${doc.laboratoire != null ? doc.laboratoire.nom : 'Non défini'}</span></td>
                                <td class="border-0"><span class="badge bg-light text-dark border px-3 py-2 rounded-pill">${doc.faculte != null ? doc.faculte.nom : 'Non défini'}</span></td>
                                <td class="text-center border-0 pe-3 rounded-end">
                                    <div class="btn-group shadow-sm rounded-pill">
                                        <a href="/doctorant/details/${doc.id}" class="btn btn-sm btn-light text-primary" data-bs-toggle="tooltip" title="Voir"><i class="fas fa-eye"></i></a>
                                        <a href="/doctorant/modifier/${doc.id}" class="btn btn-sm btn-light text-warning" data-bs-toggle="tooltip" title="Éditer"><i class="fas fa-edit"></i></a>
                                        <a href="/doctorant/supprimer/${doc.id}" class="btn btn-sm btn-light text-danger" onclick="return confirm('Supprimer ce doctorant ?')" data-bs-toggle="tooltip" title="Supprimer"><i class="fas fa-trash"></i></a>
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