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

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make
RUN sudo apt-get update
RUN sudo apt-get install -y build-essential
RUN sudo apt-get install -y manpages-dev
RUN sudo apt-get install -y wget
RUN sudo apt-get install -y python3-pip
RUN sudo apt-get install -y curl
RUN sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN sudo nvm install node
RUN sudo curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee/etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee/etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok
RUN sudo export NVM_DIR="$HOME/.nvm" [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
RUN ngrok config add-authtoken 1yWkOpYU4qYD8vgayUpNdRTvRTY_6Mt1Tbmc57mRo8UWTyGJq
RUN sudo apt-get install -y default-jre
RUN sudo apt-get install -y default-jdk      

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool
# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
