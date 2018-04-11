# STAGE 0 - Build the Angular application in a builder image
#--------------------------------------------------------

FROM node:9.11.1-alpine as builder

WORKDIR /app

COPY package.json /app/

RUN npm install

COPY ./ /app/

ARG env=prod

RUN npm run build -- --prod --environment $env

# STAGE 1 - Create the Prod image from the test image
#--------------------------------------------------------

FROM nginx:1.13-alpine

COPY --from=builder /app/dist/ /usr/share/nginx/html

COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf