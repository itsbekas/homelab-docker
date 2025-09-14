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
sudo mkdir -p /data/cross-seed/{links,output}
sudo chown -R "$(whoami):$(whoami)" /data
sudo chmod -R a=,a+rX,u+w,g+w /data


# Custom setups
source ./util.sh

for dir in */; do
    if [ -f "${dir}setup.sh" ]; then
        echo "Running setup.sh in ${dir}"
        set_directory "$dir"
        source "${dir}setup.sh"
    fi
done
