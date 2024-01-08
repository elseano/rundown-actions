set -e

ARCH=$(uname -m)
SYS=$(uname -o | tr '[:upper:]' '[:lower:]')

case $SYS in
    linux)
        if command -v apk; then
            EXT=apk
            INSTALL="apk add {}"
        elif command -v yum; then
            EXT=yum
            INSTALL="yum install {}"
        elif command -v rpm; then
            EXT=rpm
            INSTALL="rpm install {}"
        elif command -v apt-get; then
            EXT=deb
            INSTALL="apt-get install {}"
        else
            EXT=tar.gz
            INSTALL="tar -xzf {} && sudo cp rundown /usr/bin"
        fi
        ;;
    
    darwin)
        EXT=tar.gz
        INSTALL="tar -xzf {} && sudo cp rundown /usr/bin"
        ;;
esac

echo "Searching for ${SYS}_${ARCH}.$EXT"

LOC=$(curl -s https://api.github.com/repos/elseano/rundown/releases/latest \
| grep "browser_download_url.*$SYS_$ARCH.$EXT" \
| head -n 1 \
| cut -d : -f 2,3 \
| tr -d \")

FNAME=`basename $LOC`

echo "Downloading $LOC..."

if command -v curl; then
  curl -L -O -k $LOC
elif command -v wget; then
  wget $LOC
else
  echo "Need wget or curl installed"
  exit 1
fi

echo "Installing $FNAME..."

CMD=`echo $INSTALL | sed "s/{}/$FNAME/g"`

echo $CMD
sh -c "$CMD"

rm $FNAME

echo "Instalation complete. Rundown at:"
which rundown