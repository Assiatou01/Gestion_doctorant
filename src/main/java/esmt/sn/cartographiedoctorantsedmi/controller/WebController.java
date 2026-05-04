package esmt.sn.cartographiedoctorantsedmi.controller;

import esmt.sn.cartographiedoctorantsedmi.config.CustomUserDetails;
import esmt.sn.cartographiedoctorantsedmi.entity.Doctorant;
import esmt.sn.cartographiedoctorantsedmi.entity.Faculte;
import esmt.sn.cartographiedoctorantsedmi.entity.Laboratoire;
import esmt.sn.cartographiedoctorantsedmi.entity.These;
import esmt.sn.cartographiedoctorantsedmi.repository.DoctorantRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.FaculteRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.LaboratoireRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.TheseRepository;
import esmt.sn.cartographiedoctorantsedmi.service.StatistiquesService;
import esmt.sn.cartographiedoctorantsedmi.service.TheseService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class WebController {

    private final StatistiquesService statistiquesService;
    private final DoctorantRepository doctorantRepository;
    private final FaculteRepository faculteRepository;
    private final LaboratoireRepository laboratoireRepository;
    private final TheseRepository theseRepository;
    private final TheseService theseService;

    // ========== Dashboard (pour gestionnaire/admin) ==========
    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        model.addAttribute("totalDoctorants", statistiquesService.getTotalDoctorants());
        model.addAttribute("totalTheses", statistiquesService.getTotalTheses());
        model.addAttribute("statsFacultes", statistiquesService.getStatsFacultes());
        model.addAttribute("statsLabos", statistiquesService.getStatsLaboratoires());
        model.addAttribute("statsSecteurs", statistiquesService.getStatsSecteurs());
        return "dashboard";
    }

    // ========== Candidat : voir ses propres thèses ==========
    @GetMapping("/doctorant/mes-theses")
    public String mesTheses(Authentication auth, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long doctorantId = userDetails.getUtilisateur().getDoctorant().getId();
        List<These> mesTheses = theseRepository.findByDoctorantId(doctorantId);
        model.addAttribute("listeTheses", mesTheses);
        model.addAttribute("isCandidat", true);
        return "theses";
    }

    // ========== Candidat : formulaire pour créer une thèse ==========
    @GetMapping("/these/candidat/nouveau")
    public String nouvelleTheseCandidat(Authentication auth, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long doctorantId = userDetails.getUtilisateur().getDoctorant().getId();
        These these = new These();
        model.addAttribute("these", these);
        model.addAttribute("candidatId", doctorantId);
        return "these-form";
    }

    // ========== Candidat : sauvegarde de sa propre thèse ==========
    @PostMapping("/these/candidat/save")
    public String saveTheseCandidat(@ModelAttribute These these, @RequestParam Long candidatId, Authentication auth) {
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long authenticatedId = userDetails.getUtilisateur().getDoctorant().getId();
        if (!authenticatedId.equals(candidatId)) {
            return "redirect:/doctorant/mes-theses?error=unauthorized";
        }
        Doctorant doc = doctorantRepository.findById(candidatId).orElseThrow();
        these.getDoctorants().add(doc);
        theseService.saveTheseWithDoctorant(these, candidatId, doctorantRepository);
        return "redirect:/doctorant/mes-theses";
    }

    // ========== Candidat : modifier sa thèse ==========
    @GetMapping("/these/modifier-moi/{id}")
    public String modifierThesePourMoi(@PathVariable Long id, Authentication auth, Model model) {
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long doctorantId = userDetails.getUtilisateur().getDoctorant().getId();
        These these = theseRepository.findById(id).orElseThrow();
        if (these.getDoctorants().stream().noneMatch(d -> d.getId().equals(doctorantId))) {
            return "redirect:/doctorant/mes-theses?error=unauthorized";
        }
        model.addAttribute("these", these);
        model.addAttribute("candidatId", doctorantId);
        return "these-form";
    }

    // ========== Candidat : supprimer sa thèse ==========
    @GetMapping("/these/supprimer-moi/{id}")
    public String supprimerThesePourMoi(@PathVariable Long id, Authentication auth) {
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long doctorantId = userDetails.getUtilisateur().getDoctorant().getId();
        These these = theseRepository.findById(id).orElseThrow();
        if (these.getDoctorants().stream().noneMatch(d -> d.getId().equals(doctorantId))) {
            return "redirect:/doctorant/mes-theses?error=unauthorized";
        }
        theseService.deleteTheseWithRelations(id);
        return "redirect:/doctorant/mes-theses";
    }

    // ========== Upload d'un CV (candidat, gestionnaire ou admin) ==========
    @PostMapping("/doctorant/upload-cv/{id}")
    public String uploadCv(@PathVariable Long id,
                           @RequestParam("file") MultipartFile file,
                           Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long currentDoctorantId = userDetails.getUtilisateur().getDoctorant().getId();
        String role = userDetails.getUtilisateur().getRole().name();

        boolean isAdminOrManager = role.equals("ADMINISTRATEUR") || role.equals("GESTIONNAIRE");
        boolean isOwner = currentDoctorantId.equals(id);
        if (!isAdminOrManager && !isOwner) {
            return "redirect:/doctorant/details/" + id + "?error=unauthorized";
        }

        if (file.isEmpty()) {
            return "redirect:/doctorant/details/" + id + "?error=emptyfile";
        }

        try {
            String uploadDir = "uploads/cvs/";
            String originalName = file.getOriginalFilename();
            String extension = originalName.substring(originalName.lastIndexOf("."));
            String fileName = "cv_" + id + "_" + System.currentTimeMillis() + extension;
            Path path = Paths.get(uploadDir + fileName);
            Files.createDirectories(path.getParent());
            Files.write(path, file.getBytes());

            Doctorant doc = doctorantRepository.findById(id).orElseThrow();
            doc.setCv("/uploads/cvs/" + fileName);
            doctorantRepository.save(doc);

            return "redirect:/doctorant/details/" + id + "?success=cvUpdated";
        } catch (IOException e) {
            e.printStackTrace();
            return "redirect:/doctorant/details/" + id + "?error=uploadFailed";
        }
    }

    // ========== Détail d'un doctorant (candidat ne voit que le sien) avec dates formatées ==========
    @GetMapping("/doctorant/details/{id}")
    public String showDoctorantDetails(@PathVariable Long id, Model model, Authentication authentication) {
        if (authentication != null && authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_CANDIDAT"))) {
            CustomUserDetails ud = (CustomUserDetails) authentication.getPrincipal();
            Long myId = ud.getUtilisateur().getDoctorant().getId();
            if (!myId.equals(id)) {
                return "redirect:/doctorant/mes-theses?error=unauthorized";
            }
        }
        return doctorantRepository.findById(id)
                .map(doc -> {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM yyyy");
                    if (doc.getDateStart() != null) {
                        model.addAttribute("dateStartFormatted", doc.getDateStart().format(formatter));
                    }
                    if (doc.getDateEnd() != null) {
                        model.addAttribute("dateEndFormatted", doc.getDateEnd().format(formatter));
                    }
                    model.addAttribute("doctorant", doc);
                    return "doctorant-details";
                })
                .orElse("redirect:/doctorants");
    }

    // ========== Modifier doctorant (candidat ne peut modifier que lui-même) ==========
    @GetMapping("/doctorant/modifier/{id}")
    public String editDoctorantForm(@PathVariable Long id, Model model, Authentication authentication) {
        if (authentication != null && authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_CANDIDAT"))) {
            CustomUserDetails ud = (CustomUserDetails) authentication.getPrincipal();
            Long myId = ud.getUtilisateur().getDoctorant().getId();
            if (!myId.equals(id)) {
                return "redirect:/doctorant/mes-theses?error=unauthorized";
            }
        }
        return doctorantRepository.findById(id)
                .map(doc -> {
                    model.addAttribute("doctorant", doc);
                    model.addAttribute("facultes", faculteRepository.findAll());
                    model.addAttribute("laboratoires", laboratoireRepository.findAll());
                    return "doctorant-form";
                })
                .orElse("redirect:/doctorants");
    }

    // ========== Sauvegarde doctorant ==========
