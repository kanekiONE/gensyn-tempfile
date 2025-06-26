#!/bin/bash

# Update and install necessary packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof tmux

# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update && sudo apt install -y nodejs

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list > /dev/null
sudo apt update && sudo apt install -y yarn

#firewall
sudo apt install ufw -y
sudo ufw allow 22
sudo ufw allow 3000/tcp
sudo ufw enable -y

# Install Cloudflare
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb

# Clone the repo
git clone https://github.com/gensyn-ai/rl-swarm.git


sed -i 's|rm -r $ROOT_DIR/modal-login/temp-data/|# rm -r $ROOT_DIR/modal-login/temp-data/|' /root/rl-swarm/run_rl_swarm.sh


# Start tmux session and run script
tmux new-session -d -s rl_swarm "cd rl-swarm && python3 -m venv .venv && source .venv/bin/activate && chmod +x run_rl_swarm.sh && ./run_rl_swarm.sh"

tmux split-window -h -t rl_swarm

tmux send-keys -t rl_swarm:0.1 "cloudflared tunnel --url localhost:3000" C-m

echo "rl-swarm setup is complete and running inside a tmux session called 'rl_swarm'."

tmux attach


