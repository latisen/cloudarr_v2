#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Services
SERVICES=("decypharr" "sonarr" "radarr" "plex" "prowlarr")

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to validate service name
is_valid_service() {
    for service in "${SERVICES[@]}"; do
        if [[ "$service" == "$1" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to update all services
update_all() {
    print_info "Updating all services..."
    for service in "${SERVICES[@]}"; do
        update_service "$service"
    done
}

# Function to update a specific service
update_service() {
    local service=$1
    
    if [[ "$service" == "decypharr" ]]; then
        print_info "Building Decypharr from local code..."
        docker compose build --no-cache decypharr
        if [[ $? -eq 0 ]]; then
            print_info "Recreating Decypharr container..."
            docker compose up -d decypharr
            print_info "✓ Decypharr updated successfully"
        else
            print_error "Failed to build Decypharr"
            return 1
        fi
    else
        print_info "Pulling latest image for $service..."
        docker compose pull $service
        if [[ $? -eq 0 ]]; then
            print_info "Recreating $service container..."
            docker compose up -d $service
            print_info "✓ $service updated successfully"
        else
            print_error "Failed to update $service"
            return 1
        fi
    fi
}

# Main logic
if [[ $# -eq 0 ]]; then
    # No arguments - update all
    update_all
elif [[ $# -eq 1 ]]; then
    service=$1
    if is_valid_service "$service"; then
        update_service "$service"
    else
        print_error "Unknown service: $service"
        echo "Available services: ${SERVICES[*]}"
        exit 1
    fi
else
    print_error "Invalid arguments"
    echo "Usage: $0 [service_name]"
    echo "Available services: ${SERVICES[*]}"
    echo "Example: $0 sonarr"
    echo "Example: $0 (updates all)"
    exit 1
fi

print_info "Done!"