//    @PostMapping("/doctorant/save")
//    public String saveDoctorant(Doctorant doctorant) {
//        doctorantRepository.save(doctorant);
//        return "redirect:/doctorants";
//    }

    @PostMapping("/doctorant/save")
    public String saveDoctorant(@ModelAttribute Doctorant doctorant,
                                @RequestParam(value = "faculte.id", required = false) Long faculteId,
                                @RequestParam(value = "laboratoire.id", required = false) Long laboratoireId) {

        if (faculteId != null) {
            Faculte faculte = faculteRepository.findById(faculteId).orElse(null);
            doctorant.setFaculte(faculte);
        } else {
            doctorant.setFaculte(null);
        }

        if (laboratoireId != null) {
            Laboratoire labo = laboratoireRepository.findById(laboratoireId).orElse(null);
            doctorant.setLaboratoire(labo);
        } else {
            doctorant.setLaboratoire(null);
        }

        doctorantRepository.save(doctorant);
        return "redirect:/doctorants";
    }

    // ========== Gestionnaire/admin : toutes les thèses ==========
    @GetMapping("/theses")
    public String showThesesList(Model model) {
        model.addAttribute("listeTheses", theseRepository.findAll());
        model.addAttribute("isCandidat", false);
        return "theses";
    }

    @GetMapping("/these/nouveau")
    public String addTheseForm(Model model) {
        model.addAttribute("these", new These());
        model.addAttribute("doctorants", doctorantRepository.findAll());
        return "these-form";
    }

    @GetMapping("/these/modifier/{id}")
    public String editTheseForm(@PathVariable Long id, Model model) {
        return theseRepository.findById(id)
                .map(t -> {
                    model.addAttribute("these", t);
                    model.addAttribute("doctorants", doctorantRepository.findAll());
                    return "these-form";
                })
                .orElse("redirect:/theses");
    }

    @PostMapping("/these/save")
    public String saveThese(@ModelAttribute These these, @RequestParam(required = false) Long doctorantId) {
        theseService.saveTheseWithDoctorant(these, doctorantId, doctorantRepository);
        return "redirect:/theses";
    }

    @GetMapping("/these/supprimer/{id}")
    public String deleteThese(@PathVariable Long id) {
        theseService.deleteTheseWithRelations(id);
        return "redirect:/theses";
    }

    // ========== Liste des doctorants (accessible à gestionnaire/admin uniquement) ==========
