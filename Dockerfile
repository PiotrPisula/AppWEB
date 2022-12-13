FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5205

ENV ASPNETCORE_URLS=http://+:5205

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["AppWEB.csproj", "./"]
RUN dotnet restore "AppWEB.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AppWEB.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AppWEB.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AppWEB.dll"]
