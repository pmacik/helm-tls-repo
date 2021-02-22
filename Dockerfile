FROM nginx

#COPY nginx.conf /etc/nginx/nginx.conf
#COPY server.key /tmp/
#COPY server.crt /tmp/

#RUN mkdir -p /usr/share/nginx/html/nginx/0.1.0 && curl https://charts.mirantis.com/charts/nginx-0.1.0.tgz -o /usr/share/nginx/html/nginx/0.1.0/nginx-0.1.0.tgz
RUN curl https://charts.mirantis.com/charts/nginx-0.1.0.tgz -o /usr/share/nginx/html/nginx-0.1.0.tgz

COPY index.html /usr/share/nginx/html/index.html
COPY index.yaml /usr/share/nginx/html/index.yaml


#EXPOSE 443
EXPOSE 80

ENTRYPOINT [ "/docker-entrypoint.sh", "nginx", "-g", "daemon off;"]