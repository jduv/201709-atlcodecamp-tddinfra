import boto3
import unittest
import json
import botocore

bucketName = '7factor.io'
class WebsiteBucketTest(unittest.TestCase):
    def setUp(self):
        self.s3 = boto3.resource('s3')

    def test_bucketExists(self):
        buckets = self.s3.buckets.all()
        self.assertIn(bucketName, map(lambda x: x.name, buckets))

    def test_bucketAclPublic(self):
        bucketPolicy = self.s3.BucketPolicy(bucketName)
        policyDoc = json.loads(bucketPolicy.policy)
        self.assertEquals(policyDoc['Statement'][1]['Effect'], "Allow")
        self.assertEquals(policyDoc['Statement'][1]['Action'], "s3:GetObject")

    def test_bucketServesWebsites(self):
        website = self.s3.BucketWebsite(bucketName)
        try:
            website.load()
        except botocore.exceptions.ClientError as e:
            if e.response['Error']['Code'] == 'NoSuchWebsiteConfiguration':
                self.fail()

if __name__ == '__main__':
    unittest.main()
