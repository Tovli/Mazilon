# Azure Web Deployment Setup

This document explains how to set up Azure Storage for static website hosting and configure GitHub Actions for automatic deployment.

## Prerequisites

1. An Azure subscription
2. Azure CLI installed locally (for initial setup)
3. GitHub repository with appropriate permissions to add secrets

## Azure Setup

### 1. Create a Resource Group

```bash
az group create --name mazilon-web --location "East US"
```

### 2. Create a Storage Account

```bash
az storage account create \
  --name mazilonweb \
  --resource-group mazilon-web \
  --location "East US" \
  --sku Standard_LRS \
  --kind StorageV2
```

### 3. Enable Static Website Hosting

```bash
az storage blob service-properties update \
  --account-name mazilonweb \
  --static-website \
  --404-document error.html \
  --index-document index.html
```

### 4. Create a Service Principal for GitHub Actions

```bash
az ad sp create-for-rbac \
  --name "mazilon-github-actions" \
  --role "Storage Blob Data Contributor" \
  --scopes "/subscriptions/<YOUR-SUBSCRIPTION-ID>/resourceGroups/mazilon-web/providers/Microsoft.Storage/storageAccounts/mazilonweb" \
  --sdk-auth
```

Save the output JSON - you'll need it for GitHub secrets.

### 5. (Optional) Set up Azure CDN

```bash
az cdn profile create \
  --name mazilon-cdn-profile \
  --resource-group mazilon-web \
  --sku Standard_Microsoft

az cdn endpoint create \
  --name mazilon-web \
  --profile-name mazilon-cdn-profile \
  --resource-group mazilon-web \
  --origin mazilonweb.z13.web.core.windows.net \
  --origin-host-header mazilonweb.z13.web.core.windows.net
```

## GitHub Secrets Configuration

Add the following secrets to your GitHub repository:

### Required Secrets

1. **AZURE_CREDENTIALS**: The JSON output from the service principal creation
   ```json
   {
     "clientId": "...",
     "clientSecret": "...",
     "subscriptionId": "...",
     "tenantId": "...",
     "activeDirectoryEndpointUrl": "...",
     "resourceManagerEndpointUrl": "...",
     "activeDirectoryGraphResourceId": "...",
     "sqlManagementEndpointUrl": "...",
     "galleryEndpointUrl": "...",
     "managementEndpointUrl": "..."
   }
   ```

2. **AZURE_STORAGE_ACCOUNT**: Your storage account name (e.g., `mazilonweb`)

3. **AZURE_RESOURCE_GROUP**: Your resource group name (e.g., `mazilon-web`)

### Optional Secrets (for CDN)

4. **AZURE_CDN_PROFILE**: Your CDN profile name (e.g., `mazilon-cdn-profile`)

5. **AZURE_CDN_ENDPOINT**: Your CDN endpoint name (e.g., `mazilon-web`)

## How to Add Secrets to GitHub

1. Go to your repository on GitHub
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add each secret with the exact name and value specified above

## Deployment Process

The web deployment will automatically trigger when:
- Code is pushed to the `main` branch
- The build completes successfully

The deployment process:
1. Builds the Flutter web application
2. Uploads the build artifacts
3. Deploys to Azure Storage static website
4. (Optional) Purges CDN cache for immediate updates

## Accessing Your Website

After successful deployment, your website will be available at:
- **Primary endpoint**: `https://<storage-account>.z13.web.core.windows.net`
- **CDN endpoint** (if configured): `https://<cdn-endpoint>.azureedge.net`

## Custom Domain Setup (Optional)

To use a custom domain:

1. Add CNAME record pointing to your storage endpoint
2. Configure custom domain in Azure Storage
3. Set up SSL certificate (Azure provides free SSL for custom domains)

## Troubleshooting

### Common Issues

1. **Deployment fails with authentication error**
   - Verify AZURE_CREDENTIALS secret is correctly formatted
   - Ensure service principal has proper permissions

2. **Files not uploading**
   - Check storage account name in secrets
   - Verify resource group exists

3. **Website shows 404 errors**
   - Ensure static website hosting is enabled
   - Check that index.html is in the root of the build output

4. **CDN not updating**
   - CDN caching can take time - purge operation should resolve this
   - Verify CDN profile and endpoint names in secrets

### Logs and Monitoring

Monitor deployments through:
- GitHub Actions logs
- Azure Portal → Storage Account → Monitoring
- Azure Portal → CDN Profile → Analytics (if using CDN)