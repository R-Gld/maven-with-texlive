# Maven with TeX Live Docker Image

A Docker image based on Maven 3.9.9 with Eclipse Temurin 21 on Alpine Linux, extended with TeX Live full installation for building LaTeX documents in CI/CD pipelines.

## Purpose

This image was created to optimize CI/CD pipeline execution times for projects that require both Maven and LaTeX compilation capabilities.

### Problem

Installing `texlive-full` directly in CI jobs on each run significantly increases build time:
- **Without pre-installed TeX Live**: ~5 minutes per build (due to texlive-full installation)
- **With this image**: ~15 seconds per build

The standard `texlive` package lacks necessary language support (e.g., French language support), making `texlive-full` a requirement for comprehensive document generation.

## Available Tags

- `latest` - amd64 version (most common architecture)
- `amd64` - amd64/x86_64 version
- `arm64` - ARM64/aarch64 version (Apple Silicon, Raspberry Pi, etc.)

## Usage

### Pull from GitHub Container Registry

```bash
# Pull latest (amd64)
docker pull ghcr.io/r-gld/maven-with-texlive:latest

# Pull specific architecture
docker pull ghcr.io/r-gld/maven-with-texlive:arm64
docker pull ghcr.io/r-gld/maven-with-texlive:amd64
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

- **Base Image**: `maven:3.9.9-eclipse-temurin-21-alpine` (configurable)
- **Additional Packages**: `texlive-full`
- **Environment Variables**:
  - `MAVEN_OPTS="-Dmaven.repo.local=.m2/repository"`

### Configurable Build Arguments

The Dockerfile supports the following build arguments to customize the base image:

| Argument | Default Value | Description |
|----------|---------------|-------------|
| `MAVEN_VERSION` | `3.9.9` | Maven version to use |
| `JDK_TYPE` | `eclipse-temurin` | JDK distribution (e.g., `eclipse-temurin`, `amazoncorretto`, `ibm-semeru-jamvm`) |
| `JAVA_VERSION` | `21` | Java version (e.g., `17`, `21`, `22`) |
| `DISTRO` | `alpine` | Base distribution (e.g., `alpine`, `jammy`, `ubi9`) |

## Building the Image

### Using the Automated Script (Recommended)

The script automatically detects your system architecture and builds the appropriate image:

```bash
./build-docker-image.sh
```

**What the script does:**

1. **Detects architecture** automatically (arm64 or amd64)
2. **Builds the image** with appropriate tags:
   - On **arm64** (Mac M2 Pro, etc.): tags as `arm64`
   - On **amd64** (x86_64): tags as `amd64` and `latest`
3. **Prompts for push**: asks if you want to push to GitHub Packages

### Manual Build Commands

#### On ARM64 systems (Mac M2 Pro, etc.)

```bash
# Using default versions
docker build --platform linux/arm64 -t ghcr.io/r-gld/maven-with-texlive:arm64 .

# Custom versions
docker build --platform linux/arm64 \
  --build-arg MAVEN_VERSION=3.9.10 \
  --build-arg JAVA_VERSION=22 \
  -t ghcr.io/r-gld/maven-with-texlive:arm64 .
```

#### On AMD64 systems (x86_64)

```bash
# Using default versions
docker build --platform linux/amd64 \
  -t ghcr.io/r-gld/maven-with-texlive:amd64 \
  -t ghcr.io/r-gld/maven-with-texlive:latest \
  .

# Custom versions
docker build --platform linux/amd64 \
  --build-arg MAVEN_VERSION=3.9.10 \
  --build-arg JAVA_VERSION=22 \
  -t ghcr.io/r-gld/maven-with-texlive:amd64 \
  -t ghcr.io/r-gld/maven-with-texlive:latest \
  .
```

### Customization Examples

#### Using a Different JDK Distribution

```bash
# Amazon Corretto JDK
docker build \
  --build-arg JDK_TYPE=amazoncorretto \
  -t ghcr.io/r-gld/maven-with-texlive:corretto .

# IBM Semeru Runtime
docker build \
  --build-arg JDK_TYPE=ibm-semeru-jamvm \
  -t ghcr.io/r-gld/maven-with-texlive:semeru .
```

#### Using Java 17

```bash
docker build \
  --build-arg JAVA_VERSION=17 \
  -t ghcr.io/r-gld/maven-with-texlive:java17 .
```

#### Using Ubuntu Instead of Alpine

```bash
docker build \
  --build-arg DISTRO=jammy \
  -t ghcr.io/r-gld/maven-with-texlive:ubuntu .
```

**Note**: When using non-Alpine distributions, you may need to modify the package installation command in the Dockerfile (replace `apk add` with `apt-get install` for Debian/Ubuntu-based images).

## Pushing to GitHub Packages

### Using the Script

When you run `./build-docker-image.sh`, you'll be prompted:

```
Do you want to push the image(s) to GitHub Container Registry? (y/N):
```

- Press `y` to push
- Press `n` or Enter to cancel

### Manual Push

```bash
# Push arm64 version
docker push ghcr.io/r-gld/maven-with-texlive:arm64

# Push amd64 version (with latest tag)
docker push ghcr.io/r-gld/maven-with-texlive:amd64
docker push ghcr.io/r-gld/maven-with-texlive:latest
```

## Troubleshooting

### Build Fails

```bash
# Clean Docker cache
docker system prune -a
```

### Unsupported Architecture

The build script supports `x86_64/amd64` and `arm64/aarch64`. If you encounter an error about unsupported architecture, please build manually using the commands above.

## Package Registry

This image is publicly available at:
- **GitHub Packages**: https://github.com/users/R-Gld/packages/container/package/maven-with-texlive

## Use Cases

This image is ideal for projects that need to:
- Build Java/Maven projects
- Generate PDF documentation from LaTeX sources
- Automate report generation in CI/CD pipelines
- Support multilingual LaTeX documents

## License

This Dockerfile configuration is provided as-is for public use.

## Contributing

This is a simple utility image. If you encounter issues or have suggestions, please feel free to fork and modify for your needs.
