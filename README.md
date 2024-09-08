📊 ecmastats v1.0

ecmastats is a lightweight, real-time system monitoring tool designed for RHEL-based Linux systems. It provides an intuitive and easy-to-read overview of both CPU and memory usage across the system, offering insights into resource consumption at both the process and system-wide levels.

✨ Key Features:
      🔥 Visual Gauges for CPU & Memory: Display overall CPU and memory usage with a clean, percentage-based gauge to help you quickly assess system load.
      📊 Summarized Process Statistics: View the top 15 processes, grouped by name, for both CPU and memory usage, showing total resource consumption and percentage of the system’s total.
      👁️ Individual Process Stats: Get detailed information on the top 10 individual processes for both CPU and memory usage, helping you identify specific resource-heavy processes.
      🚀 No External Dependencies: Built using native Linux commands (top, ps, awk, bc), ecmastats requires no external libraries or downloads—making it simple to install and run.
      ⚙️ Customizable: Modify the script to suit your needs with ease.

💡 Ideal Use Cases:
      🖥️ System Monitoring: Quickly assess system performance and identify high resource-consuming processes.
      🛠️ Performance Troubleshooting: Find resource bottlenecks by viewing summarized and individual process data.
      ⚡ Efficient and Lightweight: Designed for admins and developers who want a clean and efficient monitoring tool without the overhead of larger solutions.

📦 Installation
To install and run ecmastats on RHEL:

1 - Clone the repository:
```
git clone https://github.com/edysoncarlos/ecmastats.git
```
2 - Make the script executable:
```
chmod +x ecmastats.sh
```
3 - Move it to a directory in your $PATH:
```
sudo mv ecmastats.sh /usr/local/bin/ecmastats
```
4 - Simply type in your terminal to run the tool:
```
ecmastats
```




🛠️ Requirements:

Linux (RHEL or compatible)
Bash, awk, bc, top, and ps commands (usually pre-installed on most systems)
