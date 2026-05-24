#!/data/data/com.termux/files/usr/bin/bash
GREEN='\033[32m'
RED='\033[31m'
NC='\033[0m'

echo -e "${GREEN}"
echo "  ╔═══════════════════════════════════╗"
echo "  ║    MATRIX MOTIVATION INSTALLER    ║"
echo "  ╚═══════════════════════════════════╝"
echo -e "${NC}"

if [ ! -d "$PREFIX" ]; then
    echo -e "${RED}[!] Faqat Termux'da ishlaydi${NC}"
    exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"
echo "[*] Papka: $DIR"

echo "[*] Paketlar o'rnatilmoqda..."
pkg update -y
pkg install -y termux-api termux-services curl git

echo "[*] Ruxsatlar so'ralmoqda..."
termux-notification --id install --title "MATRIX" \
    --content "O'rnatish boshlandi." --priority high

chmod +x "$DIR/virus.sh"

BOOT_DIR="$HOME/.termux/boot"
mkdir -p "$BOOT_DIR"

BOOT_SCRIPT="$BOOT_DIR/matrix_boot.sh"
cat > "$BOOT_SCRIPT" << BOOTEOF
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
cd "$DIR"
bash virus.sh &
BOOTEOF
chmod +x "$BOOT_SCRIPT"

cp "$DIR/index.html" /sdcard/MatrixMotivation.html 2>/dev/null || \
    cp "$DIR/index.html" /storage/emulated/0/MatrixMotivation.html 2>/dev/null || true

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  O'RNATISH TUGADI!${NC}"
echo "========================================"
echo ""
echo "  ✓ virus.sh — asosiy script"
echo "  ✓ Termux:Boot — telefon o'chsa qayta ishga tushadi"
echo "  ✓ Internetsiz ishlaydi"
echo ""
echo "  Ishga tushirish:"
echo "  $ bash $DIR/virus.sh"
echo ""

read -p "Hozir ishga tushirishmi? (y/n): " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    echo "[*] Ishga tushmoqda..."
    bash "$DIR/virus.sh"
fi
