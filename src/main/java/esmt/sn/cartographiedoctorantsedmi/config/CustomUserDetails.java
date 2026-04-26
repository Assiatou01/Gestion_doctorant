package esmt.sn.cartographiedoctorantsedmi.config;

import esmt.sn.cartographiedoctorantsedmi.entity.Utilisateur;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;

public class CustomUserDetails implements UserDetails, OAuth2User {

    @Getter
    private final Utilisateur utilisateur;
    private Map<String, Object> attributes;

    public CustomUserDetails(Utilisateur utilisateur, Map<String, Object> attributes) {
        this.utilisateur = utilisateur;
        this.attributes = attributes;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(
                new SimpleGrantedAuthority("ROLE_" + utilisateur.getRole().name())
        );
    }

    @Override public String getPassword() { return utilisateur.getPassword(); }
    @Override public String getUsername() { return utilisateur.getEmail(); }
    @Override public Map<String, Object> getAttributes() { return attributes; }
    @Override public String getName() { return utilisateur.getEmail(); }
    @Override public boolean isAccountNonExpired() { return true; }
    @Override public boolean isAccountNonLocked() { return true; }
    @Override public boolean isCredentialsNonExpired() { return true; }
    @Override public boolean isEnabled() { return true; }

}