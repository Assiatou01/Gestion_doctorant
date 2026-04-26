package esmt.sn.cartographiedoctorantsedmi.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Doctorant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String lastName;
    private String firstName;
    private String email;
    private String telephone;

    private LocalDate dateStart;
    private LocalDate dateEnd;

    @Column(columnDefinition = "TEXT")
    private String maturation;

    @Column(columnDefinition = "TEXT")
    private String interet;

    @Column(columnDefinition = "TEXT")
    private String souhait;

    @Column(columnDefinition = "TEXT")
    private String cv;

    private Boolean publicationFaire;

    @ManyToOne
    @JoinColumn(name = "faculte_id")
    private Faculte faculte;

    @ManyToOne
    @JoinColumn(name = "laboratoire_id")
    private Laboratoire laboratoire;

    @ManyToOne
    @JoinColumn(name = "ecole_doctorale_id")
    private EcoleDoctorale ecoleDoctorale;

    @ManyToMany
    @JoinTable(
            name = "doctorant_these",
            joinColumns = @JoinColumn(name = "doctorant_id"),
            inverseJoinColumns = @JoinColumn(name = "these_id")
    )
    @JsonIgnore
    private List<These> theses = new ArrayList<>();

    @OneToMany(mappedBy = "doctorant", cascade = CascadeType.ALL)
    private List<Startup> startups = new ArrayList<>();

    @ManyToMany
    @JoinTable(
            name = "doctorant_competence",
            joinColumns = @JoinColumn(name = "doctorant_id"),
            inverseJoinColumns = @JoinColumn(name = "competence_id")
    )
    @JsonIgnore
    private List<Competence> competences = new ArrayList<>();

    @ManyToMany
    @JoinTable(
            name = "doctorant_domaine",
            joinColumns = @JoinColumn(name = "doctorant_id"),
            inverseJoinColumns = @JoinColumn(name = "domaine_id")
    )
    @JsonIgnore
    private List<DomaineRecherche> domainesRecherche = new ArrayList<>();

    @ManyToMany
    @JoinTable(
            name = "doctorant_publication",
            joinColumns = @JoinColumn(name = "doctorant_id"),
            inverseJoinColumns = @JoinColumn(name = "publication_id")
    )
    @JsonIgnore
    private List<Publication> publications = new ArrayList<>();
}