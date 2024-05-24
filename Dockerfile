# Build stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy the .csproj file and restore the dependencies
COPY ["GreetingDisplay_TypeInYourText/GreetingDisplay_TypeInYourText.csproj", "GreetingDisplay_TypeInYourText/"]
RUN dotnet restore "GreetingDisplay_TypeInYourText/GreetingDisplay_TypeInYourText.csproj"

# Copy the rest of the application code
COPY . .

WORKDIR "/src/GreetingDisplay_TypeInYourText"
RUN dotnet build "GreetingDisplay_TypeInYourText.csproj" -c Release -o /app/build
RUN dotnet publish "GreetingDisplay_TypeInYourText.csproj" -c Release -o /app/publish

# Final stage
FROM nginx:alpine AS final
COPY --from=build /app/publish/wwwroot /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]