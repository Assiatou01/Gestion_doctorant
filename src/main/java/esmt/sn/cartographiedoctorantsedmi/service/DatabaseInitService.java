package esmt.sn.cartographiedoctorantsedmi.service;

import com.opencsv.CSVParser;
import com.opencsv.CSVParserBuilder;
import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;
import esmt.sn.cartographiedoctorantsedmi.entity.*;
import esmt.sn.cartographiedoctorantsedmi.repository.*;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.InputStreamReader;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

@Service
@RequiredArgsConstructor
public class DatabaseInitService {

    private final DoctorantRepository doctorantRepository;
    private final FaculteRepository faculteRepository;
    private final LaboratoireRepository laboratoireRepository;
    private final EcoleDoctoraleRepository ecoleDoctoraleRepository;
    private final CompetenceRepository competenceRepository;
    private final MotsClesRepository motsClesRepository;
    private final TheseRepository theseRepository;
    private final DomaineRechercheRepository domaineRechercheRepository;
    private final PublicationRepository publicationRepository;

    @PostConstruct
    @Transactional
    public void initData() {
        if (doctorantRepository.count() > 0) {
            System.out.println("Base de données déjà initialisée : " + doctorantRepository.count() + " doctorants.");
            return;
        }

        try (Reader reader = new InputStreamReader(
                getClass().getResourceAsStream("/doctorants_data.csv"), StandardCharsets.UTF_8)) {

            CSVParser parser = new CSVParserBuilder().withSeparator(';').build();
            try (CSVReader csvReader = new CSVReaderBuilder(reader).withCSVParser(parser).withSkipLines(1).build()) {

                String[] line;
                int successCount = 0;

                while ((line = csvReader.readNext()) != null) {
                    try {
                        if (line.length < 10) continue;

                        Doctorant doc = new Doctorant();
                        doc.setLastName(line[1].trim());
                        doc.setFirstName(line[2].trim());
                        doc.setEmail(line[3].trim());
                        doc.setTelephone(line[4].trim());

                        // 1. Organisation
                        doc.setFaculte(trouverOuCreerFaculte(line[5]));
                        doc.setLaboratoire(trouverOuCreerLabo(line[6]));
                        doc.setEcoleDoctorale(trouverOuCreerEcole(line[7]));

                        // 2. Thèse (Relation Bidirectionnelle)
                        These these = new These();
                        these.setIntitule(line[8]);
                        these.setSecteur(line[10]);
                        these.setImpact(line[11]);
                        these.setProblematique(line[12]);
                        these.setSolution(line[13]);

                        if (line.length > 20) traiterMotsCles(line[20], these);

                        these = theseRepository.save(these);
                        doc.getTheses().add(these);
                        these.getDoctorants().add(doc); // Lien vers l'auteur

                        // 3. Champs TEXT et Listes
                        doc.setMaturation(line[16]);
                        doc.setInteret(line[17]);

                        if (line.length > 18) traiterCompetences(line[18], doc);

                        // Ajout des Domaines de recherche (Ex: Colonne 21)
                        if (line.length > 21) traiterDomaines(line[21], doc);

                        // Ajout des Startups (Ex: Colonne 22)
                        if (line.length > 22 && !line[22].trim().isEmpty()) {
                            Startup startup = new Startup(null, line[22].trim(), doc);
                            doc.getStartups().add(startup);
                        }

                        if (line.length > 23) doc.setSouhait(line[23]);
                        if (line.length > 24) doc.setCv(line[24]);

                        // Ajout des Publications (Ex: Colonne 25)
                        if (line.length > 25) traiterPublications(line[25], doc);

                        doctorantRepository.save(doc);
                        successCount++;

                    } catch (Exception e) {
                        System.err.println("Erreur ligne CSV : " + e.getMessage());
                    }
                }
                System.out.println("Importation terminée ! Total : " + successCount + " doctorants.");
            }
        } catch (Exception e) {
            System.err.println("ERREUR CRITIQUE : " + e.getMessage());
        }
    }

    private void traiterDomaines(String raw, Doctorant doc) {
        if (raw == null || raw.isEmpty()) return;
        String cleaned = raw.replaceAll("[\\[\\]\"\" ]", "");
        Arrays.stream(cleaned.split(",")).filter(s -> !s.isEmpty()).forEach(nom -> {
            DomaineRecherche dom = domaineRechercheRepository.findByDomaine(nom)
                    .orElseGet(() -> domaineRechercheRepository.save(new DomaineRecherche(null, nom)));
            doc.getDomainesRecherche().add(dom);
        });
    }

    private void traiterPublications(String raw, Doctorant doc) {
        if (raw == null || raw.isEmpty()) return;
        // On considère souvent les publications comme des liens ou titres séparés par des virgules
        Arrays.stream(raw.split(",")).filter(s -> !s.isEmpty()).forEach(titre -> {
            Publication pub = publicationRepository.save(new Publication(null, titre.trim()));
            doc.getPublications().add(pub);
        });
    }

    private void traiterCompetences(String raw, Doctorant doc) {
        if (raw == null || raw.isEmpty()) return;
        String cleaned = raw.replaceAll("[\\[\\]\"\" ]", "");
        Arrays.stream(cleaned.split(",")).filter(s -> !s.isEmpty()).forEach(nom -> {
            Competence comp = competenceRepository.findByNomCompetence(nom)
                    .orElseGet(() -> competenceRepository.save(new Competence(null, nom)));
            doc.getCompetences().add(comp);
        });
    }

    private void traiterMotsCles(String raw, These these) {
        if (raw == null || raw.isEmpty()) return;
        String cleaned = raw.replaceAll("[\\[\\]\"\" ]", "");
        Arrays.stream(cleaned.split(",")).filter(s -> !s.isEmpty()).forEach(mot -> {
            MotsCles mk = motsClesRepository.findByMot(mot)
                    .orElseGet(() -> motsClesRepository.save(new MotsCles(null, mot)));
            these.getMotsCles().add(mk);
        });
    }

    private Faculte trouverOuCreerFaculte(String nom) {
        if (nom == null || nom.trim().isEmpty()) return null;
        String cleanNom = nom.trim();
        return faculteRepository.findByNom(cleanNom)
                .orElseGet(() -> faculteRepository.save(new Faculte(null, cleanNom)));
    }

    private Laboratoire trouverOuCreerLabo(String nom) {
        if (nom == null || nom.trim().isEmpty()) return null;
        String cleanNom = nom.trim();
        return laboratoireRepository.findByNom(cleanNom)
                .orElseGet(() -> laboratoireRepository.save(new Laboratoire(null, cleanNom)));
    }

    private EcoleDoctorale trouverOuCreerEcole(String nom) {
        if (nom == null || nom.trim().isEmpty()) return null;
        String cleanNom = nom.trim();
        return ecoleDoctoraleRepository.findByNom(cleanNom)
                .orElseGet(() -> ecoleDoctoraleRepository.save(new EcoleDoctorale(null, cleanNom)));
    }
}