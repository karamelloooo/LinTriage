# LinTriage
                                                                  
LinTriage is a forensic script for Linux designed to quickly collect useful information and artifacts from a target machine, facilitating triage and investigative analysis.

✨ Features

- Extraction of system information (hostname, uptime, active users, running processes, etc.).
- Collection of system logs and security events.
- Identification of active network connections and open ports.
- Memory dump and other relevant artifacts.

📦 Installation

Clone the repository:

git clone https://github.com/karamelloooo/LinTriage.git

cd LinTriage

Ensure execution permissions:

chmod +x lintriage.sh

🚀 Usage

Run the script with root privileges for complete results:

sudo ./lintriage.sh [OPTIONS]

Options:

  -h, --help         Show this help message and exit
  
  -md, --memorydump  Collect a full memory dump (using AVML)
  
  -o,  --output DIR  Specify output directory (default: forensic_logs_YYYYMMDD_HHMMSS)

Example:

  lintriage.sh --memorydump --output /mnt/triage

🔧 Dependencies

LinTriage uses several system tools to gather information. Make sure you have installed:

- ps, netstat, lsof, who, uptime
- dmesg, journalctl (for log collection)

You can install any missing packages with:

sudo apt install <package_name>  # Debian/Ubuntu

sudo yum install <package_name>  # CentOS/RHEL

📜 License

This project is licensed under the MIT License. You are free to use, modify, and distribute it, as long as the original copyright notice is included in all copies or substantial portions of the software.

🤝 Contributions

Pull requests are welcome! For major changes, please open an issue first to discuss the proposed modifications.

📧 Contact

Author: Karim Guenichi

Linkedin: https://www.linkedin.com/in/karamellowav/
