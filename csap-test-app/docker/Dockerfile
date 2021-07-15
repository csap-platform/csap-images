FROM csap/csap-java:11.0.4.x


ARG jarVersion="2-SNAPSHOT"
ARG jarType="csap-snapshots"

#ARG jarVersion="2.3.2.2"
#ARG jarType="csap-release"


ARG jarName="csap-starter-tester-$jarVersion.jar"
ARG jarSource="http://devops-prod01.lab.sensus.net:8081/artifactory/$jarType/org/csap/csap-starter-tester/$jarVersion/$jarName" 


ADD $jarSource $jarName

VOLUME /tmp

# http 
EXPOSE 7080

#
# -DcsapJmxPort=8086 will auto inject all the required java jmx settings, and expose the port when launched using CSAP dashboards
#

ENV jarVersion="$jarVersion"
ENV javaOptions="-Dcsap.security.enabled=false -Dserver.servlet.context-path=/ -Xms257M -Xmx257M -Dspring.profiles.active=services-embedded -Dserver.port=7080"
ENV javaTarget="-jar $jarName"


#FROM csap/csap-java


#ARG packageServer="http://moc-artifactory.lab.sensus.net/artifactory/csap-release/org/csap/csap-starter-tester"
#ARG appVersion="2.0.0/csap-starter-tester-2.0.0.jar"

#ARG appJar="csap-test-app.jar"

#ADD $packageServer/$appVersion $appJar

#VOLUME /tmp


#EXPOSE 7080

#
# -DcsapJmxPort=8086 will auto inject all the required java jmx settings, and expose the port when launched using CSAP dashboards
#

#ENV javaOptions="-Dcsap.security.enabled=false -Dserver.servlet.context-path=/ -Xms256M -Xmx256M -Dspring.profiles.active=embedded -DcsapJmxPort=7086 -Dserver.port=7080 -jar $appJar"
