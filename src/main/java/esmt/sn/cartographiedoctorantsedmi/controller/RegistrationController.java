package esmt.sn.cartographiedoctorantsedmi.controller;

import esmt.sn.cartographiedoctorantsedmi.entity.Role;
import esmt.sn.cartographiedoctorantsedmi.service.UtilisateurService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class RegistrationController {

    private final UtilisateurService utilisateurService;

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("roles", Role.values());
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@RequestParam String email,
                               @RequestParam String password,
                               @RequestParam (required = false, defaultValue = "CANDIDAT") Role role,
                               @RequestParam String nom) {
        try {
            utilisateurService.registerManualUser(email, password, role, nom);
            return "redirect:/login?registered=true";
        } catch (Exception e) {
            return "redirect:/register?error=" + e.getMessage();
        }
    }
}