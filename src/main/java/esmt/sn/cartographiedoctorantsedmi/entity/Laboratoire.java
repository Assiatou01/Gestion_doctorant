package esmt.sn.cartographiedoctorantsedmi.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Laboratoire {

        @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;
        private String nom;


}
