package esmt.sn.cartographiedoctorantsedmi.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {


//    @Override
//    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
//        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
//        String role = userDetails.getUtilisateur().getRole().name();
//
//        // Redirection propre selon le profil
//        if (role.equals("ADMINISTRATEUR") || role.equals("GESTIONNAIRE")) {
//            response.sendRedirect("/dashboard");
//        } else if (userDetails.getUtilisateur().getDoctorant() != null) {
//            response.sendRedirect("/doctorant/details/" + userDetails.getUtilisateur().getDoctorant().getId());
//        } else {
//            response.sendRedirect("/doctorants");
//        }
//    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        String role = userDetails.getUtilisateur().getRole().name();

        // Debug pour voir ce qui se passe dans la console
        System.out.println("Login réussi ! Email: " + userDetails.getUsername() + " | Role: " + role);

        if (role.equals("ADMINISTRATEUR") || role.equals("GESTIONNAIRE")) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else if (role.equals("CANDIDAT")) {
            if (userDetails.getUtilisateur().getDoctorant() != null) {
                response.sendRedirect(request.getContextPath() + "/doctorant/details/" + userDetails.getUtilisateur().getDoctorant().getId());
            } else {
                // Si c'est un candidat sans fiche doctorant encore créée
                response.sendRedirect(request.getContextPath() + "/doctorants");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        }
    }
}