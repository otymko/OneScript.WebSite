FROM evilbeaver/oscript-web:dev

CMD opm install -l

COPY files/semver-0.5.1.ospx /files/semver-0.5.1.ospx
CMD opm install -f /files/semver-0.5.1.ospx

COPY src /app