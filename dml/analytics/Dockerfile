FROM postgres:15

EXPOSE 5432
ENV POSTGRES_PASSWORD password

RUN mkdir -p /opt/work
WORKDIR /opt/work
COPY . .
