#!/bin/bash

set -x

declare -A mountpoints=([xvdv]=/var/lib/resonata/mongodb [xvdw]=/home/centos/resonata [xvdx]=/var/lib/resonata/rabbitmq)

for device in "$${!mountpoints[@]}"; do
	# Wait while volume is ready to mount
	until lsblk|grep -q "$$device";do
		sleep 5;
	done

	# Wipe the EBS devices, only if is not ext4 yet.
	if ! blkid -t TYPE=ext4 | grep "/dev/$$device"; then
		wipefs -fa "/dev/$$device" && mkfs.ext4 "/dev/$$device"
	fi

	# mount volume
	mkdir -p -m 000 "$${mountpoints[$$device]}"
	if ! grep -q "$${mountpoints[$$device]}" /etc/fstab; then
		echo "/dev/$$device $${mountpoints[$$device]} ext4    defaults,nofail 0       2" | tee -a /etc/fstab
	fi
done

mount -a

if ! docker --version; then
	yum install -y yum-utils \
		device-mapper-persistent-data \
		lvm2 git

	yum-config-manager \
		--add-repo \
		https://download.docker.com/linux/centos/docker-ce.repo

	yum install -y docker-ce

	systemctl enable docker
	systemctl start docker

	groupadd docker
	chown root:docker /var/run/docker.sock
	usermod -aG docker centos
fi

if ! docker-compose --version; then
	compose_url="https://github.com/docker/compose/releases/download/1.16.1/docker-compose-$$(uname -s)-$$(uname -m)"
	curl -L "$$compose_url" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
fi

echo "10.10.6.29 stash.jiveland.com" >> /etc/hosts
echo "10.160.4.127 docker.phx1.jivehosted.com" >> /etc/hosts
