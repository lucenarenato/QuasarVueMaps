FROM node:20-alpine as global-deps-stage
RUN npm i --location=global @quasar/cli@latest

FROM global-deps-stage as develop-stage
WORKDIR /src
COPY package.json ./
COPY yarn.lock ./
COPY . .

FROM develop-stage as local-deps-stage
RUN yarn

FROM local-deps-stage as build-stage
RUN quasar build -m ssr

FROM node:20-alpine as production-stage
ENV TZ=America/Sao_Paulo
RUN apk add --no-cache tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezon
WORKDIR /app
COPY --from=build-stage /src/dist/ssr .
RUN tree
RUN yarn --prod
EXPOSE 3000
CMD ["node", "index.js"]

# FROM local-deps-stage as build-stage
# RUN quasar build -m pwa

# FROM nginx:stable-alpine as production-stage
# COPY --from=build-stage /app/dist/pwa /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
