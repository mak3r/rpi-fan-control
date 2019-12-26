FROM mak3r/wiringpi:buster

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y gnupg bc

RUN curl -sfL http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add -

RUN echo 'deb http://archive.raspberrypi.org/debian/ jessie main ui' > /etc/apt/sources.list.d/raspi.list 

RUN apt-get update && \
  apt-get install -y libraspberrypi-bin

WORKDIR app
COPY app . 

ENTRYPOINT ["./temp-control.sh"]
CMD ["0", "62.0", "56.0", "5"]
