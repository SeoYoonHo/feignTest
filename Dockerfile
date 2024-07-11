# 첫 번째 스테이지: JDK 설치
FROM rockylinux:8.8 as builder

# 필수 패키지 설치 및 업데이트
RUN dnf -y update && \
    dnf -y install wget && \
    dnf clean all

# OpenJDK 17 설치
RUN wget -O jdk.tar.gz https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_linux-x64_bin.tar.gz && \
    mkdir /usr/java && \
    tar -xzf jdk.tar.gz -C /usr/java && \
    rm jdk.tar.gz

# 환경 변수 설정
ENV JAVA_HOME /usr/java/jdk-17.0.1
ENV PATH $PATH:$JAVA_HOME/bin

# 두 번째 스테이지: 애플리케이션 실행 이미지
FROM rockylinux:8.8

# 첫 번째 스테이지에서 JDK 복사
COPY --from=builder /usr/java /usr/java

# 환경 변수 설정
ENV JAVA_HOME /usr/java/jdk-17.0.1
ENV PATH $PATH:$JAVA_HOME/bin

# 애플리케이션 jar 파일 복사
ARG PROFILE=dev
ARG FILENAME=feigntest-0.0.1-SNAPSHOT.jar
ENV SERVER_ENV=${PROFILE}
ENV FILENAME=${FILENAME}
COPY ./${FILENAME} /apps/${FILENAME}

# 포트 8080 열기
EXPOSE 8080

# 애플리케이션 실행
ENTRYPOINT java -jar -Dspring.profiles.active=$SERVER_ENV /apps/$FILENAME