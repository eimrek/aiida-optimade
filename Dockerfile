FROM python:3.10

WORKDIR /app

# Install specific optimade and aiida-core versions
ARG OPTIMADE_TOOLS_VERSION=0.17.2
# FIXME when production version released
ARG AIIDA_VERSION=2.0.1

# Copy repo contents
COPY setup.py setup.json README.md requirements*.txt ./
COPY aiida_optimade ./aiida_optimade

RUN pip install -U pip setuptools wheel \
    && pip install optimade==${OPTIMADE_TOOLS_VERSION} \
    && pip install aiida-core==${AIIDA_VERSION} \
    && pip install -e .

# Copy Materials Cloud configuration
COPY mcloud ./mcloud

EXPOSE 80

ARG CONFIG_FILE=aiida_optimade/config.json
COPY ${CONFIG_FILE} ./config.json
ENV OPTIMADE_CONFIG_FILE /app/config.json

COPY .docker/run.sh ./

CMD ["/app/run.sh"]
