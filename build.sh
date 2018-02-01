sudo rm -rf priv/firmware/
sudo rm -rf priv/build/hub/
docker-compose build
docker-compose run iot_gateway  mix do deps.get, firmware
