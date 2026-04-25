package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.Utilisateur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UtilisateurRepository extends JpaRepository<Utilisateur, Long> {
    // Cette méthode permettra  de trouver un utilisateur par son email pour l'authentification OAuth !
    Optional<Utilisateur> findByEmail(String email);
}
