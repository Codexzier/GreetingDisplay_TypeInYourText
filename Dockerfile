# Build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy the .csproj file and restore the dependencies
COPY ["ExampleBlazorProject/ExampleBlazorProject.csproj", "ExampleWebAssembly/"]
RUN dotnet restore "ExampleBlazorProject/ExampleBlazorProject.csproj"

# Copy the rest of the application code
COPY . .

WORKDIR "/src/ExampleBlazorProject"
RUN dotnet build "ExampleBlazorProject.csproj" -c Release -o /app/build
RUN dotnet publish "ExampleBlazorProject.csproj" -c Release -o /app/publish

# Final stage
FROM nginx:alpine AS final
COPY --from=build /app/publish/wwwroot /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]