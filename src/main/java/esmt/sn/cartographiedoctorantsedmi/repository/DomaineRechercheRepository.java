package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.DomaineRecherche;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface DomaineRechercheRepository extends JpaRepository<DomaineRecherche, Long> {
    Optional<DomaineRecherche> findByDomaine(String domaine);
}