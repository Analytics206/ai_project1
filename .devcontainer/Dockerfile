FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install development tools specified in .devcontainer.json
RUN pip install --no-cache-dir pylint flake8 black jupyter

# Set up workspace
WORKDIR /workspace

# Keep container running
CMD ["sleep", "infinity"]