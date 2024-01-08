set -e

ARCH=$(uname -m)
SYS=$(uname -o | tr '[:upper:]' '[:lower:]')

EXT=tar.gz
INSTALL="tar -xzf"

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

$INSTALL $FNAME

mkdir -p ~/.rundown/bin
cp rundown ~/.rundown/bin/
echo "PATH=$HOME/.rundown/bin:$PATH" >> $GITHUB_ENV