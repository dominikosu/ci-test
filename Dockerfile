FROM adoptopenjdk/openjdk11

WORKDIR /usr/src/app

##
# Copy app source code
##
COPY . .

##
# Build app
##
Run /bin/bash ./mvnw -B package --file pom.xml

###
# Install tomcat service
###
RUN groupadd tomcat && useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
RUN mkdir /opt/tomcat
RUN cd /tmp && curl -O https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.39/bin/apache-tomcat-8.5.39.tar.gz && tar xzvf apache-tomcat-8.5.39.tar.gz -C /opt/tomcat --strip-components=1
RUN cd /opt/tomcat && chgrp -R tomcat /opt/tomcat && chmod -R g+r conf && chmod g+x conf && chown -R tomcat webapps/ work/ temp/ logs/
RUN rm -rf /opt/tomcat/webapps/ROOT

###
# Upload app to Tomcat service
###
RUN cp /usr/target/*.war /opt/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
