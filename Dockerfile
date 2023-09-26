FROM julia:1.9.3

WORKDIR /opt
COPY ./Project.toml /opt
COPY ./Manifest.toml /opt

# Set environment variables
ENV JULIA_PROJECT=/opt/
ENV JULIA_DEPOT_PATH /opt/env

RUN julia --project
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'

# Copy your source files and entrypoint script
COPY src ./src
COPY ./entry_point.sh /opt/


# Make the entrypoint script executable
RUN chmod +x /opt/entry_point.sh

# Set the working directory
WORKDIR /opt/src


# Switch to a non-root user
ENV TMPDIR /opt/src
RUN chown -R 1000:1000 /opt/src
RUN chmod -R 777 /opt/src

USER 1000

# Set the entrypoint
ENTRYPOINT ["/opt/entry_point.sh"]
