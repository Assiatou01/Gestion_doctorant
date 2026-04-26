package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.Competence;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface CompetenceRepository extends JpaRepository<Competence, Long> {
    Optional<Competence> findByNomCompetence(String nomCompetence);
}