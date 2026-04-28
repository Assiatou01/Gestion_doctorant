package esmt.sn.cartographiedoctorantsedmi.service;

import esmt.sn.cartographiedoctorantsedmi.entity.*;
import esmt.sn.cartographiedoctorantsedmi.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;

@Service
@RequiredArgsConstructor
public class CsvImportService {

    private final DoctorantRepository doctorantRepository;
    private final FaculteRepository faculteRepository;
    private final LaboratoireRepository laboratoireRepository;
    private final EcoleDoctoraleRepository ecoleDoctoraleRepository;
    private final TheseRepository theseRepository;
    private final CompetenceRepository competenceRepository;
    private final MotsClesRepository motsClesRepository;
    private final DomaineRechercheRepository domaineRechercheRepository;
    private final PublicationRepository publicationRepository;

    @Transactional
    public int importDoctorantsFromCsv(MultipartFile file) throws Exception {
        List<String[]> records = parseCsvManual(file);
        System.out.println("Nombre d'enregistrements trouvés : " + records.size());
        int count = 0;
        for (String[] columns : records) {
            if (columns.length < 15) {
                System.err.println("Ligne ignorée : nombre de colonnes = " + columns.length);
                continue;
            }
            try {
                Doctorant doc = createDoctorant(columns);
                doctorantRepository.save(doc);
                count++;
                System.out.println("✅ Doctorant importé : " + doc.getFirstName() + " " + doc.getLastName());
            } catch (Exception e) {
                System.err.println("❌ Erreur sur une ligne : " + e.getMessage());
                e.printStackTrace();
            }
        }
        return count;
    }

    /**
     * Parse un CSV avec tabulation comme séparateur, en gérant les retours à la ligne dans les champs.
     * Chaque enregistrement commence par un chiffre (id) suivi d'une tabulation.
     */
    private List<String[]> parseCsvManual(MultipartFile file) throws Exception {
        List<String[]> records = new ArrayList<>();
        List<String> lines = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        }
        if (lines.size() < 2) return records; // au moins en-tête + 1 donnée

        // On ignore la première ligne (en-tête)
        StringBuilder currentRecord = new StringBuilder();
        for (int i = 1; i < lines.size(); i++) {
            String line = lines.get(i);
            // Détection d'un nouvel enregistrement : la ligne commence par un chiffre (id)
            if (line.length() > 0 && Character.isDigit(line.charAt(0))) {
                if (currentRecord.length() > 0) {
                    // Sauvegarder l'enregistrement précédent
                    String[] columns = currentRecord.toString().split("\t", -1);
                    records.add(columns);
                    currentRecord.setLength(0);
                }
                currentRecord.append(line);
            } else {
                // Ligne faisant partie du champ précédent (multiligne)
                if (currentRecord.length() > 0) currentRecord.append("\n");
                currentRecord.append(line);
            }
        }
        // Dernier enregistrement
        if (currentRecord.length() > 0) {
            String[] columns = currentRecord.toString().split("\t", -1);
            records.add(columns);
        }

