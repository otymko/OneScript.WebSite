FROM evilbeaver/oscript-web:dev

COPY files/semver-0.5.1.ospx /files/semver-0.5.1.ospx
RUN opm install -f /files/semver-0.5.1.ospx

COPY src /app

RUN cd /app
RUN opm install -l