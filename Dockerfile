#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 82
EXPOSE 444

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["React/React/React.csproj", "React/"]
RUN dotnet restore "React/React.csproj"
COPY . .
WORKDIR "/src/React/React"
RUN dotnet build "React.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "React.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "React.dll"]