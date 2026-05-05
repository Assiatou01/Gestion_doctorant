package esmt.sn.cartographiedoctorantsedmi.controller;

import esmt.sn.cartographiedoctorantsedmi.entity.Role;
import esmt.sn.cartographiedoctorantsedmi.entity.Utilisateur;
import esmt.sn.cartographiedoctorantsedmi.repository.UtilisateurRepository;
import esmt.sn.cartographiedoctorantsedmi.service.CsvImportService;
import esmt.sn.cartographiedoctorantsedmi.service.UtilisateurService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final CsvImportService csvImportService;
    private final UtilisateurRepository utilisateurRepository;
    private final UtilisateurService utilisateurService;

    @PostMapping("/import-csv")
    @PreAuthorize("hasAuthority('ROLE_ADMINISTRATEUR')")
    @ResponseBody
    public ResponseEntity<Map<String, String>> importCsv(@RequestParam("file") MultipartFile file) {
        try {
            int count = csvImportService.importDoctorantsFromCsv(file);
            return ResponseEntity.ok(Map.of("message", count + " doctorants importés avec succès"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Erreur : " + e.getMessage()));
        }
    }

    @GetMapping("/utilisateurs")
    @PreAuthorize("hasAuthority('ROLE_ADMINISTRATEUR')")
    public String listeUtilisateurs(Model model) {
        model.addAttribute("utilisateurs", utilisateurRepository.findAll());
        model.addAttribute("roles", Role.values());
        return "admin-utilisateurs";
    }

    @PostMapping("/utilisateur/changer-role")
    @PreAuthorize("hasAuthority('ROLE_ADMINISTRATEUR')")
    public String changerRole(@RequestParam Long id, @RequestParam Role role) {
        Utilisateur user = utilisateurRepository.findById(id).orElseThrow();
        user.setRole(role);
        utilisateurRepository.save(user);
        return "redirect:/admin/utilisateurs";
    }

    @GetMapping("/utilisateur/supprimer/{id}")
    @PreAuthorize("hasAuthority('ROLE_ADMINISTRATEUR')")
    public String supprimerUtilisateur(@PathVariable Long id) {
        utilisateurRepository.deleteById(id);
        return "redirect:/admin/utilisateurs";
    }

    // AJOUT : création d’un nouvel utilisateur (admin ou gestionnaire)
    @PostMapping("/utilisateur/creer")
    @PreAuthorize("hasRole('ADMINISTRATEUR')")
    public String creerUtilisateur(@RequestParam String email,
                                   @RequestParam String password,
                                   @RequestParam Role role,
                                   @RequestParam String nom) {
        utilisateurService.registerManualUser(email, password, role, nom);
        return "redirect:/admin/utilisateurs?created";
    }
}