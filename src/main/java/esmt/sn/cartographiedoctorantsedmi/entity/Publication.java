package esmt.sn.cartographiedoctorantsedmi.entity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Publication {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String titreOuLien;

}