        System.out.println("[CSV] " + records.size() + " enregistrements détectés");
        return records;
    }

    private Doctorant createDoctorant(String[] cols) {
        Doctorant doc = new Doctorant();
        doc.setLastName(getSafe(cols, 1));
        doc.setFirstName(getSafe(cols, 2));
        doc.setEmail(getSafe(cols, 3));
        doc.setTelephone(getSafe(cols, 4));
        doc.setFaculte(findOrCreateFaculte(getSafe(cols, 5)));
        doc.setLaboratoire(findOrCreateLaboratoire(getSafe(cols, 6)));
        doc.setEcoleDoctorale(findOrCreateEcoleDoctorale(getSafe(cols, 7)));

        These these = new These();
        these.setIntitule(getSafe(cols, 8));
        these.setSecteur(getSafe(cols, 10));
        these.setImpact(getSafe(cols, 11));
        these.setProblematique(getSafe(cols, 12));
        these.setSolution(getSafe(cols, 13));
        if (cols.length > 20 && !isNullOrEmpty(getSafe(cols, 20)))
            handleMotsCles(getSafe(cols, 20), these);
        these = theseRepository.save(these);
        doc.getTheses().add(these);
        these.getDoctorants().add(doc);

        doc.setDateStart(parseDate(getSafe(cols, 14)));
        doc.setDateEnd(parseDate(getSafe(cols, 15)));
        doc.setMaturation(getSafe(cols, 16));
        doc.setInteret(getSafe(cols, 17));

        if (cols.length > 18) handleCompetences(getSafe(cols, 18), doc);
        if (cols.length > 19) handleDomaines(getSafe(cols, 19), doc);
        if (cols.length > 21) handlePublications(getSafe(cols, 21), doc);
        if (cols.length > 22 && !isNullOrEmpty(getSafe(cols, 22)))
            doc.setPublicationFaire("OUI".equalsIgnoreCase(getSafe(cols, 22)));
        if (cols.length > 23) doc.setSouhait(getSafe(cols, 23));
        if (cols.length > 24) doc.setCv(getSafe(cols, 24));

        if (cols.length > 9 && !isNullOrEmpty(getSafe(cols, 9))) {
            Startup startup = new Startup(null, getSafe(cols, 9), doc);
            doc.getStartups().add(startup);
        }
        return doc;
    }

    // ==================== MÉTHODES UTILITAIRES ====================
    private String getSafe(String[] arr, int idx) {
        return arr.length > idx ? arr[idx].trim() : null;
    }

    private boolean isNullOrEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private LocalDate parseDate(String dateStr) {
        if (isNullOrEmpty(dateStr)) return null;
        dateStr = dateStr.trim().toLowerCase(Locale.FRENCH);
        List<DateTimeFormatter> formatters = Arrays.asList(
                DateTimeFormatter.ofPattern("MMM-yy", Locale.FRENCH),
                DateTimeFormatter.ofPattern("dd/MM/yyyy"),
                DateTimeFormatter.ofPattern("yyyy-MM-dd"),
                DateTimeFormatter.ofPattern("yyyy")
        );
        for (DateTimeFormatter f : formatters) {
            try {
                return LocalDate.parse(dateStr, f);
            } catch (DateTimeParseException ignored) {}
        }
        if (dateStr.matches("\\d{4}")) {
            return LocalDate.of(Integer.parseInt(dateStr), 1, 1);
        }
        return null;
    }

    private void handleMotsCles(String raw, These these) {
        if (isNullOrEmpty(raw)) return;
        String cleaned = raw.replaceAll("[\\[\\]\"'\n]", "").trim();
        Arrays.stream(cleaned.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .forEach(mot -> {
                    MotsCles mk = motsClesRepository.findByMot(mot)
                            .orElseGet(() -> motsClesRepository.save(new MotsCles(null, mot)));
                    these.getMotsCles().add(mk);
                });
    }

    private void handleCompetences(String raw, Doctorant doc) {
        if (isNullOrEmpty(raw)) return;
        String cleaned = raw.replaceAll("[\\[\\]\"'\n]", "").trim();
        Arrays.stream(cleaned.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .forEach(nom -> {
                    Competence comp = competenceRepository.findByNomCompetence(nom)
                            .orElseGet(() -> competenceRepository.save(new Competence(null, nom)));
                    doc.getCompetences().add(comp);
                });
    }

    private void handleDomaines(String raw, Doctorant doc) {
        if (isNullOrEmpty(raw)) return;
        String cleaned = raw.replaceAll("[\\[\\]\"'\n]", "").trim();
        Arrays.stream(cleaned.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .forEach(dom -> {
                    DomaineRecherche domain = domaineRechercheRepository.findByDomaine(dom)
                            .orElseGet(() -> domaineRechercheRepository.save(new DomaineRecherche(null, dom)));
                    doc.getDomainesRecherche().add(domain);
                });
    }

    private void handlePublications(String raw, Doctorant doc) {
        if (isNullOrEmpty(raw)) return;
        Arrays.stream(raw.split("[,;]"))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .forEach(titre -> {
                    Publication pub = publicationRepository.save(new Publication(null, titre));
                    doc.getPublications().add(pub);
                });
    }

    private Faculte findOrCreateFaculte(String nom) {
        if (isNullOrEmpty(nom)) return null;
        return faculteRepository.findByNom(nom)
                .orElseGet(() -> faculteRepository.save(new Faculte(null, nom)));
    }

    private Laboratoire findOrCreateLaboratoire(String nom) {
        if (isNullOrEmpty(nom)) return null;
        return laboratoireRepository.findByNom(nom)
                .orElseGet(() -> laboratoireRepository.save(new Laboratoire(null, nom)));
    }

    private EcoleDoctorale findOrCreateEcoleDoctorale(String nom) {
        if (isNullOrEmpty(nom)) return null;
        return ecoleDoctoraleRepository.findByNom(nom)
                .orElseGet(() -> ecoleDoctoraleRepository.save(new EcoleDoctorale(null, nom)));
    }
}