package esmt.sn.cartographiedoctorantsedmi.service;

import esmt.sn.cartographiedoctorantsedmi.repository.DoctorantRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.TheseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

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

    // Exemple de stat (Projets par statut ou autre)
    public Map<String, Object> getStatistiquesGlobales() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total_candidats", doctorantRepository.count());
        stats.put("total_theses_projets", theseRepository.count());
        return stats;
    }
}
