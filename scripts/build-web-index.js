#!/usr/bin/env node

/**
 * Build script to generate web/index.html from web/index.html.template
 * This replaces environment variables from .env file
 *
 * Usage: node scripts/build-web-index.js
 */

const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

// Load .env file
const envPath = path.join(__dirname, '..', '.env');
const envExamplePath = path.join(__dirname, '..', '.env.example');

let envVars = {};

// Try to load .env
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf-8');
  envVars = dotenv.parse(envContent);
} else if (fs.existsSync(envExamplePath)) {
  console.warn('⚠️  .env file not found. Using .env.example');
  const envContent = fs.readFileSync(envExamplePath, 'utf-8');
  envVars = dotenv.parse(envContent);
} else {
  console.error('❌ Neither .env nor .env.example found!');
  process.exit(1);
}

// Read template
const templatePath = path.join(__dirname, '..', 'web', 'index.html.template');
const outputPath = path.join(__dirname, '..', 'web', 'index.html');

if (!fs.existsSync(templatePath)) {
  console.error(`❌ Template file not found: ${templatePath}`);
  process.exit(1);
}

let htmlContent = fs.readFileSync(templatePath, 'utf-8');

// Replace variables
Object.keys(envVars).forEach(key => {
  const placeholder = `{{${key}}}`;
  htmlContent = htmlContent.replaceAll(placeholder, envVars[key]);
});

// Write output
fs.writeFileSync(outputPath, htmlContent, 'utf-8');
console.log(`✅ Generated: ${outputPath}`);
