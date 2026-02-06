#!/bin/bash

# Script per deployare/aggiornare lo stack CloudFormation

STACK_NAME="nova-image-generator"
TEMPLATE_FILE="nova-image-generator.yaml"
REGION="us-east-1"

echo "🚀 Deploying/Updating CloudFormation Stack..."
echo "Stack Name: $STACK_NAME"
echo "Region: $REGION"
echo ""

# Verifica se lo stack esiste
aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --region $REGION \
  &>/dev/null

if [ $? -eq 0 ]; then
  echo "📦 Stack exists. Updating..."
  
  aws cloudformation update-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --capabilities CAPABILITY_IAM \
    --region $REGION
  
  if [ $? -eq 0 ]; then
    echo ""
    echo "⏳ Waiting for stack update to complete..."
    aws cloudformation wait stack-update-complete \
      --stack-name $STACK_NAME \
      --region $REGION
    
    echo ""
    echo "✅ Stack updated successfully!"
  else
    echo ""
    echo "⚠️  No updates to perform or update failed"
  fi
else
  echo "📦 Stack doesn't exist. Creating..."
  
  aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --capabilities CAPABILITY_IAM \
    --region $REGION
  
  echo ""
  echo "⏳ Waiting for stack creation to complete..."
  aws cloudformation wait stack-create-complete \
    --stack-name $STACK_NAME \
    --region $REGION
  
  echo ""
  echo "✅ Stack created successfully!"
fi

echo ""
echo "📋 Getting stack outputs..."
aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --region $REGION \
  --query 'Stacks[0].Outputs' \
  --output table

echo ""
echo "🎯 API Endpoint:"
aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --region $REGION \
  --query 'Stacks[0].Outputs[?OutputKey==`ApiEndpoint`].OutputValue' \
  --output text

echo ""
echo "✨ Done! Test your API with test-api.html"
