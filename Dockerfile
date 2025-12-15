# Dockerfile for building a Maven project with TeX Live support
# Pushed to https://github.com/users/R-Gld/packages/container/package/maven-with-texlive
# Base image used in .gitlab-ci.yml
FROM maven:3.9.9-eclipse-temurin-21-alpine

# Install TeX Live
RUN apk add --no-cache texlive-full

ENV MAVEN_OPTS="-Dmaven.repo.local=.m2/repository"

LABEL org.opencontainers.image.source=https://github.com/R-Gld/maven-with-texlive \
      org.opencontainers.image.title="Maven with TeX Live" \
      org.opencontainers.image.description="Maven 3.9.9 + Eclipse Temurin 21 on Alpine, with TeX Live for LaTeX builds" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.vendor="R-Gld"