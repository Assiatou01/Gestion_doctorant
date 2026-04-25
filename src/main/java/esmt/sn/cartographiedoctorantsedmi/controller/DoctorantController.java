package esmt.sn.cartographiedoctorantsedmi.controller;

import esmt.sn.cartographiedoctorantsedmi.entity.Doctorant;
import esmt.sn.cartographiedoctorantsedmi.repository.DoctorantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/doctorants")
@RequiredArgsConstructor
public class DoctorantController {

    private final DoctorantRepository doctorantRepository;

    @GetMapping
    public ResponseEntity<List<Doctorant>> getAllDoctorants() {
        // Envoyer tous les doctorants transformés en JSON !
        return ResponseEntity.ok(doctorantRepository.findAll());
    }
}
