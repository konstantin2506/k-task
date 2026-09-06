FROM gradle:8-jdk21-alpine AS builder

WORKDIR /app

COPY build.gradle settings.gradle ./

RUN gradle dependencies --no-daemon || true

COPY src ./src

RUN gradle build -x test --no-daemon

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

RUN addgroup -S spring_group && adduser -S spring_user -G spring_group

COPY --from=builder --chown=spring_user:spring_group /app/build/libs/*.jar ./app.jar

ENTRYPOINT [ "java", "-jar", "app.jar" ]
