package esmt.sn.cartographiedoctorantsedmi.controller;

import esmt.sn.cartographiedoctorantsedmi.service.StatistiquesService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
@RequestMapping("/api/statistiques")
@RequiredArgsConstructor
public class StatistiquesController {

    private final StatistiquesService statistiquesService;

    @GetMapping("/globales")
    public ResponseEntity<Map<String, Object>> getStats() {
        return ResponseEntity.ok(Map.of(
                "totalDoctorants", statistiquesService.getTotalDoctorants(),
                "totalTheses", statistiquesService.getTotalTheses(),
                "statsFacultes", statistiquesService.getStatsFacultes(),
                "statsLaboratoires", statistiquesService.getStatsLaboratoires(),
                "statsSecteurs", statistiquesService.getStatsSecteurs(),
                "thesesParDoctorant", statistiquesService.getThesesParDoctorant()
        ));
    }
}