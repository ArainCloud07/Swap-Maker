bash -c 'clear && \
echo "======================================" && \
echo "        ⚡ SMARTY SWAP SETUP ⚡        " && \
echo "======================================" && \
echo "" && \
echo "👉 Enter how much GB swap you want" && \
echo "" && \
read -p "💾 Swap Size (GB): " SWAP && \
echo "" && \
echo "⚙️ Setting up ${SWAP}GB swap + optimization..." && \
sleep 1 && \
swapoff -a 2>/dev/null && rm -f /swapfile && sed -i "/swapfile/d" /etc/fstab && \
fallocate -l ${SWAP}G /swapfile || dd if=/dev/zero of=/swapfile bs=1G count=${SWAP} && \
chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile && \
grep -q "/swapfile" /etc/fstab || echo "/swapfile none swap sw 0 0" >> /etc/fstab && \
sysctl vm.swappiness=50 && \
echo "vm.swappiness=50" > /etc/sysctl.d/99-swap.conf && \
echo "vm.vfs_cache_pressure=150" >> /etc/sysctl.d/99-swap.conf && \
sysctl --system && \
echo "" && \
echo "======================================" && \
echo "✅ DONE! Swap: ${SWAP}GB Activated" && \
echo "⚡ Optimized for performance" && \
echo "======================================"'
