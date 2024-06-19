# Use a base image that supports ARM64 architecture
FROM openjdk:11-jre-slim

# Set environment variables for Spark
ENV SPARK_VERSION=3.5.1
ENV HADOOP_VERSION=3
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Install dependencies and Spark
RUN apt-get update && apt-get install -y curl procps \
    && curl -L https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar -xz -C /opt \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

# Set up a work directory
WORKDIR /app

# Copy the application code (if any)
# COPY . /app

# Default command to start Spark shell
CMD ["spark-shell"]
