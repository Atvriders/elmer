# Elmer — static site (interactive connection guide + data downloads) served by nginx.
FROM nginx:1.27-alpine

LABEL org.opencontainers.image.title="Elmer" \
      org.opencontainers.image.description="Source-audited ham radio catalog + interactive connection-settings finder" \
      org.opencontainers.image.source="https://github.com/Atvriders/elmer" \
      org.opencontainers.image.licenses="MIT"

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Static content (landing, interactive guide, and all data files)
COPY index.html connection-guide.html \
     ham_radios.csv ham_software.csv \
     sound_card_interfaces.csv cat_control_interfaces.csv \
     radio_connection_profiles.csv software_connection_profiles.csv \
     connection_recipes.csv AUDIT_DISCREPANCIES.csv \
     CONNECTION_RULES.md ham_radio_master.xlsx \
     /usr/share/nginx/html/

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost/healthz || exit 1
