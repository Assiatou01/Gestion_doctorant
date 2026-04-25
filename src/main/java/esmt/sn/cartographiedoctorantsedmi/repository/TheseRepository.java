package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.These;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TheseRepository extends JpaRepository<These, Long> {
}
