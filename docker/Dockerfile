# Trusty Agent - Custom Branded OpenHands
# Base: Official OpenHands 0.59 image
# Adds: White theme with Tinexta InfoCert branding

FROM docker.all-hands.dev/all-hands-ai/openhands:0.59

# Metadata
LABEL maintainer="Tinexta InfoCert"
LABEL description="Trusty Agent - OpenHands with Tinexta InfoCert white theme branding"
LABEL version="0.59"

# Copy branding assets
COPY branding/custom-theme.css /app/frontend/custom-theme.css
COPY branding/favicon.ico /app/frontend/public/favicon.ico
COPY branding/favicon-16x16.png /app/frontend/public/favicon-16x16.png
COPY branding/favicon-32x32.png /app/frontend/public/favicon-32x32.png
COPY branding/favicon-48x48.png /app/frontend/public/favicon-48x48.png
COPY branding/favicon-64x64.png /app/frontend/public/favicon-64x64.png
COPY branding/favicon-128x128.png /app/frontend/public/favicon-128x128.png
COPY branding/favicon-256x256.png /app/frontend/public/favicon-256x256.png
COPY branding/tinexta-infocert-logo.svg /app/frontend/public/logo.svg

# Inject custom CSS into index.html
RUN if [ -f /app/frontend/public/index.html ]; then \
      sed -i 's/<\/head>/<link rel="stylesheet" href="\/custom-theme.css"><\/head>/' /app/frontend/public/index.html; \
    fi

# Update page title and meta description
RUN if [ -f /app/frontend/public/index.html ]; then \
      sed -i 's/<title>.*<\/title>/<title>Trusty Agent<\/title>/' /app/frontend/public/index.html && \
      sed -i 's/<meta name="description" content=".*"\/>/<meta name="description" content="Trusty Agent - AI-powered development assistant by Tinexta InfoCert"\/>/' /app/frontend/public/index.html; \
    fi

# Set environment variable for branding
ENV TRUSTY_AGENT_BRANDING=true
ENV TRUSTY_AGENT_VERSION=0.59

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

# Keep the original entrypoint
# ENTRYPOINT is inherited from base image
