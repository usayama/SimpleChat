FROM node:lts-alpine

RUN apk update && \
    npm install -g @vue/cli
