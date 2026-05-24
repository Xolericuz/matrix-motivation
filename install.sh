#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# MATRIX MOTIVATION — AUTO INSTALLER
# ============================================
# Bu script hamma narsani avtomatik o'rnatadi
# Telefonda TERMUX + TERMUX:API + TERMUX:BOOT kerak
# ============================================

GREEN='\033[32m'
RED='\033[31m'
NC='\033[0m'

echo -e "${GREEN}"
echo "  ╔═══════════════════════════════════╗"
echo "  ║    MATRIX MOTIVATION INSTALLER    ║"
echo "  ╚═══════════════════════════════════╝"
echo -e "${NC}"

# 1. Check Termux
if [ ! -d "$PREFIX" ]; then
    echo -e "${RED}[!] Termux topilmadi. Termux o'rnating!${NC}"
    exit 1
fi

# 2. Update + install
echo "[*] Paketlar o'rnatilmoqda..."
pkg update -y
pkg install -y termux-api termux-services curl git

# 3. Permissions
echo "[*] Ruxsatlar so'ralmoqda..."
termux-notification --id install --title "MATRIX" \
    --content "O'rnatish boshlandi. Notification ruxsatini bering." \
    --priority high

# 4. Clone (agar git bo'lsa)
cd "$HOME"
if [ -d "matrix_motivation" ]; then
    echo "[*] Papka bor, yangilanmoqda..."
    cd matrix_motivation && git pull 2>/dev/null || true
else
    echo "[*] Yuklab olinmoqda..."
    git clone https://github.com/Xolericuz/matrix-motivation.git matrix_motivation 2>/dev/null || {
        echo "[!] Git clone xato. Papkani qo'lda ko'chiring."
        mkdir -p matrix_motivation
    }
fi

# 5. Virus setup
cd "$HOME/matrix_motivation"
chmod +x virus.sh

# 6. Termux:Boot
BOOT_DIR="$HOME/.termux/boot"
mkdir -p "$BOOT_DIR"

cat > "$BOOT_DIR/matrix_boot.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
cd ~/matrix_motivation
bash virus.sh &
EOF
chmod +x "$BOOT_DIR/matrix_boot.sh"

# 7. HTML ni SDCard ga
cp index.html /sdcard/MatrixMotivation.html 2>/dev/null || {
    # Fallback: internal storage
    cp index.html /storage/emulated/0/MatrixMotivation.html 2>/dev/null || true
}

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  O'RNATISH TUGADI!${NC}"
echo "========================================"
echo ""
echo "  Nima bo'ldi:"
echo "  ✓ virus.sh — asosiy script"
echo "  ✓ Termux:Boot — telefon o'chsa xam"
echo "    qayta ishga tushadi"
echo "  ✓ MatrixMotivation.html — Matrix effekt"
echo "  ✓ Internetsiz ishlaydi"
echo ""
echo "  Ishga tushirish:"
echo "  $ cd ~/matrix_motivation"
echo "  $ bash virus.sh"
echo ""
echo "  Yoki telefonni qayta yuklab"
echo "  Termux:Boot avtomatik ishga tushiradi"
echo ""
echo -e "${GREEN}========================================${NC}"

# Auto-start
read -p "Hozir ishga tushirishmi? (y/n): " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
    echo "[*] Ishga tushmoqda..."
    bash virus.sh
fi
