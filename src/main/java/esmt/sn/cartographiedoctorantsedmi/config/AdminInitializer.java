package esmt.sn.cartographiedoctorantsedmi.config;

import esmt.sn.cartographiedoctorantsedmi.entity.Doctorant;
import esmt.sn.cartographiedoctorantsedmi.entity.Role;
import esmt.sn.cartographiedoctorantsedmi.entity.Utilisateur;
import esmt.sn.cartographiedoctorantsedmi.repository.DoctorantRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.UtilisateurRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class AdminInitializer implements CommandLineRunner {

    private final UtilisateurRepository utilisateurRepository;
    private final DoctorantRepository doctorantRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${admin.email}")
    private String adminEmail;

    @Value("${admin.password}")
    private String adminPassword;

    @Override
    @Transactional
    public void run(String... args) {
        // Vérifier que les variables sont bien définies
        if (adminEmail == null || adminPassword == null || adminEmail.isBlank() || adminPassword.isBlank()) {
            log.error("❌ Les variables d'environnement ADMIN_EMAIL et ADMIN_PASSWORD doivent être définies.");
            throw new IllegalStateException("Impossible de créer le compte admin : variables manquantes.");
        }

        if (utilisateurRepository.count() == 0) {
            log.info("Aucun utilisateur – création du compte administrateur par défaut.");

            Doctorant doctorantAdmin = new Doctorant();
            doctorantAdmin.setEmail(adminEmail);
            doctorantAdmin.setLastName("Admin");
            doctorantAdmin.setFirstName("Super");

            Utilisateur admin = Utilisateur.builder()
                    .email(adminEmail)
                    .password(passwordEncoder.encode(adminPassword))
                    .role(Role.ADMINISTRATEUR)
                    .doctorant(doctorantAdmin)
                    .provider("LOCAL")
                    .build();

            utilisateurRepository.save(admin);
            log.info(" Compte ADMIN créé : {}", adminEmail);
            log.warn(" Mot de passe défini par variable d'environnement (non affiché).");
        }
    }
}