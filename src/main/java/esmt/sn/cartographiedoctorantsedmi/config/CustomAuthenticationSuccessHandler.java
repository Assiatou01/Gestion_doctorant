package esmt.sn.cartographiedoctorantsedmi.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import java.io.IOException;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private static final Logger log = LoggerFactory.getLogger(CustomAuthenticationSuccessHandler.class);

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        String role = userDetails.getUtilisateur().getRole().name();

        request.getSession().setAttribute("user", userDetails.getUtilisateur());
        request.getSession().setAttribute("isCandidat", role.equals("CANDIDAT"));

        log.info("Connexion réussie : {} ({})", userDetails.getUsername(), role);

        switch (role) {
            case "CANDIDAT":
                response.sendRedirect(request.getContextPath() + "/doctorant/mes-theses");
                break;
            case "GESTIONNAIRE":
            case "ADMINISTRATEUR":
                response.sendRedirect(request.getContextPath() + "/dashboard");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}