package esmt.sn.cartographiedoctorantsedmi.config;

import esmt.sn.cartographiedoctorantsedmi.entity.Utilisateur;
import esmt.sn.cartographiedoctorantsedmi.service.UtilisateurService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UtilisateurService utilisateurService;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        OAuth2User oauth2User = super.loadUser(userRequest);

        String email = oauth2User.getAttribute("email");
        String nom = oauth2User.getAttribute("name");
        String providerId = oauth2User.getAttribute("sub");

        Utilisateur utilisateur = utilisateurService.createOrUpdateOAuth2User(email, nom, providerId);

        return new CustomUserDetails(utilisateur, oauth2User.getAttributes());
    }
}