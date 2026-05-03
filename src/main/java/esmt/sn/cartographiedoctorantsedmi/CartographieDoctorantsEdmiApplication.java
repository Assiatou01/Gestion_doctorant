package esmt.sn.cartographiedoctorantsedmi;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.boot.builder.SpringApplicationBuilder;

@SpringBootApplication
public class CartographieDoctorantsEdmiApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(CartographieDoctorantsEdmiApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(CartographieDoctorantsEdmiApplication.class, args);
    }

}
