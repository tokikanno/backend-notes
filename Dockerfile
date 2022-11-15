FROM node:lts-alpine

RUN npm i docsify-cli -g

WORKDIR /docs
