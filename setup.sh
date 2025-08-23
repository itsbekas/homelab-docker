# Setup docker compose files and directories
echo "Setting up Docker Compose files..."
sudo mkdir -p /opt/docker

for dir in */; do
    if [ -f "${dir}docker-compose.yml" ]; then
        sudo mkdir -p "/opt/docker/${dir%/}"
        sudo cp -r "$dir" "/opt/docker/"
        # sudo cp "${dir}docker-compose.yml" "/opt/docker/${dir%/}/"
    fi
done

if [ -f docker-compose.yml ]; then
    sudo cp docker-compose.yml /opt/docker/
fi

sudo chown -R "$(whoami):$(whoami)" /opt/docker
sudo chmod -R 755 /opt/docker

# Setup *arr data
sudo mkdir -p /data/{downloads,media}/{books,movies,tv}
sudo chown -R "$(whoami):$(whoami)" /data
sudo chmod -R a=,a+rX,u+w,g+w /data

# Replace env variables in glance config
weather_location=$(grep '^WEATHER_LOCATION=' /opt/docker/glance/.env | cut -d'=' -f2-)
if [ -n "$weather_location" ]; then
    sed -i "s|\$WEATHER_LOCATION|$weather_location|g" /opt/docker/glance/config/home.yml
fi
