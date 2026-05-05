package esmt.sn.cartographiedoctorantsedmi.service;

import com.opencsv.CSVParser;
import com.opencsv.CSVParserBuilder;
import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;
import esmt.sn.cartographiedoctorantsedmi.entity.*;
import esmt.sn.cartographiedoctorantsedmi.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.web.multipart.MultipartFile;
import java.time.format.DateTimeFormatter;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.stream.Collectors;

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

    // Méthode publique – non transactionnelle pour éviter qu'une erreur annule tout
    public int importDoctorantsFromCsv(MultipartFile file) throws Exception {
        List<Map<String, String>> records = parseCsvWithOpenCsv(file);
        System.out.println("Nombre d'enregistrements trouvés : " + records.size());
        int count = 0;
        int errored = 0;
        for (Map<String, String> row : records) {
            try {
                importSingleDoctorant(row);
                count++;
            } catch (Exception e) {
                errored++;
                System.err.println("❌ Erreur sur une ligne (row #" + (count+errored+1) + ") : " + e.getMessage());
                e.printStackTrace();
            }
        }
        System.out.println("Import terminé : " + count + " doctorants importés, " + errored + " échec(s).");
        return count;
    }

    // Chaque doctorant est importé dans une transaction séparée (rollback uniquement pour cette ligne)
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void importSingleDoctorant(Map<String, String> row) throws Exception {
        Doctorant doc = createDoctorantFromMap(row);
        if (doc.getLastName() != null && !doc.getLastName().isEmpty()) {
            doctorantRepository.save(doc);
            System.out.println("✅ Doctorant importé : " + doc.getFirstName() + " " + doc.getLastName());
        } else {
            throw new IllegalArgumentException("Nom manquant");
        }
    }

    // -------------------- Parsing OpenCSV --------------------
    private List<Map<String, String>> parseCsvWithOpenCsv(MultipartFile file) throws Exception {
        // Lire toutes les lignes une seule fois
        List<String> allLines;
        try (BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            allLines = br.lines().collect(Collectors.toList());
        }
        if (allLines.isEmpty()) return Collections.emptyList();

        char delimiter = detectDelimiter(allLines.get(0));

        // Réouverture du flux pour OpenCSV
        try (InputStreamReader reader = new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8);
             CSVReader csvReader = new CSVReaderBuilder(reader)
                     .withCSVParser(new CSVParserBuilder().withSeparator(delimiter).build())
                     .build()) {

            String[] headers = csvReader.readNext();
            if (headers == null) return Collections.emptyList();
            List<String> normalizedHeaders = Arrays.stream(headers)
                    .map(this::normalizeHeader)
                    .collect(Collectors.toList());

            List<Map<String, String>> records = new ArrayList<>();
            String[] line;
            while ((line = csvReader.readNext()) != null) {
                Map<String, String> row = new HashMap<>();
                for (int i = 0; i < normalizedHeaders.size() && i < line.length; i++) {
                    row.put(normalizedHeaders.get(i), line[i]);
                }
                records.add(row);
            }
            return records;
        }
    }

    private char detectDelimiter(String line) {
        int commas = line.length() - line.replace(",", "").length();
        int semicolons = line.length() - line.replace(";", "").length();
        int tabs = line.length() - line.replace("\t", "").length();

        if (tabs >= commas && tabs >= semicolons) return '\t';
        if (semicolons >= commas) return ';';
        return ',';
    }

    private String normalizeHeader(String header) {
        if (header == null) return "";
        return header.trim().toLowerCase(Locale.ROOT)
                .replaceAll("[éèêë]", "e")
                .replaceAll("[àâä]", "a")
                .replaceAll("[îï]", "i")
                .replaceAll("[ôö]", "o")
                .replaceAll("[ùûü]", "u")
                .replaceAll("[^a-z0-9_]", ""); // conserve les underscores
    }

    private String getFromRow(Map<String, String> row, String... possibleKeys) {
        for (String key : possibleKeys) {
            String val = row.get(key);
            if (val != null && !val.trim().isEmpty()) {
                return val.trim();
            }
        }
        return null;
    }

    // -------------------- Construction des entités --------------------
    private Doctorant createDoctorantFromMap(Map<String, String> row) throws Exception {
        Doctorant doc = new Doctorant();
        doc.setLastName(getFromRow(row, "nom", "lastname", "last_name", "nomdoctorant"));
        doc.setFirstName(getFromRow(row, "prenom", "firstname", "first_name", "prenomdoctorant", "prenoms"));
        doc.setEmail(getFromRow(row, "email", "mail", "courriel"));
        doc.setTelephone(getFromRow(row, "telephone", "tel", "phone"));

        doc.setFaculte(findOrCreateFaculte(getFromRow(row, "faculte", "fac", "etablissement", "institut")));
        doc.setLaboratoire(findOrCreateLaboratoire(getFromRow(row, "laboratoire", "labo", "lab")));
        doc.setEcoleDoctorale(findOrCreateEcoleDoctorale(getFromRow(row, "ecoledoctorale", "ecole", "doctorale", "ed")));

        // Thèse
        These these = new These();
        String intitule = getFromRow(row, "these", "intitule", "titre", "sujet", "titrethese");
        these.setIntitule(intitule);
        these.setSecteur(getFromRow(row, "secteur", "domaine", "secteuractivite"));
        these.setImpact(getFromRow(row, "impact", "impactattendu"));
        these.setProblematique(getFromRow(row, "problematique", "probleme"));
        these.setSolution(getFromRow(row, "solution", "solutionproposee"));

        String motsCles = getFromRow(row, "motscles", "motcles", "keywords");
        if (motsCles != null) handleMotsCles(motsCles, these);

        if (these.getIntitule() != null && !these.getIntitule().isEmpty()) {
            these = theseRepository.save(these);
            doc.getTheses().add(these);
            these.getDoctorants().add(doc);
        } else {
            System.err.println("⚠️ Thèse sans intitulé, ignorée pour " + doc.getEmail());
        }

//        doc.setDateStart(parseDate(getFromRow(row, "datestart", "datedebut", "debut", "debutthese")));
//        doc.setDateEnd(parseDate(getFromRow(row, "dateend", "datefin", "fin", "finthese")));
        doc.setDateStart(parseDate(getFromRow(row, "date_start", "datestart", "datedebut", "debut", "debutthese")));
        doc.setDateEnd(parseDate(getFromRow(row, "date_end", "dateend", "datefin", "fin", "finthese")));
        doc.setMaturation(getFromRow(row, "maturation", "niveau", "statut"));
        doc.setInteret(getFromRow(row, "interet", "centresdinteret", "interets"));
        doc.setSouhait(getFromRow(row, "souhait", "insertion", "souhaitdinsertion"));
        doc.setCv(getFromRow(row, "cv", "liencv", "drive"));

        handleCompetences(getFromRow(row, "competences", "competence", "skills"), doc);
        handleDomaines(getFromRow(row, "domaine_recherche", "domainerecherche", "domaines", "researchdomain"), doc);
        handlePublications(getFromRow(row, "publication", "publications", "articles"), doc);

        String pubFaire = getFromRow(row, "publicationfaire", "apublie", "haspublications");
        if (pubFaire != null) {
            doc.setPublicationFaire(pubFaire.equalsIgnoreCase("oui") || pubFaire.equalsIgnoreCase("yes") ||
                    pubFaire.equalsIgnoreCase("true") || pubFaire.equals("1") || pubFaire.equalsIgnoreCase("vrai"));
        }

        String startupName = getFromRow(row, "startup", "entreprise", "projetstartup");
        if (startupName != null && !startupName.isEmpty()) {
            Startup startup = new Startup(null, startupName, doc);
            doc.getStartups().add(startup);
        }

        return doc;
    }

    // -------------------- Méthodes utilitaires (à garder) --------------------
    private boolean isNullOrEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

