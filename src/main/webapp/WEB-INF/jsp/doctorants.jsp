<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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

        <div class="card shadow-sm border-0 rounded-4">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light"><tr><th>Nom & Prénom</th><th>Email</th><th>Laboratoire</th><th>Faculté</th><th class="text-center">Actions</th></tr></thead>
                        <tbody>
                        <c:forEach items="${listeDoctorants}" var="doc">
                            <tr>
                                <td><strong>${doc.lastName}</strong> ${doc.firstName}</td>
                                <td>${doc.email}</td>
                                <td>${doc.laboratoire != null ? doc.laboratoire.nom : 'Non défini'}</td>
                                <td>${doc.faculte != null ? doc.faculte.nom : 'Non défini'}</td>
                                <td class="text-center">
                                    <div class="btn-group">
                                        <a href="/doctorant/details/${doc.id}" class="btn btn-sm btn-info text-white rounded-pill me-1"><i class="fas fa-eye"></i></a>
                                        <a href="/doctorant/modifier/${doc.id}" class="btn btn-sm btn-warning text-white rounded-pill me-1"><i class="fas fa-edit"></i></a>
                                        <a href="/doctorant/supprimer/${doc.id}" class="btn btn-sm btn-danger rounded-pill" onclick="return confirm('Supprimer ?')"><i class="fas fa-trash"></i></a>
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