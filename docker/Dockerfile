FROM grafana/grafana:8.5.3
USER root
COPY entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

ENV GF_PATHS_PLUGINS="/var/lib/grafana-plugins"
ENV GF_PROVISIONING_DATASOURCES="/etc/grafana/provisioning/datasources"

RUN apk update && \
    apk upgrade && \
    apk add udev ttf-opensans chromium curl

RUN curl -L -o aws-env.tar.gz https://github.com/telia-oss/aws-env/releases/download/v1.1.0/aws-env-1.1.0-linux-amd64.tar.gz && \
    tar -xvzf aws-env.tar.gz aws-env -C /usr/local/bin && \
    rm aws-env.tar.gz 


RUN chmod +x /usr/local/bin/aws-env

# Install plugins
ENV GF_RENDERER_PLUGIN_CHROME_BIN="/usr/bin/chromium-browser"

RUN grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install agenty-flowcharting-panel && \
    grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install grafana-clock-panel  && \
    grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install simpod-json-datasource && \
    grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install natel-discrete-panel && \
    grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install aceiot-svg-panel && \
    grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install isaozler-paretochart-panel && \
    grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install ae3e-plotly-panel && \
    grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install yesoreyeram-boomtable-panel && \
    grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" plugins install macropower-analytics-panel && \
    grafana-cli --pluginsDir "$GF_PATHS_PLUGINS" --pluginUrl "https://github.com/grafana/grafana-image-renderer/releases/download/v3.4.1/plugin-linux-x64-glibc-no-chromium.zip" plugins install grafana-image-renderer

COPY ./plugins/grafana-flowcharting/dist $GF_PATHS_PLUGINS/grafana-flowcharting

# Add Datasources
COPY ./datasources/influx.yaml $GF_PROVISIONING_DATASOURCES/influx.yaml

# Add default configuration
COPY ./grafana.ini /etc/grafana/grafana.ini

USER grafana

COPY logo.svg /usr/share/grafana/public/img/grafana_icon.svg
COPY favicon.png /usr/share/grafana/public/img/fav32.png

ENTRYPOINT ["./entrypoint.sh"]
