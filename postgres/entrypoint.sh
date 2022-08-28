#!/usr/bin/env bash

if [ -z "${STORAGE_LABEL}" ]; then
    echo "Using the default STORAGE_LABEL value"
    STORAGE_LABEL=storage
fi

echo "STORAGE_LABEL=${STORAGE_LABEL}"

if [ -z "${STORAGE_MOUNT_POINT}" ]; then
    echo "Using the default STORAGE_MOUNT_POINT value"
    STORAGE_MOUNT_POINT=/mnt/nvme
fi

if [ -z "${NFS_SYNC_MODE}" ]; then
    echo "Using the default (async) NFS_SYNC_MODE value"
    NFS_SYNC_MODE=async
fi

echo "STORAGE_MOUNT_POINT=${STORAGE_MOUNT_POINT}"

device=$(blkid | grep "LABEL=\"${STORAGE_LABEL}\"" | cut -d : -f 1)

if [ ! -d "${STORAGE_MOUNT_POINT}" ]; then
    echo "Creating the ${STORAGE_MOUNT_POINT} mount point..."
    su - -c "mkdir -p ${STORAGE_MOUNT_POINT} && chmod 777 ${STORAGE_MOUNT_POINT}" root
fi

if [ -z "${device}" ]; then
    echo "The NVMe partition was not found"

    echo "Mounting device = ${device}..."
    su - -c "mount -t tmpfs -o rw tmpfs ${STORAGE_MOUNT_POINT}" root
    mountpoint ${STORAGE_MOUNT_POINT}
else
    echo "The NVMe partition was found"

    echo "Mounting device = ${device}..."
    su - -c "mount -t ext4 -o rw ${device} ${STORAGE_MOUNT_POINT}" root
    mountpoint ${STORAGE_MOUNT_POINT}

    if [ -z "${PGDATA}" ]; then
        export PGDATA="${STORAGE_MOUNT_POINT}/postgresql/data"
    fi
fi

echo "PGDATA=${PGDATA}"

## Export NFS Mount
echo "${STORAGE_MOUNT_POINT} *(fsid=0,rw,${NFS_SYNC_MODE},no_subtree_check,all_squash,anonuid=0,anongid=0)" > /etc/exports

modprobe nfs
modprobe nfsd

## NFS Server
rm -rf /run/*
mkdir /run/openrc
touch /run/openrc/softlevel
openrc

exec docker-entrypoint.sh "$@"
