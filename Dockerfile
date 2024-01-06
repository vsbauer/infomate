# Use a specific python base image
FROM python:3.8-slim

ENV MODE=dev
ENV DEBIAN_FRONTEND=noninteractive

# Define the requirements file to use, default to requirements.txt if not specified
ARG requirements=requirements.txt

# Install system dependencies
RUN apt-get update && apt-get install --no-install-recommends -yq \
    gcc \
    libc-dev \
    libpq-dev \
    make \
    cron \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only the necessary files for installing Python dependencies
COPY ./requirements.txt /app/requirements.txt

# Upgrade pip, setuptools, wheel, and install Cython before other packages
RUN pip install --upgrade pip setuptools wheel Cython

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Now copy the rest of the app's source code
COPY . /app

# Setup crontab (ensure this is the correct path and permissions)
COPY etc/crontab /etc/crontab
RUN chmod 600 /etc/crontab

# Perform any additional Python setup if needed (like nltk downloads)
RUN python3 -c "import nltk; nltk.download('punkt')"

# Other Dockerfile commands...
# CMD [ "your", "start", "command" ]
