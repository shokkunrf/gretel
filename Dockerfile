FROM openjdk:14-alpine

WORKDIR /botan
COPY /src/eula.txt ./

RUN wget 'https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar'
RUN java -Xmx512M -Xms512M -jar server.jar nogui
