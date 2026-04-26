package esmt.sn.cartographiedoctorantsedmi.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomOAuth2UserService customOAuth2UserService;
    private final CustomAuthenticationSuccessHandler successHandler;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                    .csrf(AbstractHttpConfigurer::disable)
                    .authorizeHttpRequests(auth -> auth
                            // 1. Autoriser explicitement les ressources critiques et le login
                            .requestMatchers("/", "/login", "/register", "/css/**", "/js/**", "/images/**", "/webjars/**").permitAll()

                            // 2. Vérifier les rôles (Attention : hasRole cherche "ROLE_ADMINISTRATEUR")
                            .requestMatchers("/dashboard/**").hasAnyAuthority("ROLE_ADMINISTRATEUR", "ROLE_GESTIONNAIRE")
                            .requestMatchers("/doctorant/**").hasAnyAuthority("ROLE_ADMINISTRATEUR", "ROLE_GESTIONNAIRE", "ROLE_CANDIDAT")

                            .anyRequest().authenticated()
                    )
                    .formLogin(form -> form
                            .loginPage("/login")
                            .loginProcessingUrl("/perform_login") // Doit correspondre au <form action="...">
                            .successHandler(successHandler) // Ton handler personnalisé
                            .permitAll()
                    )
                    .oauth2Login(oauth -> oauth
                            .loginPage("/login")
                            .successHandler(successHandler) // Utilise AUSSI le handler pour Google
                            .userInfoEndpoint(u -> u.userService(customOAuth2UserService))
                            .permitAll()
                    )
                    // ... reste du code
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                );

        return http.build();

    }
}