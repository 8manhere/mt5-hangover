# mt5-hangover
How to install mt5 in tiny container 08/24/2026
put mt5 installer in "downloads" folder

## 🚀 Install

Copy command di bawah ini, lalu paste ke terminal:

```bash
wget https://raw.githubusercontent.com/8manhere/mt5-hangover/main/install-mt5-hangover.sh && chmod +x install-mt5-hangover.sh && ./install-mt5-hangover.sh
```

### 📦 Sebelum menjalankan

Pastikan installer MetaTrader 5 (`mt5setup.exe`) sudah berada di:

```text
~/Downloads
```

Script akan otomatis:

- Install Hangover 11.9
- Install dependency
- Install MetaTrader 5
- Membuat shortcut MetaTrader 5
- Membuat shortcut MetaEditor 5

## 🖥️ Create MetaTrader 5 Shortcut

Jika MetaTrader 5 sudah terinstall tetapi shortcut Desktop belum ada:

```bash
wget https://raw.githubusercontent.com/8manhere/mt5-hangover/main/create-mt5-shortcut.sh && chmod +x create-mt5-shortcut.sh && ./create-mt5-shortcut.sh
```

Setelah selesai, shortcut **MetaTrader 5** akan muncul di Desktop.
