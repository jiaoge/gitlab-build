FROM java:8-jdk-alpine

ENV TZ="Asia/Shanghai"
ENV LANG C.UTF-8

#RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories;\
#echo "http://mirrors.ustc.edu.cn/alpine/v3.4/community"  >> /etc/apk/repositories; \

RUN apk add --no-cache curl tar bash libstdc++ git

ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

VOLUME "$USER_HOME_DIR/.m2"


ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]

WORKDIR "/root"

CMD ["mvn"]

ARG GRADLE_VERSION=3.1

RUN wget http://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip \
  && unzip gradle-$GRADLE_VERSION-bin.zip \
  && mv gradle-$GRADLE_VERSION /usr/share/gradle \
  && rm -rf gradle-$GRADLE_VERSION-bin.zip \
  && ln -s /usr/share/gradle/bin/gradle /usr/bin/gradle

VOLUME "$USER_HOME_DIR/.gradle"


CMD ["gradle"]
