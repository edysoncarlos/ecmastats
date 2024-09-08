#!/bin/bash

# ecmastats v1.0

# Function to get the total and used CPU percentage using top
get_cpu_usage() {
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')  # % idle
    cpu_used=$(echo "100 - $cpu_idle" | bc)  # % used
    echo "$cpu_used"
}

# Function to get total, used memory, and swap in GB using free
get_memory_and_swap_usage() {
    # Extract total and used memory, and swap in GB
    total_mem=$(free -g | awk '/^Mem:/ {print $2}')
    used_mem=$(free -g | awk '/^Mem:/ {print $3}')
    total_swap=$(free -g | awk '/^Swap:/ {print $2}')
    used_swap=$(free -g | awk '/^Swap:/ {print $3}')
    echo "$used_mem $total_mem $used_swap $total_swap"
}

# Function to generate a visual gauge for CPU, memory, or swap usage
generate_gauge() {
    local usage=$1
    local total=$2
    local length=20
    local filled_length=$(echo "($usage * $length) / $total" | bc)
    local gauge=""
    
    for ((i=0; i<$filled_length; i++)); do
        gauge+="="
    done
    for ((i=$filled_length; i<$length; i++)); do
        gauge+=" "
    done
    
    echo "[$gauge] $(printf "%3.0f" $(echo "$usage / $total * 100" | bc -l))% of 100%"
}

# Function to display header with total vs used CPU, memory, and swap
display_header() {
    cpu_used=$(get_cpu_usage)
    read used_mem total_mem used_swap total_swap <<< $(get_memory_and_swap_usage)

    echo -e "=== ecmastats v1.0 ==="
    echo -e "CPU Usage: $(generate_gauge $cpu_used 100)"
    echo -e "Memory Usage: $(generate_gauge $used_mem $total_mem) ($used_mem/$total_mem GB)"
    echo -e "Swap Usage: $(generate_gauge $used_swap $total_swap) ($used_swap/$total_swap GB)"
    echo "---------------------------------------------------------------"
}

# Function to get summarized memory usage by process name, limited to top 15
get_summarized_memory_usage() {
    total_mem_kb=$(free -k | awk '/^Mem:/ {print $2}')
    
    echo -e "\nSummarized Memory Usage by Process Name (Top 15):"
    echo -e "Process Name\t\tMemory Usage (MB)\tPercentage (%)"
    echo "---------------------------------------------------------------"

    ps -eo comm,rss --no-headers | 
    awk -v total_mem_kb="$total_mem_kb" '
    {
        procname[$1] += $2
    }
    END {
        for (name in procname) {
            mem_usage_mb = procname[name] / 1024
            mem_percentage = (procname[name] / total_mem_kb) * 100
            printf "%-25s %12.2f MB %12.2f%%\n", name, mem_usage_mb, mem_percentage
        }
    }' | sort -k2 -nr | head -n 15
}

# Function to get summarized CPU usage by process name, limited to top 15
get_summarized_cpu_usage() {
    echo -e "\nSummarized CPU Usage by Process Name (Top 15):"
    echo -e "Process Name\t\tCPU Usage (%)"
    echo "---------------------------------------------------------------"

    ps -eo comm,%cpu --no-headers | 
    awk '
    {
        procname[$1] += $2
    }
    END {
        for (name in procname) {
            printf "%-25s %12.2f %%\n", name, procname[name]
        }
    }' | sort -k2 -nr | head -n 15
}

# Function to get individual memory usage for top 10 processes
get_individual_memory_usage() {
    echo -e "\nIndividual Memory Usage (Top 10 Processes):"
    echo -e "PID\tProcess Name\t\tMemory Usage (MB)"
    echo "--------------------------------------------------------------------"

    ps -eo pid,comm,rss --no-headers | 
    awk '
    {
        printf "%-7s %-20s %12.2f MB\n", $1, $2, $3 / 1024
    }' | sort -k3 -nr | head -n 10
}

# Function to get individual CPU usage for top 10 processes
get_individual_cpu_usage() {
    echo -e "\nIndividual CPU Usage (Top 10 Processes):"
    echo -e "PID\tProcess Name\t\tCPU Usage (%)"
    echo "--------------------------------------------------------------------"

    ps -eo pid,comm,%cpu --no-headers | 
    awk '
    {
        printf "%-7s %-20s %12.2f %%\n", $1, $2, $3
    }' | sort -k3 -nr | head -n 10
}

# Display the header and process statistics
display_header
get_summarized_memory_usage
get_summarized_cpu_usage
get_individual_memory_usage
get_individual_cpu_usage
