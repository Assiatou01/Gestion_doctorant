package esmt.sn.cartographiedoctorantsedmi.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class These {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "TEXT")
    private String intitule;
    @Column(columnDefinition = "TEXT")
    private String problematique;
    @Column(columnDefinition = "TEXT")
    private String solution;
    private String secteur;
    @Column(columnDefinition = "TEXT")
    private String impact;

    @ManyToMany
    @JoinTable(
            name = "these_motscles",
            joinColumns = @JoinColumn(name = "these_id"),
            inverseJoinColumns = @JoinColumn(name = "motscles_id")
    )
    @JsonIgnore
    private List<MotsCles> motsCles = new ArrayList<>();
    @ManyToMany(mappedBy = "theses")
    private List<Doctorant> doctorants = new ArrayList<>();

}
