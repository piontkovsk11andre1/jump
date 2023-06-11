const fs = require('fs');
const path = require('path');
const express = require('express');
const swaggerUi = require('swagger-ui-express');
const swaggerJsdoc = require('swagger-jsdoc');

// Create express server instance:
const app = express();

// Iterate over defined package directories (/packages/*):
const packages = fs.readdirSync('/packages');
packages.forEach((packageName) => {
    // Check if package has openapi.config.js file:
    const packagePath = path.join('/packages', packageName);
    // Check if this is a directory:
    if (fs.lstatSync(path.join('/packages', packageName)).isDirectory()) {
        const openapiConfigPath = path.join(packagePath, 'openapi.config.js');
        // If openapi config path was defined:
        if (fs.existsSync(openapiConfigPath)) {
            console.log(`Found package ${packageName} with openapi configuration`);
            // Load openapi.config.js file:
            const openapiConfig = require(openapiConfigPath);
            // Create swagger-jsdoc specification for this project:
            const swaggerSpec = swaggerJsdoc(openapiConfig);
            // Add swagger ui server endpoint for this schema:
            app.use(`/${packageName}`, swaggerUi.serve, swaggerUi.setup(swaggerSpec));
            console.log(`Serving /${packageName}...`)
        }
    }
});

// Listen on 80 port:
app.listen(80);