//    @GetMapping("/doctorants")
//    public String showDoctorantsList(Model model, Authentication authentication) {
//        if (authentication != null && authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_CANDIDAT"))) {
//            return "redirect:/doctorant/mes-theses?error=unauthorized";
//        }
//        model.addAttribute("listeDoctorants", doctorantRepository.findAll());
//        return "doctorants";
//    }
    @GetMapping("/doctorants")
    public String showDoctorantsList(@RequestParam(required = false) Long laboratoireId,
                                     Model model, Authentication authentication) {
        if (authentication != null && authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_CANDIDAT"))) {
            return "redirect:/doctorant/mes-theses?error=unauthorized";
        }

        List<Doctorant> doctorants;
        if (laboratoireId != null && laboratoireId > 0) {
            doctorants = doctorantRepository.findByLaboratoireId(laboratoireId);
        } else {
            doctorants = doctorantRepository.findAll();
        }

        model.addAttribute("listeDoctorants", doctorants);
        model.addAttribute("laboratoires", laboratoireRepository.findAll());
        model.addAttribute("selectedLaboratoireId", laboratoireId);
        return "doctorants";
    }

    @GetMapping("/doctorant/nouveau")
    public String addDoctorantForm(Model model) {
        model.addAttribute("doctorant", new Doctorant());
        model.addAttribute("facultes", faculteRepository.findAll());
        model.addAttribute("laboratoires", laboratoireRepository.findAll());
        return "doctorant-form";
    }

    @GetMapping("/doctorant/supprimer/{id}")
    public String deleteDoctorant(@PathVariable Long id) {
        doctorantRepository.deleteById(id);
        return "redirect:/doctorants";
    }

    @GetMapping("/statistiques")
    public String statistiques() {
        return "statistiques";
    }
}