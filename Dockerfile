# Étape 1 : Construction du WAR
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Étape 2 : Image Tomcat 9 (qui sait compiler et servir les JSP)
FROM tomcat:9-jdk17
# Supprimer l'application par défaut
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copier le WAR généré en tant que ROOT.war (à la racine)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Exposer le port 8080 (Tomcat)
EXPOSE 8080

# Démarrer Tomcat
CMD ["catalina.sh", "run"]