package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import ru.vsu.cs.MeAndFlora.MainServer.config.property.JwtPropertiesConfig;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.OffsetDateTime;

@Component
@RequiredArgsConstructor
public class JwtUtil {

    private final JwtPropertiesConfig jwtPropertiesConfig;

    public String generateToken(Long sessionId) {
        SecretKey key = Keys.hmacShaKeyFor(jwtPropertiesConfig.getPassword().getBytes(StandardCharsets.UTF_8));
        return Jwts.builder()
                .claim("type", "access")
                .claim("sessionId", sessionId.toString())
                .signWith(key)
                .compact();
    }

    public String generateRToken(Long sessionId) {
        SecretKey key = Keys.hmacShaKeyFor(jwtPropertiesConfig.getPasswordr().getBytes(StandardCharsets.UTF_8));
        return Jwts.builder()
                .claim("type", "refresh")
                .claim("sessionId", sessionId.toString())
                .signWith(key)
                .compact();
    }

    public boolean ifJwtExpired(OffsetDateTime createdTime) {
        return Duration.between(createdTime, OffsetDateTime.now()).compareTo(jwtPropertiesConfig.getLifetime()) > 0;
    }

    public boolean ifJwtRExpired(OffsetDateTime createdTime) {
        return Duration.between(createdTime, OffsetDateTime.now()).compareTo(jwtPropertiesConfig.getLifetimer()) > 0;
    }

}