# TYPO3 Coolify Deployment Boilerplate

This repository contains a boilerplate setup for deploying TYPO3 CMS using Coolify as the deployment platform. It includes necessary configuration files and setup instructions for a production-ready TYPO3 installation.

## Prerequisites

- Coolify server instance
- PHP 8.3 or higher

## Project Structure

```
.
├── deployment/
│   └── config
│      └── httpd
│         └── production.conf
├── config/
│   ├── system/
│   └── sites/
├── packages/
├── public/
├── var/
├── vendor/
├── composer.json
├── composer.lock
├── .env
└── docker-compose.yml
```

## Quick Start

1. Configure your Coolify deployment:
    - Create a new service in Coolify
    - Connect your repository

## Environment Variables

Required environment variables for your Coolify deployment:

```
HTTP_PRODUCTION_DOMAIN
HTTP_PRODUCTION_ROOT
HTTP_STAGING_DOMAIN
HTTP_STAGING_ROOT
DB_HOST=your-database-host
DB_NAME=your-database-name
DB_USER=your-database-user
DB_PASSWORD=your-database-password

```

Those variables should be added your Coolfiy configuration under "Environment Variables".

## Database Configuration

The database configuration is handled through environment variables and the following configuration in `config/system/settings.php`:

```php
    'DB' => [
        'Connections' => [
            'Default' => [
                'charset' => 'utf8mb4',
                'driver' => 'mysqli',
                'dbname' => getenv('DB_NAME'),
                'host' => getenv('DB_HOST'),
                'password' => getenv('DB_PASSWORD'),
                'port' => 3306,
                'tableoptions' => [
                    'charset' => 'utf8mb4',
                    'collate' => 'utf8mb4_unicode_ci',
                ],
                'user' => getenv('DB_USER'),
            ],
        ],
    ],
```

You should add a new database resource to your project environment and connect to that.

## Deployment

### Build Process

The build process is defined in `Dockerfile`:

1. Composer dependencies are installed
2. TYPO3 installation is optimized
3. Unnecessary development files are removed

### Deployment Steps

1. Push your changes to the repository
2. Coolify will automatically:
    - Build the Docker image
    - Deploy the new version
    - Handle zero-downtime deployment

## Security

- All sensitive information should be stored as environment variables
- Production passwords should never be committed to the repository
- Regular security updates should be performed

## Troubleshooting

Common issues and solutions:

1. **Deployment fails**: Check Coolify logs for detailed error messages
2. **Database connection issues**: Verify environment variables and network settings
3. **Cache problems**: Clear all caches and verify file permissions

## Open TODOs

Right now, there is no simple way to add TYPO3 Console Commands to the deployment, as the external DB Service can't be interpreted by Coolify.

