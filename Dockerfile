FROM postgres:14.13

WORKDIR /data

COPY data .

RUN apt-get update && apt-get install unzip && unzip archive.zip && rm archive.zip && chmod 777 load load_data
