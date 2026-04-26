package esmt.sn.cartographiedoctorantsedmi.service;

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

    public long getTotalDoctorants() {
        return doctorantRepository.count();
    }

    public long getTotalTheses() {
        return theseRepository.count();
    }

    // Statistique 1 : Répartition par Faculté (basé sur la relation Doctorant -> Faculte)
    public Map<String, Long> getStatsFacultes() {
        return doctorantRepository.findAll().stream()
                .filter(d -> d.getFaculte() != null)
                .collect(Collectors.groupingBy(d -> d.getFaculte().getNom(), Collectors.counting()));
    }

    // Statistique 2 : Répartition par Laboratoire (basé sur la relation Doctorant -> Laboratoire)
    public Map<String, Long> getStatsLaboratoires() {
        return doctorantRepository.findAll().stream()
                .filter(d -> d.getLaboratoire() != null)
                .collect(Collectors.groupingBy(d -> d.getLaboratoire().getNom(), Collectors.counting()));
    }

    // Statistique 3 : Répartition par Secteur (basé sur le champ "secteur" de l'entité These)
    public Map<String, Long> getStatsSecteurs() {
        return theseRepository.findAll().stream()
                .filter(t -> t.getSecteur() != null)
                .collect(Collectors.groupingBy(These::getSecteur, Collectors.counting()));
    }

    public Map<String, Object> getStatistiquesGlobales() {
        return Map.of(
                "totalDoctorants", getTotalDoctorants(),
                "totalTheses", getTotalTheses(),
                "statsFacultes", getStatsFacultes(),
                "statsLaboratoires", getStatsLaboratoires(),
                "statsSecteurs", getStatsSecteurs()
        );
    }
}