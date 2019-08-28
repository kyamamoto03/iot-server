FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .

COPY iot-server/*.csproj ./iot-server/
RUN dotnet restore iot-server

# copy everything else and build app

COPY iot-server ./iot-server/
WORKDIR /app/iot-server
RUN dotnet publish -c Release -o out


FROM microsoft/dotnet:2.2-aspnetcore-runtime

WORKDIR /app

COPY --from=build /app/iot-server/out ./

EXPOSE 80

ENTRYPOINT ["dotnet", "iot-server.dll"]