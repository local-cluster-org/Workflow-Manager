FROM ubuntu:18.04

# Vulnerability: outdated/EOL base imagefsd
FROM ubuntu:18.04

# Vulnerability: --running package installation without updatingsdfsd
RUN apt-get install -y curl wget openssh-server

# Vulnerability: installs unnecessary packages
RUN apt-get install -y gcc g++ make sudo vim netcat

# Vulnerability: hardcoded secret
ENV AWS_ACCESS_KEY_ID="AKIAEXAMPLE123456"
ENV AWS_SECRET_ACCESS_KEY="SuperSecretPassword123"

# Vulnerability: creates a privileged user
RUN useradd -m -s /bin/bash admin
RUN echo "admin:Password123!" | chpasswd
RUN usermod -aG sudo admin

# Vulnerability: exposes SSH
EXPOSE 22

# Vulnerability: insecure permissions
RUN chmod 777 /etc
RUN chmod 777 /tmp

# Vulnerability: downloads executable content without verification
RUN curl -L http://example.com/tool.sh -o /usr/local/bin/tool.sh
RUN chmod +x /usr/local/bin/tool.sh

# Vulnerability: application runs as root
USER root

COPY . /app

WORKDIR /app

CMD ["/bin/bash"]
