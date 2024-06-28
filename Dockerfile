# Stage 1: Build Environment
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /App

# Copy csproj and restore as distinct layers
# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Stage 2: Build runtime image
# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /App/out .

# Set environment variable to ensure the application listens on port 80
ENV ASPNETCORE_URLS=http://+:80

# Set the entry point
ENTRYPOINT ["dotnet", "DockerSample.dll"]
