FROM --platform=linux/amd64 nginx:stable-alpine3.21-perl
COPY build /usr/share/nginx/html