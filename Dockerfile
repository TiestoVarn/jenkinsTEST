FROM node:7.8.0
WORKDIR /opt
ADD . /opt
EXPOSE 3001
#RUN npm install
ENTRYPOINT npm run start