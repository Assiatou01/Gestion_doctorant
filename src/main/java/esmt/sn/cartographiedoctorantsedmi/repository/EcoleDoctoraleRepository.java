package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.EcoleDoctorale;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface EcoleDoctoraleRepository extends JpaRepository<EcoleDoctorale, Long> {
    Optional<EcoleDoctorale> findByNom(String nom);
}