package esmt.sn.cartographiedoctorantsedmi.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Startup {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        private String nomStartup;

        @ManyToOne
        @JoinColumn(name = "doctorant_id")
        private Doctorant doctorant;

}