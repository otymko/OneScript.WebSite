FROM evilbeaver/onescript:dev

COPY src /app
WORKDIR /app
RUN opm install -l

FROM evilbeaver/oscript-web:0.5.0

COPY --from=0 /app .