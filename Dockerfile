FROM ubuntu:22.04

# Set the working directory
WORKDIR /home/ubuntu/app

# Copy the application files into the container
COPY . .

# Install necessary packages and update PATH
RUN apt-get update && apt-get install -y \
    fortune-mod \
    cowsay \
    netcat \
    && chmod +x ./wisecow.sh \
    && chmod 777 /home/ubuntu/app

# Set the PATH environment variable
ENV PATH=$PATH:/usr/games

# Expose the application port
EXPOSE 4499

# Run the application
CMD ["./wisecow.sh"]
