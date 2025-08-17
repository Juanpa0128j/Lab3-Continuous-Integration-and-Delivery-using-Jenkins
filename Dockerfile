FROM node:24.6.0
WORKDIR /opt
COPY . /opt
RUN npm install
ENTRYPOINT ["npm", "run", "start"]
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*