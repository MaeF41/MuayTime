# Makefile for deploying the Flutter web projects to GitHub

# --- Configuration ---
# Default output directory name (can be overridden when running 'make deploy')
DEFAULT_OUTPUT ?= my-flutter-web-app
# Replace this with your GitHub username
GITHUB_USER ?= MaeF41
# Base href for the web app (used for routing)
BASE_HREF ?= /$(OUTPUT)/
# --- End Configuration ---

# Derived variables (do not modify)
GITHUB_REPO = https://github.com/$(GITHUB_USER)/$(OUTPUT)
BUILD_VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')

# --- Targets ---

# Deploy the Flutter web project to GitHub
deploy: check-output clean build deploy-to-git print-success

# Check if OUTPUT is set, otherwise use the default
check-output:
ifndef OUTPUT
	$(eval OUTPUT := $(DEFAULT_OUTPUT))
	@echo "OUTPUT not set. Using default: $(OUTPUT)"
endif

# Clean the project
clean:
	@echo "🧹 Cleaning project..."
	flutter clean

# Build the Flutter web project
build:
	@echo "📦 Building for web..."
	flutter pub get
	flutter create . --platforms=web # Use --platforms instead of --platform
	flutter build web --base-href $(BASE_HREF) --release

# Deploy the built web app to the GitHub repository
deploy-to-git:
	@echo "🚀 Deploying to git repository..."
	cd build/web && \
	git init && \
	git add . && \
	git commit -m "Deploy Version $(BUILD_VERSION)" && \
	git branch -M main && \
	git remote add origin $(GITHUB_REPO) && \
	git push -u -f origin main

# Print success message
print-success:
	@echo "✅ Finished deploy: $(GITHUB_REPO)"
	@echo "🌐 Flutter web URL: https://$(GITHUB_USER).github.io/$(OUTPUT)/"

# --- Phony Targets ---
.PHONY: deploy check-output clean build deploy-to-git print-success