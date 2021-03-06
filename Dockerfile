FROM gradle:alpine
MAINTAINER y-okumura <y-okumura@nichiwa-system.co.jp>

ENV LANG ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8
ENV GRADLE_OPTS -Dorg.gradle.daemon=false -Djava.awt.headless=true -DdefaultFontName=IPAexGothic -Xmx1G

USER root
RUN echo http://dl-cdn.alpinelinux.org/alpine/v3.6/main >> /etc/apk/repositories
RUN apk --update add --no-cache graphviz=2.38.0-r6 curl fontconfig
RUN curl -O https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip
RUN mkdir -p /usr/share/fonts/NotoSansCJKjp \
  && unzip NotoSansCJKjp-hinted.zip -d /usr/share/fonts/NotoSansCJKjp/ \
  && chmod -R +r /usr/share/fonts/NotoSansCJKjp/ \
  && rm NotoSansCJKjp-hinted.zip \
  && fc-cache -fv

USER gradle
RUN fc-cache -fv
ADD build.gradle /tmp/build.gradle
RUN gradle --no-daemon -b /tmp/build.gradle setup

CMD gradle --no-daemon --stacktrace
