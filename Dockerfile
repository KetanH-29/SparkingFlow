# -------------------------------------------------------
# Base Image: Official Apache Airflow (Python 3.11)
# -------------------------------------------------------
FROM apache/airflow:2.9.3-python3.11

# -------------------------------------------------------
# Switch to root user to install system dependencies
# -------------------------------------------------------
USER root

# Install OpenJDK 17 (for Spark) and Git
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-17-jdk-headless git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------
# Set Java environment variables (without overwriting PATH)
# -------------------------------------------------------
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# -------------------------------------------------------
# Switch back to the airflow user
# -------------------------------------------------------
USER airflow
WORKDIR /opt/airflow

# -------------------------------------------------------
# Make sure both Airflow and pip-installed binaries are available
# -------------------------------------------------------
ENV PATH="/home/airflow/.local/bin:/usr/local/bin:${PATH}"

# -------------------------------------------------------
# Copy and install Python dependencies
# -------------------------------------------------------
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# -------------------------------------------------------
# Default working directory
# -------------------------------------------------------
WORKDIR /opt/airflow

# -------------------------------------------------------
# Default entrypoint message
# -------------------------------------------------------
CMD ["bash", "-c", "echo '✅ Airflow container is ready. Use docker-compose up to start webserver/scheduler.'"]
