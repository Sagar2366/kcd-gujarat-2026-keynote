FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
COPY data.js /usr/share/nginx/html/
COPY india-map.svg /usr/share/nginx/html/
COPY img/ /usr/share/nginx/html/img/
EXPOSE 80
