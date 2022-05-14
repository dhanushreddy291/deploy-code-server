# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash
RUN sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | sudo bash
            

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension PKief.material-icon-theme
RUN code-server --install-extension GitHub.github-vscode-theme
RUN code-server --install-extension formulahendry.code-runner

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make
RUN sudo apt-get update
RUN sudo apt-get install -y build-essential
RUN sudo apt-get install -y manpages-dev
RUN sudo apt-get install -y wget
RUN sudo apt-get install -y python3-pip
RUN sudo apt-get install -y snapd

# Java
# RUN sudo apt-get install -y default-jre
# RUN sudo apt-get install -y default-jdk

# RUN brew install nvm 
# RUN sudo echo "export NVM_DIR=~/.nvm" >> ~/.bash_profile
# RUN sudo echo "source $(brew --prefix nvm)/nvm.sh" >> ~/.bash_profile
# RUN sudo source ~/.bash_profile
# RUN sudo nvm install 

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool
# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
