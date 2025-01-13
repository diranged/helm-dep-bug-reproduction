# Helm Dependency Bug

Given a fresh environment without any Helm repos added, running `helm
dependency build` will fail:


## Reproduction

```bash
% docker build . -t helm-bug
[+] Building 0.3s (13/14)                                                                                                                    docker:orbstack
 => [internal] load build definition from Dockerfile                                                                                                    0.0s
 => => transferring dockerfile: 580B                                                                                                                    0.0s
 => [internal] load metadata for docker.io/library/ubuntu:latest                                                                                        0.0s
 => [internal] load .dockerignore                                                                                                                       0.0s
 => => transferring context: 2B                                                                                                                         0.0s
 => [ 1/10] FROM docker.io/library/ubuntu:latest                                                                                                        0.0s
 => [internal] load build context                                                                                                                       0.0s
 => => transferring context: 58.66kB                                                                                                                    0.0s
 => CACHED [ 2/10] RUN apt-get update && apt-get install apt-transport-https curl gpg --yes                                                             0.0s
 => CACHED [ 3/10] RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg                                    0.0s
 => CACHED [ 4/10] RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ a  0.0s
 => CACHED [ 5/10] RUN apt-get update && apt-get install helm                                                                                           0.0s
 => CACHED [ 6/10] RUN mkdir -p /tmp/chart                                                                                                              0.0s
 => CACHED [ 7/10] WORKDIR /tmp/chart                                                                                                                   0.0s
 => [ 8/10] COPY . /tmp/chart                                                                                                                           0.1s
 => ERROR [ 9/10] RUN helm dependency build .                                                                                                           0.2s
------                                                                                                                                                       
 > [ 9/10] RUN helm dependency build .:                                                                                                                      
0.162 Error: no cached repository for file://./charts/istiod-pinned-version found. (try 'helm repo update'): open /root/.cache/helm/repository/file:/charts/istiod-pinned-version-index.yaml: no such file or directory
------
Dockerfile:13
--------------------
  11 |     COPY . /tmp/chart
  12 |     
  13 | >>> RUN helm dependency build .
  14 |     RUN helm template . 
  15 |     
--------------------
ERROR: failed to solve: process "/bin/sh -c helm dependency build ." did not complete successfully: exit code: 1
```
