# TaskCLIManager

![Python](https://img.shields.io/badge/python-3.8+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

A lightweight **command-line task manager** for adding, viewing, and exporting tasks.
Supports Python, Bash, Perl, and AWK scripts for flexible automation.

---

## 🚀 Features

* Add, edit, and delete tasks from the terminal
* Export tasks to **JSON** or **HTML**
* Multi-language support: Python, Bash, Perl, AWK
* Cross-platform and lightweight

---

## 📦 Installation

```bash
git clone https://github.com/AlekseiIvanovI/TaskCLIManager.git
cd TaskCLIManager
```

(Optional) Run the install script if provided:

```bash
./install.sh
```

---

## ⚡️ Usage

### Python CLI

```bash
./taskcli.py add "New Task"
./taskcli.py list
./taskcli.py export json > tasks.json
```

### Bash CLI

```bash
./taskcli.sh add "Another Task"
```

### Perl Export

```bash
perl export_tasks.pl > tasks.html
```

### AWK Summary

```bash
awk -f summary.awk tasks.db
```

#### Open HTML Example

```bash
./taskcli.py export html > tasks.html
xdg-open tasks.html  # Linux
open tasks.html      # macOS
```

---

## 🧢 Run Tests

```bash
./test_taskcli.sh
```

---

## ⚙️ Requirements

* **Python 3.8+**
* **Bash / POSIX shell**
* **Perl**
* **AWK**
* (Optional) `xdg-open` or equivalent to preview HTML exports

---

## 👂 Example Output

**JSON Example (`tasks.json`):**

```json
[
  {"id": 1, "title": "Finish project", "status": "pending"},
  {"id": 2, "title": "Test scripts", "status": "completed"}
]
```

**HTML Example (`tasks.html`):**

```html
<ul>
  <li>Finish project - pending</li>
  <li>Test scripts - completed</li>
</ul>
```

---

## 📜 License

This project is licensed under the **MIT License**.
You are free to **use, modify, and distribute** this code for any purpose, but the original author must be credited.
The software is provided **"as is", without any warranty or liability.

---

## 👤 Author

**Aleksei Ivanov**
