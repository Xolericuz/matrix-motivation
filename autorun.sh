# ============================================
# AUTO RUN — PC (Windows .bat + Linux .sh)
# ============================================
# Bu faylni ishga tushirsangiz:
# - Matrix HTML browserda ochiladi
# - Notificationlar avtomatik yoqiladi
# - Fullscreen rejimda ishlaydi
# ============================================

# Linux / macOS
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    xdg-open "$SCRIPT_DIR/index.html" 2>/dev/null || \
        open "$SCRIPT_DIR/index.html" 2>/dev/null || \
        sensible-browser "$SCRIPT_DIR/index.html" 2>/dev/null
    exit 0
fi

# Agar Windows bo'lsa (Git Bash orqali)
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    start "" "$SCRIPT_DIR/index.html"
    exit 0
fi

echo "Unknown OS. Open index.html manually."