//    private LocalDate parseDate(String dateStr) {
//        if (isNullOrEmpty(dateStr)) return null;
//        dateStr = dateStr.trim().toLowerCase(Locale.FRENCH);
//        List<DateTimeFormatter> formatters = Arrays.asList(
//                DateTimeFormatter.ofPattern("MMM-yy", Locale.FRENCH),
//                DateTimeFormatter.ofPattern("dd/MM/yyyy"),
//                DateTimeFormatter.ofPattern("yyyy-MM-dd"),
//                DateTimeFormatter.ofPattern("yyyy")
//        );
//        for (DateTimeFormatter f : formatters) {
//            try {
//                return LocalDate.parse(dateStr, f);
//            } catch (DateTimeParseException ignored) {}
//        }
//        if (dateStr.matches("\\d{4}")) {
//            return LocalDate.of(Integer.parseInt(dateStr), 1, 1);
//        }
//        return null;
//    }

    private LocalDate parseDate(String dateStr) {
        System.out.println(">>> parseDate reçoit : '" + dateStr + "'");
        if (isNullOrEmpty(dateStr)) return null;
        dateStr = dateStr.trim();

        // Déjà au format dd/MM/yyyy ?
        if (dateStr.matches("\\d{2}/\\d{2}/\\d{4}")) {
            try {
                return LocalDate.parse(dateStr, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            } catch (DateTimeParseException e) { /* ignorer */ }
        }

        // dd-MM-yyyy
        if (dateStr.matches("\\d{2}-\\d{2}-\\d{4}")) {
            try {
                return LocalDate.parse(dateStr, DateTimeFormatter.ofPattern("dd-MM-yyyy"));
            } catch (DateTimeParseException e) { /* ignorer */ }
        }

        // yyyy-MM-dd
        if (dateStr.matches("\\d{4}-\\d{2}-\\d{2}")) {
            try {
                return LocalDate.parse(dateStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            } catch (DateTimeParseException e) { /* ignorer */ }
        }

        // yyyy (juste l'année)
        if (dateStr.matches("\\d{4}")) {
            return LocalDate.of(Integer.parseInt(dateStr), 1, 1);
        }

        // Format français "dd MMM yyyy" ou "MMM-yy"
        try {
            DateTimeFormatter frenchFormatter = DateTimeFormatter.ofPattern("dd MMM yyyy", Locale.FRENCH);
            return LocalDate.parse(dateStr, frenchFormatter);
        } catch (DateTimeParseException e1) {
            try {
                DateTimeFormatter frenchShort = DateTimeFormatter.ofPattern("MMM-yy", Locale.FRENCH);
                return LocalDate.parse(dateStr, frenchShort);
            } catch (DateTimeParseException e2) {
                // Essayer d'extraire une année à 4 chiffres
                Pattern p = Pattern.compile("\\d{4}");
                Matcher m = p.matcher(dateStr);
                if (m.find()) {
                    return LocalDate.of(Integer.parseInt(m.group()), 1, 1);
                }
            }
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
                    if (!titre.isEmpty()) {
                        Publication pub = publicationRepository.save(new Publication(null, titre));
                        doc.getPublications().add(pub);
                    }
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