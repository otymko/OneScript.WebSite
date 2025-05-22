FROM evilbeaver/onescript:1.9.2

COPY src /app
WORKDIR /app
RUN opm install -l

FROM evilbeaver/oscript-web:0.9.3

COPY --from=0 /app .