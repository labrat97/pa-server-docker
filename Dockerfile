from ubuntu:20.04



### Get the required dependencies for running and patching the server ###
# Running as container root, mark as so
env USER=root

# Update to current source list
run apt-get update

# Set up tzdata in its special non-interactive environment
run DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install tzdata -y

# Install the rest of the dependencies
run apt-get install golang libsdl2-2.0-0 libgl1 libstdc++6 libcurl4-gnutls-dev libuuid1 -y



### Download and install the DRM free version of the PAT server ###
# Login details for PANet
arg USERNAME
arg PASSWORD

# Add the patching script to the container and download the DRM free server 
add ./papatcher.go /.
run go run /papatcher.go -dir /pat -stream stable -update-only -username $USERNAME -password $PASSWORD



### Setup the server entrypoint ###
# Server running defaults
arg MAX_PLAYERS=6
arg MAX_SPECTATORS=6
arg DEFAULT_SPECTATORS=4
arg SERVER_NAME="Docked Base"
arg SERVER_PASS="d"
arg PORT=20545

# Start the server
entrypoint /pat/stable/server \
	--allow-lan --game-mode PAExpansion1:config --headless --mt-enabled \
	--server-name $SERVER_NAME \
	--server-password $SERVER_PASS \
	--max-players $MAX_PLAYERS \
	--max-spectators $MAX_SPECTATORS \
	--spectators $DEFAULT_SPECTATORS \
	--port $PORT

