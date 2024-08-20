# Use a minimal base image like Alpine
FROM alpine:3.18

# Install necessary packages: fortune, cowsay, and netcat
RUN apk add --no-cache fortune cowsay netcat-openbsd

# Create a non-root user and group, and switch to this user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Set the working directory
WORKDIR /app

# Copy the wisecow.sh script to the container
COPY --chown=appuser:appgroup wisecow.sh .

# Make the script executable
RUN chmod +x wisecow.sh

# Expose the port your application runs on
EXPOSE 4499

# Run the script
CMD ["./wisecow.sh"]
