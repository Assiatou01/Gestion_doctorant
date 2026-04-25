package esmt.sn.cartographiedoctorantsedmi.service;

import esmt.sn.cartographiedoctorantsedmi.entity.*;
import esmt.sn.cartographiedoctorantsedmi.repository.*;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DatabaseInitService {

    // Spring Boot va injecter tous vos Repositories automatiquement grâce à @RequiredArgsConstructor !
    private final DoctorantRepository doctorantRepository;
    private final FaculteRepository faculteRepository;
    private final LaboratoireRepository laboratoireRepository;
    private final EcoleDoctoraleRepository ecoleDoctoraleRepository;

    /**
     * @PostConstruct demande à Spring d'exécuter cette méthode automatiquement quand l'application démarre.
     */
    @PostConstruct
    public void initData() {
        // 1. On vérifie si la base est déjà remplie pour ne pas tout importer en double !
        if (doctorantRepository.count() > 0) {
            System.out.println("Base de données déjà initialisée, on passe l'import CSV.");
            return;
        }

        System.out.println("Démarrage de l'importation du fichier CSV...");

        try (BufferedReader br = new BufferedReader(new InputStreamReader(
                getClass().getResourceAsStream("/doctorants_data.csv")))) {

            String line;
            boolean isFirstLine = true;

            // On lit le fichier ligne par ligne
            while ((line = br.readLine()) != null) {
                if (isFirstLine) {
                    isFirstLine = false; // On ignore la première ligne (qui contient les titres des colonnes)
                    continue;
                }

                // On sépare les colonnes avec le point-virgule (si votre fichier utilise la virgule, mettez ",")
                String[] colonnes = line.split(";");

                // Précautions au cas où la ligne serait vide ou incomplète
                if (colonnes.length < 10) continue;

                // --- ÉTAPE 1 : Sauvegarder les petites tables liées (Laboratoire, Faculté...) ---
                String nomFaculte = colonnes[5];
                String nomLabo = colonnes[6];
                String nomEcole = colonnes[7];

                Faculte faculte = sauverOuTrouverFaculte(nomFaculte);
                Laboratoire labo = sauverOuTrouverLaboratoire(nomLabo);
                EcoleDoctorale ecole = sauverOuTrouverEcole(nomEcole);

                // --- ÉTAPE 2 : Créer le Doctorant et lui affecter ses relations ---
                Doctorant doc = new Doctorant();
                doc.setLastName(colonnes[1]);
                doc.setFirstName(colonnes[2]);
                doc.setEmail(colonnes[3]);
                doc.setTelephone(colonnes[4]);

                doc.setFaculte(faculte);
                doc.setLaboratoire(labo);
                doc.setEcoleDoctorale(ecole);

                // On sauvegarde le doctorant dans la base
                doctorantRepository.save(doc);
            }

            System.out.println("Importation CSV terminée avec succès !");

        } catch (Exception e) {
            System.out.println("Erreur lors de la lecture du fichier CSV ! Avez-vous bien mis doctorants_data.csv dans resources ?");
            e.printStackTrace();
        }
    }

    // --- Méthodes utilitaires pour ne pas créer 100 fois la même Faculté dans MySQL ---

    private Faculte sauverOuTrouverFaculte(String nom) {
        if (nom == null || nom.trim().isEmpty()) return null;
        // Remarque : Normalement on cherche avec le Repository, ici on simplifie en créant un nouveau à chaque fois.
        // Dans une V2, on pourra ajouter une recherche findByNom().
        Faculte f = new Faculte();
        f.setNom(nom.trim());
        return faculteRepository.save(f);
    }

    private Laboratoire sauverOuTrouverLaboratoire(String nom) {
        if (nom == null || nom.trim().isEmpty()) return null;
        Laboratoire l = new Laboratoire();
        l.setNom(nom.trim());
        return laboratoireRepository.save(l);
    }

    private EcoleDoctorale sauverOuTrouverEcole(String nom) {
        if (nom == null || nom.trim().isEmpty()) return null;
        EcoleDoctorale ecole = new EcoleDoctorale();
        ecole.setNom(nom.trim());
        return ecoleDoctoraleRepository.save(ecole);
    }
}
