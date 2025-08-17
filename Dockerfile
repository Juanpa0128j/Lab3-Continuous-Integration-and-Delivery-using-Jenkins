FROM node:latest
WORKDIR /opt
COPY . /opt
RUN npm install
ENTRYPOINT ["npm", "run", "start"]
RUN apt-get update && apt-get upgrade -y && apt-get clean