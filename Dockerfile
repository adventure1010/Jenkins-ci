# Use official Tomcat with JDK 17
FROM tomcat:9.0-jdk17

# Clean default webapps to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file into Tomcat and rename it as ROOT.war
# This assumes you already ran `mvn package` and generated `target/vprofile-*.war`
COPY target/vprofile-*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080
docker run -d -p 9000:8080 ...

# Start Tomcat
CMD ["catalina.sh", "run"]
