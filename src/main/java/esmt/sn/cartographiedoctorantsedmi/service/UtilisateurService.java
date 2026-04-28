package esmt.sn.cartographiedoctorantsedmi.service;

import esmt.sn.cartographiedoctorantsedmi.config.CustomUserDetails;
import esmt.sn.cartographiedoctorantsedmi.entity.Doctorant;
import esmt.sn.cartographiedoctorantsedmi.entity.Role;
import esmt.sn.cartographiedoctorantsedmi.entity.Utilisateur;
import esmt.sn.cartographiedoctorantsedmi.repository.DoctorantRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class UtilisateurService implements UserDetailsService {

    private final UtilisateurRepository utilisateurRepository;
    private final DoctorantRepository doctorantRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public Utilisateur registerManualUser(String email, String password, Role role, String nom) {
        if (utilisateurRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Email déjà utilisé");
        }

        Doctorant doc = new Doctorant();
        doc.setEmail(email);
        doc.setLastName(nom);
        doc.setFirstName("");
        Doctorant savedDoc = doctorantRepository.save(doc);

        Utilisateur user = Utilisateur.builder()
                .email(email)
                .password(passwordEncoder.encode(password))
                .role(role)
                .doctorant(savedDoc)
                .provider("LOCAL")
                .build();

        return utilisateurRepository.save(user);
    }

    @Transactional
    public Utilisateur createOrUpdateOAuth2User(String email, String nom, String providerId) {
        Optional<Utilisateur> existingUser = utilisateurRepository.findByEmail(email);

        if (existingUser.isPresent()) {
            Utilisateur user = existingUser.get();
            user.setTokenOAuth(providerId);
            if (user.getDoctorant() == null) {
                Doctorant doc = new Doctorant();
                doc.setEmail(email);
                doc.setLastName(nom);
                doc.setFirstName("");
                Doctorant savedDoc = doctorantRepository.save(doc);
                user.setDoctorant(savedDoc);
            }
            return utilisateurRepository.save(user);
        } else {
            Doctorant nouveauDoctorant = new Doctorant();
            nouveauDoctorant.setEmail(email);
            nouveauDoctorant.setLastName(nom);
            nouveauDoctorant.setFirstName("");
            Doctorant savedDoc = doctorantRepository.save(nouveauDoctorant);

            Utilisateur newUser = Utilisateur.builder()
                    .email(email)
                    .tokenOAuth(providerId)
                    .role(Role.CANDIDAT)
                    .doctorant(savedDoc)
                    .provider("GOOGLE")
                    .build();

            return utilisateurRepository.save(newUser);
        }
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        log.debug("Tentative de chargement de l'utilisateur: {}", email);
        Utilisateur utilisateur = utilisateurRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Utilisateur non trouvé: " + email));
        log.debug("Utilisateur trouvé, rôle: {}", utilisateur.getRole());
        return new CustomUserDetails(utilisateur);
    }
}