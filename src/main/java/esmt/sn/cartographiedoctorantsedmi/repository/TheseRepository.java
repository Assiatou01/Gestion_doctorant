package esmt.sn.cartographiedoctorantsedmi.repository;

import esmt.sn.cartographiedoctorantsedmi.entity.These;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface TheseRepository extends JpaRepository<These, Long> {

    @Query("SELECT t FROM These t JOIN t.doctorants d WHERE d.id = :doctorantId")
    List<These> findByDoctorantId(@Param("doctorantId") Long doctorantId);

    @Query("SELECT t FROM These t LEFT JOIN FETCH t.doctorants WHERE t.id = :id")
    Optional<These> findByIdWithDoctorants(@Param("id") Long id);
}