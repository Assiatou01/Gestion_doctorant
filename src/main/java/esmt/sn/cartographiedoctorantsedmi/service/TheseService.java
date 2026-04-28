package esmt.sn.cartographiedoctorantsedmi.service;

import esmt.sn.cartographiedoctorantsedmi.entity.Doctorant;
import esmt.sn.cartographiedoctorantsedmi.entity.These;
import esmt.sn.cartographiedoctorantsedmi.repository.DoctorantRepository;
import esmt.sn.cartographiedoctorantsedmi.repository.TheseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TheseService {

    private final TheseRepository theseRepository;

    @Transactional
    public void deleteTheseWithRelations(Long id) {
        theseRepository.findByIdWithDoctorants(id).ifPresent(these -> {
            for (Doctorant d : these.getDoctorants()) {
                d.getTheses().remove(these);
            }
            theseRepository.delete(these);
        });
    }

    @Transactional
    public void saveTheseWithDoctorant(These these, Long doctorantId, DoctorantRepository doctorantRepository) {
        if (doctorantId != null) {
            doctorantRepository.findById(doctorantId).ifPresent(doc -> {
                if (!these.getDoctorants().contains(doc)) {
                    these.getDoctorants().add(doc);
                }
                if (!doc.getTheses().contains(these)) {
                    doc.getTheses().add(these);
                }
            });
        }
        theseRepository.save(these);
    }
}