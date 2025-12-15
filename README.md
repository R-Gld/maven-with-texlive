# Maven with TeX Live Docker Image

A Docker image based on Maven 3.9.9 with Eclipse Temurin 21 on Alpine Linux, extended with TeX Live full installation for building LaTeX documents in CI/CD pipelines.

## Purpose

This image was created to optimize CI/CD pipeline execution times for projects that require both Maven and LaTeX compilation capabilities.

### Problem

Installing `texlive-full` directly in CI jobs on each run significantly increases build time:
- **Without pre-installed TeX Live**: ~5 minutes per build (due to texlive-full installation)
- **With this image**: ~15 seconds per build

The standard `texlive` package lacks necessary language support (e.g., French language support), making `texlive-full` a requirement for comprehensive document generation.

## Usage

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/r-gld/maven-with-texlive:latest
```

### Use in GitLab CI

```yaml
build-report:
  image: ghcr.io/r-gld/maven-with-texlive:latest
  script:
    - mvn clean compile
    - # Your LaTeX build commands
```

### Use in Docker Compose

```yaml
services:
  build:
    image: ghcr.io/r-gld/maven-with-texlive:latest
    volumes:
      - ./:/workspace
    working_dir: /workspace
```

### Run Interactively

```bash
docker run -it --rm -v $(pwd):/workspace -w /workspace ghcr.io/r-gld/maven-with-texlive:latest bash
```

## Image Details

- **Base Image**: `maven:3.9.9-eclipse-temurin-21-alpine`
- **Additional Packages**: `texlive-full`
- **Environment Variables**:
  - `MAVEN_OPTS="-Dmaven.repo.local=.m2/repository"`

## Building Locally

If you need to build this image locally:

```bash
docker build -t maven-with-texlive:latest .
```

## Package Registry

This image is publicly available at:
- **GitHub Packages**: https://github.com/users/R-Gld/packages/container/package/maven-with-texlive

## Use Cases

This image is ideal for projects that need to:
- Build Java/Maven projects
- Generate PDF documentation from LaTeX sources
- Automate report generation in CI/CD pipelines
- Support multilingual LaTeX documents (especially French)

## License

This Dockerfile configuration is provided as-is for public use.

## Contributing

This is a simple utility image. If you encounter issues or have suggestions, please feel free to fork and modify for your needs.
