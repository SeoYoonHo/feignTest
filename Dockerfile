FROM rockylinux:8.8

# JDK 설치를 위한 필요 패키지 설치
RUN dnf -y update && \
    dnf -y install wget

# OpenJDK 설치
RUN wget -O jdk.tar.gz https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_linux-x64_bin.tar.gz && \
    mkdir /usr/java && \
    tar -xzf jdk.tar.gz -C /usr/java && \
    rm jdk.tar.gz

ENV JAVA_HOME /usr/java/jdk-17.0.2
ENV PATH $PATH:$JAVA_HOME/bin

# 기타 필요한 명령어 추가
RUN mkdir -p /usr/lib/jvm /apps /logs /usr/share/nginx/html/nginx /tmp/itop/download && \
        ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
        yum install -y iproute procps tcpdump perf gcc perl gcc-c++ cmake wireshark which lsof net-tools strace bcc-devel \

ADD ./nginx.conf /etc/nginx/nginx.conf
COPY ./locale.conf /etc/locale.conf

CMD ["/usr/bin/bash"]

ARG PROFILE=dev
ARG FILENAME=feigntest-0.0.1-SNAPSHOT.jar

ENV SERVER_ENV=${PROFILE}

COPY ./build/libs/${FILENAME} /apps/${FILENAME}
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=${SERVER_ENV}", "/apps/${FILENAME}"]
