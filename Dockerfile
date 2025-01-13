FROM ubuntu:latest

RUN apt-get update && apt-get install apt-transport-https curl gpg --yes
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list

RUN apt-get update && apt-get install helm
RUN mkdir -p /tmp/chart
WORKDIR /tmp/chart

COPY . /tmp/chart

RUN helm dependency build .
RUN helm template . 
