package esmt.sn.cartographiedoctorantsedmi.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {


    @GetMapping("/")
    public String index(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            return "redirect:/dashboard"; // Ou une autre page par défaut
        }
        return "redirect:/login";
    }

//    @GetMapping("/")
//    public String index() {
//        return "redirect:/login";
//    }
}