FROM quay.io/fedora/fedora-bootc:43

RUN <<EOF
# base rpms
dnf install -y tcpdump pciutils man vim-enhanced btop tuned tmux \
    cockpit cockpit-ws cockpit-files cockpit-networkmanager cockpit-ostree cockpit-podman cockpit-system
dnf remove -y avahi

# AMD
dnf install -y amdsmi rocm-smi rocminfo

# AI
dnf install -y toolbox podman podlet ramalama python3-huggingface-hub

dnf clean all
rm -rf /var/log/dnf5.log*
EOF

COPY overlays/user/ /

RUN <<EOF
chmod 755 /etc/ssh/authorized_keys
chmod 644 /etc/ssh/authorized_keys/*
chown root:root /etc/ssh/authorized_keys/*
EOF

RUN bootc container lint
