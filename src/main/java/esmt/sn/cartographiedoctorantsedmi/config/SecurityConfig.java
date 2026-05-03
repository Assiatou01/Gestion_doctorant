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
                        // Pages publiques
                        .requestMatchers("/", "/login", "/register", "/css/**", "/js/**", "/images/**", "/webjars/**").permitAll()

                        // URLs pour le candidat (ses pages personnelles)
                        .requestMatchers("/doctorant/mes-theses", "/these/candidat/**",
                                "/these/modifier-moi/**", "/these/supprimer-moi/**").hasRole("CANDIDAT")

                        // Modification et upload de CV (candidat, gestionnaire et admin)
                        // – le contrôleur vérifiera que le candidat ne modifie que son propre profil
                        .requestMatchers("/doctorant/modifier/**", "/doctorant/upload-cv/**").hasAnyRole("CANDIDAT", "GESTIONNAIRE", "ADMINISTRATEUR")

                        // Pages de gestion (dashboard, listes, thèses, etc.) – réservés aux gestionnaires et admins
                        .requestMatchers("/dashboard/**", "/doctorants", "/theses", "/these/**",
                                "/api/statistiques/**").hasAnyRole("GESTIONNAIRE", "ADMINISTRATEUR")

                        // Administration (domaines, utilisateurs) – réservée à l'admin
                        .requestMatchers("/admin/**").hasRole("ADMINISTRATEUR")

                        // Toute autre requête nécessite une authentification (pour la sécurité)
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