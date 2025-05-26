# Use the official nginx image
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy your website static files into nginx web dir
COPY . /usr/share/nginx/html/

# Expose port 8088
EXPOSE 8088

# Start nginx (done automatically by base image)