# Use a full python base image
FROM python:3.8

ENV MODE=dev
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies for general Python dev and specific needs for packages with native extensions
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python packages in a way that ensures build dependencies are present
RUN pip install --upgrade pip setuptools wheel Cython
RUN pip install PyYAML==5.4

# If PyYAML installs successfully, add the rest of the requirements
COPY ./requirements.txt /app/requirements.txt
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
