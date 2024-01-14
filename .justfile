# Installs development tooling for documentation
install-dev-tools:
	aftman install
	npm install
	cargo binstall moonwave

# Extract documentation from the main repository using moonwave
extract-documentation COMMIT="":
	lune run download "{{COMMIT}}"
	lune run extract
	lune run generate

# Re-generates documentation from the main repository using moonwave
generate-documentation:
	lune run generate

# Builds and generates a static site directory
build:
	npm run build

# Starts a local development server for the docs site
dev:
	npm run dev
