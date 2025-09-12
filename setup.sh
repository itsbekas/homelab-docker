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

donetick/setup.sh
