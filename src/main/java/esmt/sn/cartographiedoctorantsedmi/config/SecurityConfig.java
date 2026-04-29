package esmt.sn.cartographiedoctorantsedmi.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomOAuth2UserService customOAuth2UserService;
    private final AuthenticationSuccessHandler successHandler;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                                .requestMatchers("/", "/login", "/register", "/css/**", "/js/**", "/images/**", "/webjars/**").permitAll()
                                // Pour le test, on autorise tout (à commenter après vérification)
                                .requestMatchers("/these/modifier-moi/**", "/these/supprimer-moi/**", "/doctorant/modifier/**", "/doctorant/upload-cv/**").hasRole("CANDIDAT")
                                .requestMatchers("/doctorant/mes-theses", "/doctorant/details/**", "/these/candidat/**").hasAnyRole("CANDIDAT", "GESTIONNAIRE", "ADMINISTRATEUR")
                                .requestMatchers("/theses", "/these/nouveau", "/these/modifier/**", "/these/supprimer/**", "/dashboard/**").hasAnyRole("GESTIONNAIRE", "ADMINISTRATEUR")
                                .anyRequest().permitAll()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/perform_login")
                        .successHandler(successHandler)
                        .permitAll()
                )
                .oauth2Login(oauth -> oauth
                        .loginPage("/login")
                        .successHandler(successHandler)
                        .userInfoEndpoint(u -> u.userService(customOAuth2UserService))
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                );
        return http.build();
    }
}