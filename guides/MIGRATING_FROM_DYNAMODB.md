# Guide: Migrating from a Legacy S3+DynamoDB Backend

This guide is for teams who are currently using the older Terraform S3 backend pattern with a dedicated DynamoDB table for state locking. The modern, recommended approach is to use S3's native locking, which is simpler, cheaper, and more resilient.

### Historical Context

In older versions of Terraform and AWS, S3 did not provide the strong consistency guarantees it does today. To prevent race conditions where two developers might apply changes simultaneously and corrupt the state, a separate, strongly-consistent database (DynamoDB) was used to manage a "lock file."

Today, AWS S3 provides strong read-after-write consistency, and the Terraform S3 backend has built-in support for native object locking. This makes the external DynamoDB table redundant.

### Step 1: Add Permissions for Migration

The user or role performing the migration will temporarily need permissions for both the old and new systems. Ensure your IAM policy includes the DynamoDB permissions.

```json
{
    "Sid": "AllowDynamoDBStateLocking",
    "Effect": "Allow",
    "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
    ],
    "Resource": "arn:aws:dynamodb:<REGION>:<ACCOUNT_ID>:table/<YOUR_DYNAMODB_TABLE_NAME>"
}
