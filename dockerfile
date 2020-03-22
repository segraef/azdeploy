FROM mcr.microsoft.com/azure-cli:latest

COPY entry.sh /

RUN chmod +x /entry.sh

ENTRYPOINT ["/entry.sh"]