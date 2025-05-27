# Environment Configuration

This document explains how to configure different environments for the SIGEDIN application.

## Available Environments

1. **Development** (`dev`)
   - Base URL: `http://10.0.2.2:8000` (Android emulator)
   - For local development

2. **Staging** (`staging`)
   - Base URL: `https://staging.api.yourdomain.com`
   - For testing with staging server

3. **Production** (`prod`)
   - Base URL: `https://api.yourdomain.com`
   - For production deployment

## Setting Up Environment

1. **Using the setup script**
   Run the following command to set up the environment:
   ```bash
   # For development
   ./scripts/set_env.sh dev

   # For staging
   ./scripts/set_env.sh staging

   # For production
   ./scripts/set_env.sh prod
   ```

   This will create/update the `.env` file in the project root.

2. **Manual Setup**
   Create a `.env` file in the project root with the following content:
   ```
   API_BASE_URL=your_base_url_here
   ENV=environment_name  # development, staging, or production
   ```

## Environment Variables

- `API_BASE_URL`: The base URL for API requests
- `ENV`: Current environment (development, staging, production)

## Notes

- The `.env` file is in `.gitignore` and should not be committed to version control.
- For team development, create a `.env.example` file with placeholder values as a template.
- Environment-specific configurations can be accessed through the `EnvConfig` class.
