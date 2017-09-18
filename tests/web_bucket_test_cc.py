import boto3
import unittest
import json
import botocore

bucketName = 'cc2017tdd'
class S3WebsiteBucketTest(unittest.TestCase):
    def setUp(self):
        self.s3 = boto3.resource('s3')

    def test_bucketExists(self):
        buckets = self.s3.buckets.all()
        self.assertIn(bucketName, map(lambda x: x.name, buckets))
    
    def test_bucketHasPublicAcl(self):
        bucketPolicy = self.s3.BucketPolicy(bucketName)
        policyDoc = json.loads(bucketPolicy.policy)
        self.assertEquals(policyDoc['Statement'][1]['Effect'], "Allow")
        self.assertEquals(policyDoc['Statement'][1]['Action'], "s3:GetObject")

if __name__ == '__main__':
    unittest.main()
