FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /src
COPY ["forecast.csproj", "./"]
RUN dotnet restore "forecast.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "forecast.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "forecast.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "forecast.dll"]
