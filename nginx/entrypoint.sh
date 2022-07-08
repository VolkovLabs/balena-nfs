#!/usr/bin/env sh

if [ ! -d "${NFS_MOUNT_POINT}" ]; then
    echo "Creating the ${NFS_MOUNT_POINT} mount point..."
    mkdir -p ${NFS_MOUNT_POINT}
fi

echo "${NFS_HOST}:${NFS_HOST_MOUNT} ${NFS_MOUNT_POINT} ${NFS_VERSION} hard,nolock 0 0" > /etc/fstab

echo "Mounting NFS = ${NFS_MOUNT_POINT}..."
while ( ! df | grep "${NFS_HOST}:${NFS_HOST_MOUNT}" > /dev/null; ) && [ ! "${NFS_MOUNT_SKIP}" ]; do
    sleep 5
    mount ${NFS_MOUNT_POINT}
done

exec /docker-entrypoint.sh "$@"
