package esmt.sn.cartographiedoctorantsedmi.controller;

import esmt.sn.cartographiedoctorantsedmi.entity.DomaineRecherche;
import esmt.sn.cartographiedoctorantsedmi.repository.DomaineRechercheRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/domaines")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMINISTRATEUR')")
public class DomaineController {

    private final DomaineRechercheRepository domaineRepository;

    @GetMapping
    public String listeDomaines(Model model) {
        model.addAttribute("domaines", domaineRepository.findAll());
        return "admin-domaines";
    }

    @PostMapping("/ajouter")
    public String ajouterDomaine(@RequestParam String domaine) {
        DomaineRecherche d = new DomaineRecherche();
        d.setDomaine(domaine);
        domaineRepository.save(d);
        return "redirect:/admin/domaines";
    }

    @GetMapping("/supprimer/{id}")
    public String supprimerDomaine(@PathVariable Long id) {
        domaineRepository.deleteById(id);
        return "redirect:/admin/domaines";
    }

    @PostMapping("/modifier/{id}")
    public String modifierDomaine(@PathVariable Long id, @RequestParam String domaine) {
        DomaineRecherche d = domaineRepository.findById(id).orElseThrow();
        d.setDomaine(domaine);
        domaineRepository.save(d);
        return "redirect:/admin/domaines";
    }
}