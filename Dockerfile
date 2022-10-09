FROM ghcr.io/proganon/srvpl:v1.0.1
COPY *.pl ./
COPY url/*.pl url/
RUN find . -name \*.pl -exec chmod -x \{\} \;
