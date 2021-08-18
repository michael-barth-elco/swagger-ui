# Looking for information on environment variables?
# We don't declare them here — take a look at our docs.
# https://github.com/swagger-api/swagger-ui/blob/master/docs/usage/configuration.md

FROM nginx:1.19-alpine

RUN apk --no-cache add nodejs

LABEL maintainer="Michael Barth"

ENV API_KEY "**None**"
ENV SWAGGER_JSON "/app/swagger.json"
ENV PORT 8080
ENV BASE_URL ""
ENV SWAGGER_JSON_URL ""
ENV URL "openapi/iothub.yaml"
ENV DEEP_LINING "true"
ENV DEFAULT_MODEL_EXPAND_DEPTH 5
ENV DOC_EXPANSION "none"
ENV FILTER "true"
ENV DOM_ID "#iothub"

# copy rest doku
COPY ./openapi/iothub.yaml /usr/share/nginx/html/openapi/
COPY ./openapi/modules /usr/share/nginx/html/openapi/modules

COPY ./docker/nginx.conf ./docker/cors.conf /etc/nginx/

# copy swagger files to the `/js` folder
COPY ./dist/* /usr/share/nginx/html/
COPY ./docker/run.sh /usr/share/nginx/
COPY ./docker/configurator /usr/share/nginx/configurator

RUN chmod +x /usr/share/nginx/run.sh && \
    chmod -R a+rw /usr/share/nginx && \
    chmod -R a+rw /etc/nginx && \
    chmod -R a+rw /var && \
    chmod -R a+rw /var/run

EXPOSE 8080

CMD ["sh", "/usr/share/nginx/run.sh"]
