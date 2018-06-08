FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 12779
EXPOSE 44380

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY AspNetCore21Angular6WithSSR.csproj ./
RUN dotnet restore /AspNetCore21Angular6WithSSR.csproj
COPY . .
WORKDIR /src/
RUN dotnet build AspNetCore21Angular6WithSSR.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish AspNetCore21Angular6WithSSR.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "AspNetCore21Angular6WithSSR.dll"]
