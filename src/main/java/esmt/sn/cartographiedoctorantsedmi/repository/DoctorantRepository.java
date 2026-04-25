package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.Doctorant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DoctorantRepository extends JpaRepository<Doctorant, Long> {
}
