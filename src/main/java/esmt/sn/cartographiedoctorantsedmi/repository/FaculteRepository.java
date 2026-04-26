package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.Faculte;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface FaculteRepository extends JpaRepository<Faculte, Long> {
    Optional<Faculte> findByNom(String nom);
}
