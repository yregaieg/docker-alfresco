FROM ubuntu
MAINTAINER Philippe Dubois 
ENV DEBIAN_FRONTEND noninteractive
RUN   apt-get update && apt-get install -y --no-install-recommends ubuntu-desktop && apt-get update && apt-get install -y wget && wget http://downloads.sourceforge.net/project/alfresco/Alfresco%20201612%20Community/alfresco-community-installer-201612-linux-x64.bin && chmod +x ./*.bin
# make root readable by others    
RUN   chmod go+r /root
COPY  passencode.py /
COPY  modifinitpass.sh /
COPY  tunesolr.sh /
COPY  tunerepo.sh /
COPY  disable-delbackup-context.xml /
RUN   chmod +x /passencode.py && chmod +x /modifinitpass.sh && chmod +x /tunesolr.sh && chmod +x /tunerepo.sh
RUN   apt-get update && apt-get install -y curl
COPY  waitready.sh /
RUN   chmod +x /waitready.sh
COPY  entry.sh /
RUN   chmod +x /entry.sh
COPY  tuneglobal.sh /
RUN   chmod +x /tuneglobal.sh
# run the installer inside image build
RUN ./alfresco-community-installer-201612-linux-x64.bin --mode unattended --alfresco_admin_password admin --prefix /opt/alfresco
RUN rm ./alfresco-community-installer-201612-linux-x64.bin 
RUN mv /opt/alfresco/alf_data /opt/alfresco/alf_data_back
RUN mkdir /opt/alfresco/alf_data
COPY  amps/*.amp  /opt/alfresco/amps/
COPY  amps_share/*.amp  /opt/alfresco/amps_share/
# apply amps
COPY  apply_amps_unatended.sh /opt/alfresco/
RUN   chmod +x /opt/alfresco/apply_amps_unatended.sh
RUN /opt/alfresco/apply_amps_unatended.sh

COPY install.sh /
CMD ["/entry.sh"]


