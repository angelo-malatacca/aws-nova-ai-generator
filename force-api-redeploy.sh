#!/bin/bash

# Script per forzare il redeploy dell'API Gateway
# Usa questo se hai già aggiornato lo stack ma l'API non funziona ancora

STACK_NAME="nova-image-generator"
REGION="us-east-1"

echo "🔍 Getting API Gateway ID from stack..."

API_ID=$(aws cloudformation describe-stack-resources \
  --stack-name $STACK_NAME \
  --region $REGION \
  --query "StackResources[?ResourceType=='AWS::ApiGateway::RestApi'].PhysicalResourceId" \
  --output text)

if [ -z "$API_ID" ]; then
  echo "❌ Could not find API Gateway in stack"
  exit 1
fi

echo "✅ Found API Gateway: $API_ID"
echo ""
echo "🚀 Creating new deployment..."

DEPLOYMENT_ID=$(aws apigateway create-deployment \
  --rest-api-id $API_ID \
  --stage-name prod \
  --description "Manual redeploy to fix CORS - $(date)" \
  --region $REGION \
  --query 'id' \
  --output text)

if [ $? -eq 0 ]; then
  echo "✅ Deployment created: $DEPLOYMENT_ID"
  echo ""
  echo "🎯 API Endpoint:"
  echo "https://$API_ID.execute-api.$REGION.amazonaws.com/prod/generate"
  echo ""
  echo "✨ Done! Wait 10-15 seconds and test with test-api.html"
else
  echo "❌ Deployment failed"
  exit 1
fi
