FROM node:20-alpine
WORKDIR /opt
COPY . /opt
RUN npm install
ENTRYPOINT ["npm", "run", "start"]
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*