FROM n8nio/runners:2.33.3

USER root
# SOLVED BY https://github.com/n8n-io/n8n/commit/25d0d12871e79d22eb55b94b3b7ac9457760478c
ARG PNPM_VERSION=10.32.1
RUN corepack enable pnpm && corepack prepare "pnpm@${PNPM_VERSION}" --activate
RUN cd /opt/runners/task-runner-javascript && pnpm add moment uuid
RUN cd /opt/runners/task-runner-python && uv pip install numpy pandas
COPY n8n-task-runners.json /etc/n8n-task-runners.json
USER runner