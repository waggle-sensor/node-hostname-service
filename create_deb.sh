#!/bin/bash -e

BASEDIR=$(mktemp -d)
NAME=waggle-node-hostname
ARCH=all

# add package description
mkdir -p ${BASEDIR}/DEBIAN
cat <<EOF > ${BASEDIR}/DEBIAN/control
Package: ${NAME}
Version: ${VERSION_LONG}
Maintainer: sagecontinuum.org
Description: Service to set the hostname on Waggle nodes.
Architecture: ${ARCH}
Priority: optional
Depends: python3-click
EOF

# add control files
cp -p deb/install/postinst ${BASEDIR}/DEBIAN/
cp -p deb/install/prerm ${BASEDIR}/DEBIAN/

# add core files
cp -r ROOTFS/etc ${BASEDIR}/
mkdir -p ${BASEDIR}/usr/bin
sed -e "s/{{VERSION}}/${VERSION_LONG}/; w ${BASEDIR}/usr/bin/waggle_node_hostname.py" ./ROOTFS/usr/bin/waggle_node_hostname.py
chmod +x ${BASEDIR}/usr/bin/waggle_node_hostname.py


# build deb
dpkg-deb --root-owner-group --build ${BASEDIR} "${NAME}_${VERSION_SHORT}_${ARCH}.deb"
mv *.deb /output/
