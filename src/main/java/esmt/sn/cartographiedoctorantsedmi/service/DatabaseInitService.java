package esmt.sn.cartographiedoctorantsedmi.service;

import esmt.sn.cartographiedoctorantsedmi.entity.*;
import esmt.sn.cartographiedoctorantsedmi.repository.*;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DatabaseInitService {

    private final DoctorantRepository doctorantRepository;
    private final FaculteRepository faculteRepository;
    private final LaboratoireRepository laboratoireRepository;
    private final TheseRepository theseRepository;

    @PostConstruct
    @Transactional
    public void initData() {
        if (doctorantRepository.count() > 0) {
            System.out.println("Base déjà initialisée : " + doctorantRepository.count() + " doctorants.");
            return;
        }

        System.out.println("Création de données de test...");

        // Faculté
        Faculte fac = faculteRepository.save(new Faculte(null, "Faculté des Sciences et Technologies (FST)"));
        // Laboratoire
        Laboratoire lab = laboratoireRepository.save(new Laboratoire(null, "Laboratoire d'Informatique (LI)"));

        // Thèse
        These these = new These();
        these.setIntitule("Intelligence Artificielle pour la santé");
        these.setSecteur("Santé");
        these.setProblematique("Manque d'outils de diagnostic précoce");
        these.setSolution("Utilisation de réseaux de neurones profonds");
        these.setImpact("Réduction de la mortalité");
        these = theseRepository.save(these);

        // Doctorant 1
        Doctorant doc1 = new Doctorant();
        doc1.setLastName("Dupont");
        doc1.setFirstName("Jean");
        doc1.setEmail("jean.dupont@example.com");
        doc1.setTelephone("771234567");
        doc1.setFaculte(fac);
        doc1.setLaboratoire(lab);
        doc1.getTheses().add(these);
        these.getDoctorants().add(doc1);
        doctorantRepository.save(doc1);

        // Doctorant 2
        Doctorant doc2 = new Doctorant();
        doc2.setLastName("Diop");
        doc2.setFirstName("Fatou");
        doc2.setEmail("fatou.diop@example.com");
        doc2.setFaculte(fac);
        doc2.setLaboratoire(lab);
        doc2.getTheses().add(these);
        these.getDoctorants().add(doc2);
        doctorantRepository.save(doc2);

        System.out.println("2 doctorants de test créés.");
    }
}