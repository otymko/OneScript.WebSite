FROM evilbeaver/onescript:latest

COPY src /app
WORKDIR /app
RUN opm install -l

FROM evilbeaver/oscript-web:0.3.2

COPY --from=0 /app .