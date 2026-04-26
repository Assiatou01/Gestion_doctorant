package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.Laboratoire;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface LaboratoireRepository extends JpaRepository<Laboratoire, Long> {
    Optional<Laboratoire> findByNom(String nom);
}