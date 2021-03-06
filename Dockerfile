FROM python:3.7-alpine
MAINTAINER Edgar Gueto

# Avoid some complications in docker...
ENV PYTHONUNBUFFERED 1

# Copy to the docker image
COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

# Create empty forlder on the docker image and switch to that as the default directory
RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

# Create a user that is going to run the app (but not to have a run directory, etc.)
# We do this for security reasons
RUN adduser -D user

# Sets the ownership in vol to the user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user
