#FROM sensus/centos
FROM centos:8


ARG jdkDistribution="OpenJDK11U-jdk_x64_linux_11.0.11_9.tar.gz"
ARG packageServer="http://csap-dev01.lab.sensus.net"
ARG javaVersion="openjdk-11.0.9"
ARG javaHome="/java-local/$javaVersion"

#
# note: reference ${PATH} from env will cause windows maven builds to fail
#
ENV JAVA_HOME="$javaHome" \
	PATH="$javaHome/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
	startCommand="java" \
	javaOptions="-version" \
	javaTarget="" \
	SPACER="\n___________________________________\n\n"

SHELL ["/bin/bash", "-c"]

RUN echo -e "$SPACER \
	shell:  $SHELL \n \
	path: $PATH \n \
	$SPACER"

RUN echo -e "$SPACER \
	installing:  core os tools $SPACER" && \
	yum -y install wget which unzip && \
	echo -e "$SPACER"


	
#	&& yum -y update bind-license


WORKDIR "/java-local"	
ADD $packageServer/java/$jdkDistribution .

RUN echo -e "$SPACER \
	installing:  java $SPACER" && \
	tar -xzf OpenJDK*.tar.gz && \
	rm -rf jdk*.tar.gz && \
	mv *openjdk* $javaVersion


ADD runJava.sh .
RUN chmod +x runJava.sh

ENTRYPOINT [ \
	"/bin/sh",  \
	"-c", \
	"/java-local/runJava.sh" \
]

	