package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.MotsCles;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface MotsClesRepository extends JpaRepository<MotsCles, Long> {
    Optional<MotsCles> findByMot(String mot);
}