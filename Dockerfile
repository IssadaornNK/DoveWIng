# Use the official Dart image as the base image
FROM dart:stable AS build

# Set the working directory
WORKDIR /app

# Copy the pubspec files
COPY pubspec.* ./
RUN dart pub get

# Copy the rest of the app's source code
COPY . .

# Build the Flutter web app
RUN flutter build web

# Use a lightweight web server image
FROM nginx:alpine

# Copy built app from the build image
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the web server
CMD ["nginx", "-g", "daemon off;"]