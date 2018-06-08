FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 12779
# EXPOSE 44380

ENV NODE_VERSION 8.11.2
ENV NODE_DOWNLOAD_SHA 67dc4c06a58d4b23c5378325ad7e0a2ec482b48cea802252b99ebe8538a3ab79
ENV NODE_DOWNLOAD_URL https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz
RUN curl -SL "$NODE_DOWNLOAD_URL" --output nodejs.tar.gz \
    && echo "$NODE_DOWNLOAD_SHA nodejs.tar.gz" | sha256sum -c - \
    && tar -xzf "nodejs.tar.gz" -C /usr/local --strip-components=1 \
    && rm nodejs.tar.gz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

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
