FROM nginx:latest
LABEL name="vilayilarun@gmail.com"
COPY ./sample.html /usr/share/nginx/html/index.html
