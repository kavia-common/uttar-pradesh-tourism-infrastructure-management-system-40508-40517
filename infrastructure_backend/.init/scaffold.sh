#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/uttar-pradesh-tourism-infrastructure-management-system-40508-40517/infrastructure_backend"
cd "$WORKSPACE"
PROFILE="/etc/profile.d/java_maven.sh"
if [ ! -r "$PROFILE" ]; then echo "ERROR: $PROFILE missing, run install step first" >&2; exit 2; fi
# shellcheck disable=SC1090
source "$PROFILE"
# If user code present (pom.xml or .git), skip scaffolding
if [ -f pom.xml ] || [ -d .git ]; then exit 0; fi
mkdir -p src/main/java/com/example/demo src/main/resources src/test/java/com/example/demo
# Determine runtime java major
JAVA_VER_RAW=$(java -version 2>&1 | awk -F '"' '/version/ {print $2; exit}' || true)
if [ -z "$JAVA_VER_RAW" ]; then JAVA_VER_RAW=$(javac -version 2>&1 | awk '{print $2}' || true); fi
JAVA_MAJOR=$(printf '%s' "$JAVA_VER_RAW" | sed -E 's/^([0-9]+).*/\1/')
if ! printf '%s' "$JAVA_MAJOR" | grep -Eq '^[0-9]+$'; then JAVA_MAJOR=17; fi
# Create pom with explicit spring-boot-maven-plugin
cat > pom.xml <<POM
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>infrastructure-backend</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <packaging>jar</packaging>
  <parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.2.0</version>
    <relativePath/>
  </parent>
  <properties>
    <java.version>$JAVA_MAJOR</java.version>
  </properties>
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <dependency>
      <groupId>com.h2database</groupId>
      <artifactId>h2</artifactId>
      <scope>runtime</scope>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-test</artifactId>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
      </plugin>
    </plugins>
  </build>
</project>
POM
# Application
cat > src/main/java/com/example/demo/DemoApplication.java <<'APP'
package com.example.demo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
@SpringBootApplication
public class DemoApplication {
  public static void main(String[] args) { SpringApplication.run(DemoApplication.class, args); }
}
APP
# Provide a simple ping controller (avoid duplicating actuator /actuator/health)
cat > src/main/java/com/example/demo/PingController.java <<'CTL'
package com.example.demo;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
@RestController
public class PingController {
  @GetMapping("/ping")
  public String ping() { return "pong"; }
}
CTL
# Dev profile using H2
cat > src/main/resources/application-dev.properties <<'APPPR'
spring.datasource.url=jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1
spring.datasource.driverClassName=org.h2.Driver
spring.jpa.hibernate.ddl-auto=update
management.endpoints.web.exposure.include=health
logging.level.root=INFO
APPPR
# Console logging
cat > src/main/resources/logback-spring.xml <<'LOG'
<configuration>
  <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
    <encoder>
      <pattern>%d{HH:mm:ss.SSS} %-5level %logger{36} - %msg%n</pattern>
    </encoder>
  </appender>
  <root level="INFO">
    <appender-ref ref="CONSOLE"/>
  </root>
</configuration>
LOG
# Minimal test
cat > src/test/java/com/example/demo/DemoApplicationTests.java <<'TEST'
package com.example.demo;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
@SpringBootTest
class DemoApplicationTests {
  @Test
  void contextLoads() {}
}
TEST
exit 0
