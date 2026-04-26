package esmt.sn.cartographiedoctorantsedmi.service;

import esmt.sn.cartographiedoctorantsedmi.entity.Utilisateur;
import esmt.sn.cartographiedoctorantsedmi.entity.Doctorant;
import esmt.sn.cartographiedoctorantsedmi.entity.Role;
import esmt.sn.cartographiedoctorantsedmi.repository.UtilisateurRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UtilisateurService {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder passwordEncoder; // Ajoute BCrypt dans AppConfig

    @Transactional
    public Utilisateur registerManualUser(String email, String password, Role role, String nom) {
        // On vérifie si l'email existe déjà
        if(utilisateurRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Email déjà utilisé");
        }

        Doctorant doc = new Doctorant();
        doc.setEmail(email);
        doc.setLastName(nom);

        Utilisateur user = new Utilisateur();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password)); // Cryptage obligatoire
        user.setRole(role);
        user.setDoctorant(doc);
        user.setProvider("LOCAL");

        return utilisateurRepository.save(user);
    }
    public Utilisateur createOrUpdateOAuth2User(String email, String nom, String providerId) {
        Optional<Utilisateur> existingUser = utilisateurRepository.findByEmail(email);

        if (existingUser.isPresent()) {
            Utilisateur user = existingUser.get();
            user.setTokenOAuth(providerId); // On stocke le sub de Google ici
            return utilisateurRepository.save(user);
        } else {
            // 1. Initialisation du profil métier (Doctorant)
            Doctorant nouveauDoctorant = new Doctorant();
            nouveauDoctorant.setEmail(email);
            nouveauDoctorant.setLastName(nom); // On utilise le nom complet de Google

            // 2. Création de l'utilisateur avec son rôle par défaut
            Utilisateur newUser = new Utilisateur();
            newUser.setEmail(email);
            newUser.setTokenOAuth(providerId);
            newUser.setRole(Role.CANDIDAT);
            newUser.setDoctorant(nouveauDoctorant);

            return utilisateurRepository.save(newUser);
        }
    }
}