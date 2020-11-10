FROM nginx

#COPY nginx.conf /etc/nginx/nginx.conf
#COPY server.key /tmp/
#COPY server.crt /tmp/
COPY index.html /usr/share/nginx/html/index.html
COPY index.yaml /usr/share/nginx/html/index.yaml

#EXPOSE 443
EXPOSE 80

ENTRYPOINT [ "/docker-entrypoint.sh", "nginx", "-g", "daemon off;"]