# Étape 1 : Construction de l'application (Build) avec Maven et Java 17
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copier le fichier pom.xml et les sources
COPY pom.xml .
COPY src ./src

# Compiler le projet et créer le fichier .jar (sans lancer les tests pour aller plus vite)
RUN mvn clean package -DskipTests

# Étape 2 : Création de l'image finale allégée pour exécuter l'application
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copier le fichier .war généré depuis l'étape 1
COPY --from=build /app/target/*.war app.war

# Exposer le port par défaut que Render utilise
EXPOSE 10000

# Commande de démarrage de l'application
ENTRYPOINT ["java", "-jar", "app.war"]
