package esmt.sn.cartographiedoctorantsedmi.service;

import esmt.sn.cartographiedoctorantsedmi.entity.Competence;
import esmt.sn.cartographiedoctorantsedmi.entity.DomaineRecherche;
import esmt.sn.cartographiedoctorantsedmi.entity.These;
import esmt.sn.cartographiedoctorantsedmi.repository.DoctorantRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.TheseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StatistiquesService {

    private final DoctorantRepository doctorantRepository;
    private final TheseRepository theseRepository;

    public long getTotalDoctorants() { return doctorantRepository.count(); }
    public long getTotalTheses() { return theseRepository.count(); }

    public Map<String, Long> getStatsFacultes() {
        return doctorantRepository.findAll().stream()
                .filter(d -> d.getFaculte() != null)
                .collect(Collectors.groupingBy(d -> d.getFaculte().getNom(), Collectors.counting()));
    }

    public Map<String, Long> getStatsLaboratoires() {
        return doctorantRepository.findAll().stream()
                .filter(d -> d.getLaboratoire() != null)
                .collect(Collectors.groupingBy(d -> d.getLaboratoire().getNom(), Collectors.counting()));
    }

    public Map<String, Long> getStatsSecteurs() {
        return theseRepository.findAll().stream()
                .filter(t -> t.getSecteur() != null && !t.getSecteur().isEmpty())
                .collect(Collectors.groupingBy(These::getSecteur, Collectors.counting()));
    }

    public Map<String, Long> getThesesParDoctorant() {
        return theseRepository.findAll().stream()
                .flatMap(t -> t.getDoctorants().stream())
                .collect(Collectors.groupingBy(d -> d.getFirstName() + " " + d.getLastName(), Collectors.counting()));
    }

    // Suppression des méthodes getStatutParDates() et getThesesParAnneeDebut()

    public Map<String, Object> getStatistiquesGlobales() {
        return Map.of(
                "totalDoctorants", getTotalDoctorants(),
                "totalTheses", getTotalTheses(),
                "statsFacultes", getStatsFacultes(),
                "statsLaboratoires", getStatsLaboratoires(),
                "statsSecteurs", getStatsSecteurs(),
                "thesesParDoctorant", getThesesParDoctorant()
        );
    }

    public Map<String, Long> getStatsCompetences() {
        return doctorantRepository.findAll().stream()
                .flatMap(d -> d.getCompetences().stream())
                .collect(Collectors.groupingBy(Competence::getNomCompetence, Collectors.counting()));
    }

    public Map<String, Long> getStatsDomainesRecherche() {
        return doctorantRepository.findAll().stream()
                .flatMap(d -> d.getDomainesRecherche().stream())
                .collect(Collectors.groupingBy(DomaineRecherche::getDomaine, Collectors.counting()));
    }
}