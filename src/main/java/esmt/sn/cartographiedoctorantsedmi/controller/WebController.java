package esmt.sn.cartographiedoctorantsedmi.controller;

import esmt.sn.cartographiedoctorantsedmi.entity.Doctorant;
import esmt.sn.cartographiedoctorantsedmi.entity.These;
import esmt.sn.cartographiedoctorantsedmi.repository.DoctorantRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.FaculteRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.LaboratoireRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.TheseRepository;
import esmt.sn.cartographiedoctorantsedmi.service.StatistiquesService;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class WebController {

    private final StatistiquesService statistiquesService;
    private final DoctorantRepository doctorantRepository;
    private final FaculteRepository faculteRepository;
    private final LaboratoireRepository laboratoireRepository;
    private final TheseRepository theseRepository;

//    @GetMapping("/dashboard")
//    public String showDashboard(Model model) {
//        model.addAttribute("totalDoctorants", statistiquesService.getTotalDoctorants());
//        model.addAttribute("totalTheses", statistiquesService.getTotalTheses());
//        model.addAttribute("statsFacultes", statistiquesService.getRepartitionParFaculte());
//        return "dashboard";
//    }

    @GetMapping("/dashboard")
    public String showDashboard(Model model, HttpSession session) {
        model.addAttribute("totalDoctorants", statistiquesService.getTotalDoctorants());
        model.addAttribute("totalTheses", statistiquesService.getTotalTheses());

        // On utilise les noms exacts de vos méthodes du service
        model.addAttribute("statsFacultes", statistiquesService.getStatsFacultes());
        model.addAttribute("statsLabos", statistiquesService.getStatsLaboratoires());
        model.addAttribute("statsSecteurs", statistiquesService.getStatsSecteurs());

        return "dashboard";
    }

    @GetMapping("/doctorants")
    public String showDoctorantsList(Model model) {
        model.addAttribute("listeDoctorants", doctorantRepository.findAll());
        return "doctorants";
    }

    @GetMapping("/doctorant/nouveau")
    public String addDoctorantForm(Model model) {
        model.addAttribute("doctorant", new Doctorant());
        model.addAttribute("facultes", faculteRepository.findAll());
        model.addAttribute("laboratoires", laboratoireRepository.findAll());
        return "doctorant-form";
    }

    @GetMapping("/doctorant/modifier/{id}")
    public String editDoctorantForm(@PathVariable Long id, Model model) {
        return doctorantRepository.findById(id)
                .map(doc -> {
                    model.addAttribute("doctorant", doc);
                    model.addAttribute("facultes", faculteRepository.findAll());
                    model.addAttribute("laboratoires", laboratoireRepository.findAll());
                    return "doctorant-form";
                })
                .orElse("redirect:/doctorants");
    }

    @PostMapping("/doctorant/save")
    public String saveDoctorant(Doctorant doctorant) {
        doctorantRepository.save(doctorant);
        return "redirect:/doctorants";
    }

    @GetMapping("/doctorant/supprimer/{id}")
    public String deleteDoctorant(@PathVariable Long id) {
        doctorantRepository.deleteById(id);
        return "redirect:/doctorants";
    }

    @GetMapping("/doctorant/details/{id}")
    public String showDoctorantDetails(@PathVariable Long id, Model model) {
        return doctorantRepository.findById(id)
                .map(doc -> {
                    model.addAttribute("doctorant", doc);
                    return "doctorant-details";
                })
                .orElse("redirect:/doctorants");
    }


    // Pour these

    @GetMapping("/theses")
    public String showThesesList(Model model) {
        model.addAttribute("listeTheses", theseRepository.findAll());
        return "theses";
    }

    @GetMapping("/these/details/{id}")
    public String showTheseDetails(@PathVariable Long id, Model model) {
        return theseRepository.findById(id)
                .map(these -> {
                    model.addAttribute("these", these);
                    return "these-details";
                })
                .orElse("redirect:/theses");
    }



    @GetMapping("/these/supprimer/{id}")
    @Transactional // Ajout de Transactional pour assurer la cohérence
    public String deleteThese(@PathVariable Long id) {
        try {
            theseRepository.findById(id).ifPresent(these -> {
                // Rompre les liens avec les doctorants pour éviter les violations de FK
                if (these.getDoctorants() != null) {
                    for (Doctorant d : these.getDoctorants()) {
                        d.getTheses().remove(these);
                    }
                }
                // Supprimer la thèse après avoir nettoyé les relations
                theseRepository.delete(these);
            });
        } catch (Exception e) {
            System.err.println("Erreur de suppression : " + e.getMessage());
        }
        return "redirect:/theses";
    }
//    @GetMapping("/these/nouveau")
//    public String addTheseForm(Model model) {
//        model.addAttribute("these", new These());
//        return "these-form";
//    }
//
//    @GetMapping("/these/modifier/{id}")
//    public String editTheseForm(@PathVariable Long id, Model model) {
//        return theseRepository.findById(id)
//                .map(t -> {
//                    model.addAttribute("these", t);
//                    return "these-form";
//                })
//                .orElse("redirect:/theses");
//    }

//    @PostMapping("/these/save")
//    public String saveThese(These these) {
//        theseRepository.save(these);
//        return "redirect:/theses";
//    }
@GetMapping("/these/nouveau")
public String addTheseForm(Model model) {
    model.addAttribute("these", new These());
    // AJOUT : Charger la liste des doctorants pour le select
    model.addAttribute("doctorants", doctorantRepository.findAll());
    return "these-form";
}

    @GetMapping("/these/modifier/{id}")
    public String editTheseForm(@PathVariable Long id, Model model) {
        return theseRepository.findById(id)
                .map(t -> {
                    model.addAttribute("these", t);
                    // AJOUT : Charger la liste des doctorants pour le select
                    model.addAttribute("doctorants", doctorantRepository.findAll());
                    return "these-form";
                })
                .orElse("redirect:/theses");
    }
//    @PostMapping("/these/save")
//    //public String saveThese(These these, Long doctorantId) {
//    public String saveThese(These these, @RequestParam(required = false) Long doctorantId) {
//        if (doctorantId != null) {
//            doctorantRepository.findById(doctorantId).ifPresent(doc -> {
//                these.getDoctorants().add(doc);
//                doc.getTheses().add(these);
//            });
//        }
//        theseRepository.save(these);
//        return "redirect:/theses";
//    }

    @PostMapping("/these/save")
    @Transactional
    public String saveThese(These these, @RequestParam(required = false) Long doctorantId) {
        if (doctorantId != null) {
            doctorantRepository.findById(doctorantId).ifPresent(doc -> {
                // Association bidirectionnelle sécurisée
                if (!these.getDoctorants().contains(doc)) {
                    these.getDoctorants().add(doc);
                }
                if (!doc.getTheses().contains(these)) {
                    doc.getTheses().add(these);
                }
            });
        }
        theseRepository.save(these);
        return "redirect:/theses";
    }


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

}